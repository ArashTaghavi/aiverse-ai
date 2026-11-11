from pathlib import Path
from typing import TypedDict, cast

from langchain_core.messages import BaseMessage
from langchain_core.prompts import ChatPromptTemplate
from pydantic import BaseModel, Field

from app.core.database import DbSession

from ..base.base_rag import BaseRAG
from .chat_history import chat_history
from .config import (
    COLLECTION_NAME,
    QUESTION,
    REFINEMENT_PROMPT,
    REFINEMENT_QUESTION,
    SYSTEM_PROMPT,
)
from .provisioning import execute_script, execute_sql, start_database
from .provisioning.types import (
    DatabaseConnection,
    DatabaseType,
)


class SQLResponse(BaseModel):
    sql: str = Field(description="The generated SQL SELECT query")
    text: str = Field(
        description="A brief explanation of the SQL query in the same language as the user's question"
    )


class SQLRefinement(BaseModel):
    needs_refinement: bool = Field(
        description="Whether the original SQL needs to be corrected"
    )
    feedback: str = Field(
        description="A brief review in the same language as the user's question"
    )
    refined_sql: str = Field(
        description="The corrected SQL SELECT query, or the original SQL if no correction is needed"
    )


class OwnershipMetadata(TypedDict):
    database_id: int
    owner_id: int


class DatabaseAnalyst(BaseRAG):
    def __init__(
        self,
        db: DbSession,
        ownership_metadata: OwnershipMetadata,
        collection_name=COLLECTION_NAME,
        collection_metadata: dict[str, str | int] | None = None,
    ) -> None:
        self.database_id = ownership_metadata["database_id"]
        self.owner_id = ownership_metadata["owner_id"]
        self.db = db

        super().__init__(
            collection_name=collection_name,
            collection_metadata=collection_metadata,
            ownership_metadata={
                "database_id": self.database_id,
                "owner_id": self.owner_id,
            },
            is_stream=False,
        )

        self.answer_chain = ChatPromptTemplate.from_messages(
            [
                ("system", SYSTEM_PROMPT),
                ("human", QUESTION),
            ]
        ) | self.model.with_structured_output(SQLResponse)

        self.refinement_chain = ChatPromptTemplate.from_messages(
            [
                ("system", REFINEMENT_PROMPT),
                ("human", REFINEMENT_QUESTION),
            ]
        ) | self.model.with_structured_output(SQLRefinement)

    def get_chat_history(self) -> list[BaseMessage]:
        return chat_history(db=self.db, database_id=self.database_id)

    def create_context(self, documents):
        return Path("sql.txt").read_text(encoding="utf-8")

    async def generate(
        self,
        question: str,
        context: str,
        chat_history: list[BaseMessage],
    ) -> dict[str, str | bool]:

        # Step 1: Generate initial SQL.
        initial_response = cast(
            SQLResponse,
            await self.answer_chain.ainvoke(
                {
                    "question": question,
                    "schema": context,
                    "chat_history": chat_history,
                }
            ),
        )

        # Step 2: Execute initial SQL.
        result_v1, success_v1 = await execute_sql(
            db=self.db,
            sql=initial_response.sql,
            database_id=self.database_id,
            owner_id=self.owner_id,
        )

        refinement_input = (
            result_v1 if success_v1 else f"SQL execution error: {result_v1}"
        )

        # Step 3: Review generated SQL.
        refine_response = cast(
            SQLRefinement,
            await self.refinement_chain.ainvoke(
                {
                    "question": question,
                    "schema": context,
                    "sql": initial_response.sql,
                    "result": refinement_input,
                }
            ),
        )

        # Step 4: Execute refined SQL if necessary.
        final_sql = initial_response.sql
        final_result = result_v1
        success = success_v1

        if refine_response.needs_refinement:
            final_sql = refine_response.refined_sql

            final_result, success = await execute_sql(
                db=self.db,
                sql=final_sql,
                database_id=self.database_id,
                owner_id=self.owner_id,
            )

        return {
            "initial_sql": initial_response.sql,
            "sql": final_sql,
            "text": initial_response.text,
            "result": final_result,
            "success": success,
            "refined": refine_response.needs_refinement,
            "feedback": refine_response.feedback,
        }

    def provision_database(
        self,
        file_path: str | Path,
        database_type: DatabaseType = "postgres",
    ) -> DatabaseConnection:
        script_path = Path(file_path).resolve(strict=True)

        if not script_path.is_file():
            raise ValueError(f"SQL script path is not a file: {script_path}")

        connection = start_database(database_type=database_type)

        execute_script(
            file_path=script_path,
            connection=connection,
        )

        return connection
