from pydantic import BaseModel, ConfigDict, Field, StrictBool


class ConfirmCancelOrderRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    user_id: int = Field(gt=0)
    thread_id: str = Field(min_length=1)
    confirmed: StrictBool
