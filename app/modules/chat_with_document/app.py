from typing import TypedDict

from langchain.messages import AIMessage, HumanMessage
from langchain_core.documents import Document
from langchain_core.messages import BaseMessage
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from sqlalchemy import select

from app.core.database import DbSession

from ..base.base_rag import BaseRAG
from .config import HISTORY_TURNS, REWRITE_PROMPT, SYSTEM_PROMPT
from .models import DocumentChatTurn


class OwnershipMetadata(TypedDict):
    document_id: int
    owner_id: int


class ChatWithDocument(BaseRAG):
    def __init__(
        self,
        db: DbSession,
        ownership_metadata: OwnershipMetadata,
        collection_name="chat_with_document",
        collection_metadata: dict[str, str | int] | None = None,
    ) -> None:
        self.document_id = ownership_metadata["document_id"]
        self.owner_id = ownership_metadata["owner_id"]
        self.db = db

        super().__init__(
            collection_name=collection_name,
            collection_metadata=collection_metadata,
            ownership_metadata={
                "document_id": self.document_id,
                "owner_id": self.owner_id,
            },
        )

        self.answer_chain = (
            self.create_prompt(SYSTEM_PROMPT) | self.model | StrOutputParser()
        )
        self.rewrite_chain = (
            self.create_prompt(REWRITE_PROMPT) | self.model | StrOutputParser()
        )

    def get_chat_history(self) -> list[BaseMessage]:
        messages: list[BaseMessage] = []

        histories = self.db.scalars(
            select(DocumentChatTurn)
            .where(
                DocumentChatTurn.document_id == self.document_id,
                DocumentChatTurn.answer.is_not(None),
            )
            .order_by(DocumentChatTurn.id.desc())
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
