from functools import lru_cache

from app.core.config import settings
from langchain_openai import OpenAIEmbeddings
from langchain_postgres.vectorstores import (
    DistanceStrategy,
    PGVector,
)

from ...chat_with_document.config import (
    COLLECTION_NAME,
    EMBEDDING_LENGTH,
    EMBEDDING_MODEL,
)


@lru_cache(maxsize=1)
def get_vector_store() -> PGVector:
    embeddings = OpenAIEmbeddings(
        model=EMBEDDING_MODEL,
    )

    return PGVector(
        embeddings=embeddings,
        embedding_length=EMBEDDING_LENGTH,
        collection_name=COLLECTION_NAME,
        connection=settings.DATABASE_URL,
        distance_strategy=DistanceStrategy.COSINE,
        collection_metadata={
            "description": "chat with document",
            "version": 1,
            "languages": "all",
        },
        use_jsonb=True,
        pre_delete_collection=False,
        create_extension=True,
    )
