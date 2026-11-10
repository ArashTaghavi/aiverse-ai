from collections.abc import Iterator
from typing import Protocol

from langchain_core.documents import Document
from langchain_core.messages import BaseMessage


class RagProtocol(Protocol):
    """Synchronous RAG steps orchestrated by RAGEngine."""

    def get_chat_history(self) -> list[BaseMessage]:
        """Return previous conversation messages in chronological order."""
        ...

    def rewrite_query(self, question: str, chat_history: list[BaseMessage]) -> str:
        """Build a standalone search query from the question and chat history."""
        ...

    def retrieve(self, query: str) -> list[Document]:
        """Retrieve documents within this RAG's ownership and collection scope."""
        ...

    def create_context(self, documents: list[Document]) -> str:
        """Format retrieved documents into context for answer generation."""
        ...

    def generate(
        self,
        question: str,
        context: str,
        chat_history: list[BaseMessage],
    ) -> Iterator[str] | str:
        """Answer the original question using retrieved context and chat history."""
        ...
