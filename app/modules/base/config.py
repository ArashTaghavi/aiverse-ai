from pydantic import BaseModel, Field


class RagConfig(BaseModel):
    model_name: str = "gpt-4o-mini"
    model_provider: str = "openai"
    temperature: float = 0.0

    embedding_model: str = "text-embedding-3-small"
    embedding_length: int = 1536

    chunk_size: int = Field(default=1000, gt=0)
    chunk_overlap: int = Field(default=200, ge=0)

    retrieval_k: int = Field(default=4, gt=0)
