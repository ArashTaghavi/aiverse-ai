from threading import Lock
from typing import ClassVar
from uuid import uuid4

from fastapi import HTTPException
from langchain_core.runnables import RunnableConfig
from langgraph.types import Interrupt
from pydantic import BaseModel

from .. import CustomerSupportAgent
from ..schemas import AskRequest


class AgentExecutionManager:
    # Store thread IDs with their owner IDs and individual locks
    _threads: ClassVar[dict[str, tuple[int, Lock]]] = {}

    # Protect the shared threads dictionary from concurrent access
    _threads_lock: ClassVar[Lock] = Lock()

    def __init__(self) -> None:
        # Initialize the agent with its checkpointer
        self.agent = CustomerSupportAgent().agent

    def get_thread(
        self,
        user_id: int,
        thread_id: str | None,
    ) -> tuple[str, Lock]:
        # Prevent concurrent modifications to the threads dictionary
        with self._threads_lock:

            # Create a new conversation if no thread ID is provided
            if thread_id is None:
                thread_id = uuid4().hex
                conversation_lock = Lock()

                # Associate the new thread with its owner and lock
                self._threads[thread_id] = (user_id, conversation_lock)

                return thread_id, conversation_lock

            # Retrieve the existing conversation information
            thread_data = self._threads.get(thread_id)

            # Reject unknown conversations
            if thread_data is None:
                raise HTTPException(404, "Conversation not found")

            # Extract the conversation owner and its lock
            thread_owner_id, conversation_lock = thread_data

            # Prevent users from accessing another user's conversation
            if thread_owner_id != user_id:
                raise HTTPException(404, "Conversation not found")

            # Return the existing conversation ID and lock
            return thread_id, conversation_lock

    def get_pending_interrupts(
        self,
        config: RunnableConfig,
    ) -> list[Interrupt]:
        # Retrieve the current saved state of the agent
        agent_state = self.agent.get_state(config)

        # Collect all interrupts waiting for user input
        pending_interrupts = [
            interrupt for task in agent_state.tasks for interrupt in task.interrupts
        ]

        return pending_interrupts

    def prepare_input(
        self,
        request: AskRequest,
        pending_interrupts: list[Interrupt],
    ) -> dict:
        if pending_interrupts:
            raise HTTPException(409, "Respond to the pending confirmation first")

        return {"messages": [{"role": "user", "content": request.question}]}

    def format_response(
        self,
        agent_response: dict,
        thread_id: str,
    ) -> dict:
        # Extract interrupts returned by the agent
        active_interrupts = agent_response.get("__interrupt__", ())

        # Handle responses requiring user confirmation
        if active_interrupts:

            # Retrieve the first interrupt's payload
            first_interrupt_payload = active_interrupts[0].value

            # Extract the confirmation message
            confirmation_message = (
                first_interrupt_payload.get(
                    "message",
                    "Confirmation required",
                )
                if isinstance(first_interrupt_payload, dict)
                else "Confirmation required"
            )

            # Return pending confirmations to the frontend
            return {
                "thread_id": thread_id,
                "status": "confirmation_required",
                "message": confirmation_message,
                "blocks": [],
                "interrupts": [
                    {
                        "data": interrupt.value,
                    }
                    for interrupt in active_interrupts
                ],
            }

        # Retrieve the agent's structured response
        structured_response = agent_response["structured_response"]

        # Convert Pydantic models to dictionaries when necessary
        response_data = (
            structured_response.model_dump()
            if isinstance(structured_response, BaseModel)
            else structured_response
        )

        # Return the completed response with conversation metadata
        return {
            **response_data,
            "thread_id": thread_id,
            "status": "completed",
        }


# Create a shared manager instance to preserve agent state
agent_execution = AgentExecutionManager()
