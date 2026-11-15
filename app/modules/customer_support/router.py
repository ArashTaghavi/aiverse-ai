from threading import Lock
from uuid import uuid4

from fastapi import APIRouter, HTTPException
from langgraph.types import Command
from pydantic import BaseModel, Field, StrictBool, model_validator

from . import CustomerSupportAgent

router = APIRouter(prefix="/customer-support", tags=["Customer Support"])

# Process-local, matching the lifetime of the in-memory checkpointer.
_threads: dict[str, tuple[int, Lock]] = {}
_threads_lock = Lock()


class ConfirmationRequest(BaseModel):
    interrupt_id: str = Field(min_length=1)
    confirmed: StrictBool


class AskRequest(BaseModel):
    user_id: int = Field(gt=0)
    question: str | None = Field(default=None, min_length=1)
    thread_id: str | None = Field(default=None, min_length=1)
    confirmation: ConfirmationRequest | None = None

    @model_validator(mode="after")
    def validate_action(self):
        if self.question is not None:
            self.question = self.question.strip()
            if not self.question:
                raise ValueError("question must not be blank")
        if (self.question is None) == (self.confirmation is None):
            raise ValueError("Provide either question or confirmation, exclusively")
        if self.confirmation is not None and self.thread_id is None:
            raise ValueError("thread_id is required for confirmation")
        return self


@router.post("/ask")
def ask(request: AskRequest):
    with _threads_lock:
        if request.thread_id is None:
            thread_id = uuid4().hex
            thread_lock = Lock()
            _threads[thread_id] = (request.user_id, thread_lock)
        else:
            thread_id = request.thread_id
            entry = _threads.get(thread_id)
            if entry is None or entry[0] != request.user_id:
                raise HTTPException(status_code=404, detail="Conversation not found")
            thread_lock = entry[1]

    if not thread_lock.acquire(blocking=False):
        raise HTTPException(status_code=409, detail="Conversation is already running")
    try:
        agent = CustomerSupportAgent().agent
        config = {"configurable": {"thread_id": thread_id}}
        snapshot = agent.get_state(config)
        pending = [item for task in snapshot.tasks for item in task.interrupts]

        if request.confirmation is not None:
            confirmation = request.confirmation
            target = next(
                (item for item in pending if item.id == confirmation.interrupt_id), None
            )
            if target is None:
                raise HTTPException(status_code=409, detail="Confirmation is no longer pending")
            payload = target.value
            if not isinstance(payload, dict) or payload.get("type") != "order_cancellation_confirmation":
                raise HTTPException(status_code=409, detail="Unsupported confirmation type")
            # Use the saved order ID, never an order ID supplied by the client.
            graph_input = Command(resume={target.id: {
                "confirmed": confirmation.confirmed,
                "order_id": payload["order_id"],
            }})
        else:
            if pending:
                raise HTTPException(status_code=409, detail="Respond to the pending confirmation first")
            graph_input = {"messages": [{"role": "user", "content": request.question}]}

        response = agent.invoke(
            graph_input, config=config, context={"user_id": request.user_id}
        )
        interrupts = response.get("__interrupt__", ())
        if interrupts:
            return {
                "thread_id": thread_id,
                "status": "confirmation_required",
                "message": interrupts[0].value.get("message", "Confirmation required"),
                "blocks": [],
                "interrupts": [{"interrupt_id": item.id, "data": item.value} for item in interrupts],
            }
        result = response["structured_response"]
        data = result.model_dump() if isinstance(result, BaseModel) else result
        return {**data, "thread_id": thread_id, "status": "completed"}
    finally:
        thread_lock.release()
