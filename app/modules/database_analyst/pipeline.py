from pathlib import Path
from typing import cast

from langchain.chat_models import init_chat_model
from langchain_core.prompts import ChatPromptTemplate
from pydantic import BaseModel, Field
from sqlalchemy import select

from app.core.database import DbSession

from .config import QUESTION, SYSTEM_PROMPT
from .models import Database
from .provisioning import execute_script, start_database
from .provisioning.types import DatabaseConnection, DatabaseType


class SQLResponse(BaseModel):
    sql: str = Field(description="The generated SQLite SQL query")
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
        description="The corrected SQLite SQL query, or the original SQL if no correction is needed"
    )


class DatabaseAnalyst:

    def __init__(self, db: DbSession, database_id: int, owner_id: int) -> None:
        self.database_id = database_id
        self.owner_id = owner_id

        # database = db.scalar(
        #     select(Database).where(
        #         Database.id == database_id,
        #         Database.owner_id == owner_id,
        #     ),
        # )
        # if database is None:
        #     raise ValueError("Database not found")

        self.schema = Path("sql.txt").read_text(encoding="utf-8")

        self.llm = init_chat_model(
            model="gpt-4o-mini",
            model_provider="openai",
            temperature=0,
        )

        self.prompt = ChatPromptTemplate.from_messages(
            [
                ("system", SYSTEM_PROMPT),
                ("human", QUESTION),
            ]
        )

        self.answer_chain = self.prompt | self.llm.with_structured_output(SQLResponse)

    def ask(self, question: str) -> SQLResponse:
        return cast(
            SQLResponse,
            self.answer_chain.invoke(
                {
                    "schema": self.schema,
                    "question": question,
                }
            ),
        )

    def provision_database(
        self,
        file_path: str | Path,
        database_type: DatabaseType = "postgres",
    ) -> DatabaseConnection:
        script_path = Path(file_path).resolve(strict=True)
        if not script_path.is_file():
            raise ValueError(f"SQL script path is not a file: {script_path}")

        connection = start_database(database_type=database_type)
        execute_script(file_path=script_path, connection=connection)
        return connection
