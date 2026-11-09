import json
from functools import cached_property

from langchain.chat_models import init_chat_model
from langchain_core.documents import Document
from langchain_core.messages import BaseMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_openai import OpenAIEmbeddings
from langchain_postgres.vectorstores import DistanceStrategy, PGVector
from langchain_text_splitters import RecursiveCharacterTextSplitter
from sqlalchemy import create_engine, delete, select

from app.core.config import settings

from .config import RagConfig


class BaseRAG:
    def __init__(
        self,
        ownership_metadata: dict[str, str | int],
        collection_name: str,
        collection_metadata: dict[str, str | int] | None = None,
        config: RagConfig | None = None,
    ) -> None:

        self.config = config if config is not None else RagConfig()
        self.ownership_metadata = ownership_metadata
        self.collection_name = collection_name
        self.collection_metadata = collection_metadata

        # Create LangChain's default tables if they do not already exist.
        _ = self.vector_store

    @cached_property
    def model(self):
        return init_chat_model(
            model=self.config.model_name,
            model_provider=self.config.model_provider,
            temperature=self.config.temperature,
        )

    @cached_property
    def embeddings(self):
        return OpenAIEmbeddings(
            model=self.config.embedding_model,
            dimensions=self.config.embedding_length,
        )

    @cached_property
    def vector_store(self) -> PGVector:
        return PGVector(
            embeddings=self.embeddings,
            embedding_length=self.config.embedding_length,
            collection_name=self.collection_name,
            connection=settings.DATABASE_URL,
            distance_strategy=DistanceStrategy.COSINE,
            collection_metadata=self.collection_metadata,
            use_jsonb=True,
            pre_delete_collection=False,
            create_extension=True,
        )

    @cached_property
    def text_splitter(self) -> RecursiveCharacterTextSplitter:
        return RecursiveCharacterTextSplitter(
            chunk_size=self.config.chunk_size,
            chunk_overlap=self.config.chunk_overlap,
            separators=["\n\n", "\n", " ", ""],
        )

    def retrieve_documents(self, query: str) -> str:
        query = query.strip()

        documents = self.vector_store.similarity_search(
            query=query,
            k=self.config.retrieval_k,
            filter={**self.ownership_metadata},
        )

        return "\n\n".join(document.page_content for document in documents)

    def ingest_document(self, documents: list[Document]) -> list[str]:

        chunks = [
            chunk
            for chunk in self.text_splitter.split_documents(documents)
            if chunk.page_content.strip()
        ]

        if not chunks:
            raise ValueError("The document contains no text to index.")

        ids = []

        for index, chunk in enumerate(chunks):
            metadata = {
                **self.ownership_metadata,
                "index": index,
                "collection_name": self.collection_name,
            }
            chunk.metadata.update(metadata)
            ids.append(self._id_generator(metadata))

        vectors = self.embeddings.embed_documents(
            [chunk.page_content for chunk in chunks]
        )

        self.replace_existing_chunks(chunks, vectors, ids)

        return ids

    @staticmethod
    def _id_generator(dic: dict[str, str | int]) -> str:
        # Example: ownership_metadata={"document_id": 10, "owner_id": 18},
        # index=0, collection_name="documents"
        # Output: '{"collection_name":"documents","document_id":10,"index":0,"owner_id":18}'
        return json.dumps(
            dic, sort_keys=True, ensure_ascii=False, separators=(",", ":")
        )

    def replace_existing_chunks(
        self,
        chunks: list[Document],
        vectors: list[list[float]],
        ids: list[str],
    ) -> None:
        metadata = dict(self.ownership_metadata)

        if not metadata:
            raise ValueError("Document metadata cannot be empty.")

        store = self.vector_store
        embedding_table = store.EmbeddingStore.__table__
        collection_table = store.CollectionStore.__table__

        engine = create_engine(settings.DATABASE_URL)

        try:
            # Delete and insert together; any failure rolls back both operations.
            with engine.begin() as connection:
                collection_id = connection.execute(
                    select(collection_table.c.uuid).where(
                        collection_table.c.name == self.collection_name
                    )
                ).scalar_one()

                connection.execute(
                    delete(embedding_table).where(
                        embedding_table.c.collection_id == collection_id,
                        *[
                            embedding_table.c.cmetadata[key].astext == str(value)
                            for key, value in metadata.items()
                        ],
                    )
                )

                connection.execute(
                    embedding_table.insert(),
                    [
                        {
                            "id": ids[index],
                            "collection_id": collection_id,
                            "embedding": vectors[index],
                            "document": chunk.page_content,
                            "cmetadata": chunk.metadata,
                        }
                        for index, chunk in enumerate(chunks)
                    ],
                )
        finally:
            engine.dispose()

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
    ) -> str:
        return self.answer_chain.invoke(
            {
                "question": question,
                "context": context,
                "chat_history": chat_history,
            }
        )
