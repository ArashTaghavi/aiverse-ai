from .rag_protocol import RagProtocol
from .types import RagResult


class RAGEngine:
    def __init__(self, rag: RagProtocol) -> None:
        self.rag = rag

    async def ask(self, question: str) -> RagResult:
        chat_history = self.rag.get_chat_history()
        query = self.rag.rewrite_query(question=question, chat_history=chat_history)
        documents = self.rag.retrieve(query=query)
        # _ is score
        context = self.rag.create_context(
            documents=[document for document, _ in documents]
        )

        return await self.rag.generate(
            question=question,
            context=context,
            chat_history=chat_history,
        )
