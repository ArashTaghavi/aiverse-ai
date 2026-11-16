from pydantic import BaseModel, Field


class AskRequest(BaseModel):
    user_id: int = Field(gt=0)
    question: str = Field(min_length=1)
