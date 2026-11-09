from pathlib import Path
from typing import TypedDict

from langchain.messages import AIMessage, HumanMessage
from langchain_core.messages import BaseMessage
from pydantic import BaseModel, Field
from sqlalchemy import select

from app.core.database import DbSession
from app.modules.database_analyst.provisioning.docker import start_database
from app.modules.database_analyst.provisioning.script import execute_script
from app.modules.database_analyst.provisioning.types import (
    DatabaseConnection,
    DatabaseType,
)

from ..base.base_rag import BaseRAG
from .config import COLLECTION_NAME, HISTORY_TURNS, REFINEMENT_QUESTION, SYSTEM_PROMPT
from .models import DatabaseChatTurn


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
        )

        self.answer_chain = self.create_prompt(
            SYSTEM_PROMPT
        ) | self.model.with_structured_output(SQLResponse)

        self.refinement_chain = self.create_prompt(
            REFINEMENT_QUESTION
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
