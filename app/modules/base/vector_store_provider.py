from functools import cached_property

from langchain_openai import OpenAIEmbeddings
from langchain_postgres.vectorstores import DistanceStrategy, PGVector
from sqlalchemy import create_engine
from sqlalchemy.engine import Engine

from app.core.config import settings

from .config import RagConfig


class VectorStoreProvider:
    """Database and embedding resources shared by retrieval and ingestion."""

    def __init__(self, config: RagConfig | None = None) -> None:
        self.config = config if config is not None else RagConfig()

    @cached_property
    def engine(self) -> Engine:
        return create_engine(settings.DATABASE_URL)

    @cached_property
    def embeddings(self) -> OpenAIEmbeddings:
        return OpenAIEmbeddings(
            model=self.config.embedding_model,
            dimensions=self.config.embedding_length,
        )

    def get_vector_store(
        self,
        collection_name: str,
        collection_metadata: dict[str, str | int] | None = None,
    ) -> PGVector:
        return PGVector(
            embeddings=self.embeddings,
            embedding_length=self.config.embedding_length,
            collection_name=collection_name,
            connection=self.engine,
            distance_strategy=DistanceStrategy.COSINE,
            collection_metadata=collection_metadata,
            use_jsonb=True,
            pre_delete_collection=False,
            create_extension=True,
        )


vector_store_provider = VectorStoreProvider()
