from fastapi import APIRouter

from . import CustomerSupportAgent

router = APIRouter(prefix="/customer-support", tags=["Customer Support"])


@router.post("/ask")
def ingest(question: str):
    app = CustomerSupportAgent()

    response = app.agent.invoke(
        {
            "messages": [
                {
                    "role": "user",
                    "content": question,
                }
            ]
        },
        context={"user_id": 1},
    )
    return response["messages"][-1].content
