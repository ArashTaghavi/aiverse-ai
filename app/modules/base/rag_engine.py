from app.modules.base.rag_protocol import RagProtocol, RagResult


class RAGEngine:
    def __init__(self, rag: RagProtocol) -> None:
        self.rag = rag

    async def ask(self, question: str) -> RagResult:
        chat_history = self.rag.get_chat_history()
        query = self.rag.rewrite_query(question=question, chat_history=chat_history)
        documents = self.rag.retrieve(query=query)
        context = self.rag.create_context(documents=documents)

        return await self.rag.generate(
            question=question,
            context=context,
            chat_history=chat_history,
        )
