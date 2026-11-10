from collections.abc import Iterator
from functools import cached_property

from langchain.chat_models import init_chat_model
from langchain_core.documents import Document
from langchain_core.messages import BaseMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder

from .vector_store_provider import vector_store_provider


class BaseRAG:
    def __init__(
        self,
        ownership_metadata: dict[str, str | int],
        collection_name: str,
        collection_metadata: dict[str, str | int] | None = None,
        is_stream=True,
    ) -> None:
        self.config = vector_store_provider.config
        self.ownership_metadata = ownership_metadata
        self.collection_name = collection_name
        self.collection_metadata = collection_metadata
        self.is_stream = is_stream

        # Create LangChain's default tables if they do not already exist.
        _ = self.vector_store

    @cached_property
    def vector_store(self):
        return vector_store_provider.get_vector_store(
            collection_name=self.collection_name,
            collection_metadata=self.collection_metadata,
        )

    @property
    def embeddings(self):
        return vector_store_provider.embeddings

    @cached_property
    def model(self):
        return init_chat_model(
            model=self.config.model_name,
            model_provider=self.config.model_provider,
            temperature=self.config.temperature,
        )

    def retrieve_documents(self, query: str) -> str:
        query = query.strip()

        documents = self.vector_store.similarity_search(
            query=query,
            k=self.config.retrieval_k,
            filter={**self.ownership_metadata},
        )

        return "\n\n".join(document.page_content for document in documents)

    @staticmethod
    def create_prompt(instructions: str) -> ChatPromptTemplate:
        return ChatPromptTemplate.from_messages(
            [
                ("system", instructions),
                MessagesPlaceholder(variable_name="chat_history"),
                ("human", "{question}"),
            ]
        )

    def create_context(self, documents: list[Document]) -> str:
        return "\n\n".join(document.page_content for document in documents)

    def rewrite_query(self, question: str, chat_history: list[BaseMessage]) -> str:
        if not chat_history:
            return question
        return self.rewrite_chain.invoke(
            {
                "question": question,
                "chat_history": chat_history,
            }
        )

    def retrieve(self, query: str) -> list[Document]:
        return self.vector_store.similarity_search(
            query=query.strip(),
            k=self.config.retrieval_k,
            filter={**self.ownership_metadata},
        )

    def generate(
        self,
        question: str,
        context: str,
        chat_history: list[BaseMessage],
    ) -> Iterator[str] | str:
        if self.is_stream == True:
            return self.answer_chain.stream(
                {
                    "question": question,
                    "context": context,
                    "chat_history": chat_history,
                }
            )
        return self.answer_chain.invoke(
            {
                "question": question,
                "context": context,
                "chat_history": chat_history,
            }
        )
