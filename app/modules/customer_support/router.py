from fastapi import APIRouter
from pydantic import BaseModel

from . import CustomerSupportAgent

router = APIRouter(prefix="/customer-support", tags=["Customer Support"])


class AskRequest(BaseModel):
    user_id: int
    question: str


@router.post("/ask")
def ask(request: AskRequest):
    app = CustomerSupportAgent()

    response = app.agent.invoke(
        {
            "messages": [
                {
                    "role": "user",
                    "content": request.question,
                }
            ]
        },
        context={"user_id": request.user_id},
    )

    return response["structured_response"]
