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


REWRITE_PROMPT = """
Given the conversation history and the latest user question,
rewrite the question into a standalone question that can be
understood without the conversation history.

Do not answer the question.
Do not add information that was not present in the conversation.
Preserve the original language.

If the question is already standalone, return it unchanged.

Return only the rewritten question.
"""
