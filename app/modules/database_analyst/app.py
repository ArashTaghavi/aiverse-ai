import json
from pathlib import Path
from typing import TypedDict, cast

from app.core.database import DbSession
from langchain.messages import AIMessage, HumanMessage
from langchain_core.messages import BaseMessage
from langchain_core.prompts import ChatPromptTemplate
from pydantic import BaseModel, Field
from sqlalchemy import select, text
from sqlalchemy.exc import SQLAlchemyError

from ..base.base_rag import BaseRAG
from .config import (
    COLLECTION_NAME,
    HISTORY_TURNS,
    QUESTION,
    REFINEMENT_PROMPT,
    REFINEMENT_QUESTION,
    SYSTEM_PROMPT,
)
from .models import DatabaseChatTurn
from .models.database import Database
from .provisioning import DatabaseConnectionFactory
from .provisioning.docker import start_database
from .provisioning.script import execute_script
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
        messages: list[BaseMessage] = []

        histories = self.db.scalars(
            select(DatabaseChatTurn)
            .where(
                DatabaseChatTurn.database_id == self.database_id,
                DatabaseChatTurn.answer.is_not(None),
            )
            .order_by(DatabaseChatTurn.id.desc())
            .limit(HISTORY_TURNS)
        ).all()

        for turn in reversed(histories):
            messages.extend(
                [
                    HumanMessage(content=turn.question),
                    AIMessage(content=turn.answer),
                ]
            )

        return messages

    def create_context(self, documents):
        return Path("sql.txt").read_text(encoding="utf-8")

    async def execute_sql(self, sql: str) -> tuple[str, bool]:
        database = self.db.scalar(
            select(Database).where(
                Database.id == self.database_id,
                Database.owner_id == self.owner_id,
            )
        )

        if database is None:
            raise ValueError("Database not found")

        connection = json.loads(database.connection)
        connection.pop("container_name")

        engine = DatabaseConnectionFactory.create(**connection)

        try:
            async with engine.begin() as conn:
                result = await conn.execute(text(sql))

                if result.returns_rows:
                    rows = result.mappings().fetchmany(100)

                    output = json.dumps(
                        [dict(row) for row in rows],
                        ensure_ascii=False,
                        default=str,
                        indent=2,
                    )
                else:
                    output = json.dumps(
                        {
                            "message": "Query executed successfully.",
                            "affected_rows": result.rowcount,
                        }
                    )

                return output, True

        except SQLAlchemyError as e:
            return str(e), False

        finally:
            await engine.dispose()

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
        result_v1, success_v1 = await self.execute_sql(
            sql=initial_response.sql,
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

            final_result, success = await self.execute_sql(
                sql=final_sql,
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
