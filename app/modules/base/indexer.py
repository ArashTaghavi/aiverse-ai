import json
from functools import cached_property

from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter
from sqlalchemy import delete, select

from .vector_store_provider import vector_store_provider


class DocumentIndexer:
    """Index documents independently of chat models, prompts, and history."""

    def __init__(
        self,
        ownership_metadata: dict[str, str | int],
        collection_name: str,
        collection_metadata: dict[str, str | int] | None = None,
    ) -> None:
        self.config = vector_store_provider.config
        self.collection_name = collection_name
        self.collection_metadata = collection_metadata
        self.ownership_metadata = ownership_metadata

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
    def text_splitter(self) -> RecursiveCharacterTextSplitter:
        return RecursiveCharacterTextSplitter(
            chunk_size=self.config.chunk_size,
            chunk_overlap=self.config.chunk_overlap,
            separators=["\n\n", "\n", " ", ""],
        )

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

        # Delete and insert together; any failure rolls back both operations.
        with vector_store_provider.engine.begin() as connection:
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
