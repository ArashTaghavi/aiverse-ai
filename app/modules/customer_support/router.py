from uuid import uuid4

from fastapi import APIRouter
from langchain_core.messages import HumanMessage
from langgraph.types import Command

from . import CustomerSupportAgent
from .app import checkpointer
from .schemas import AskRequest, ConfirmCancelOrderRequest

router = APIRouter(prefix="/customer-support", tags=["Customer Support"])


@router.post("/ask")
def ask(request: AskRequest):
    agent = CustomerSupportAgent().agent
    thread_id = uuid4().hex
    response = agent.invoke(
        {
            "messages": [HumanMessage(content=request.question)],
        },
        config={
            "configurable": {
                "thread_id": thread_id,
            },
        },
        context={"user_id": request.user_id},
    )

    if interrupts := response.get("__interrupt__"):
        item = interrupts[0]

        return {
            "thread_id": thread_id,
            **item.value,
        }

    result = response["structured_response"]
    checkpointer.delete_thread(thread_id)
    return result


@router.post("/confirm-cancel-order")
def confirm_cancel_order(request: ConfirmCancelOrderRequest):
    agent = CustomerSupportAgent().agent

    response = agent.invoke(
        Command(resume={"confirmed": request.confirmed}),
        config={"configurable": {"thread_id": request.thread_id}},
        context={"user_id": request.user_id},
    )

    result = response["structured_response"]
    checkpointer.delete_thread(request.thread_id)

    return result
