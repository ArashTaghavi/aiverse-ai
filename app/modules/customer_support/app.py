from datetime import datetime, timedelta, timezone

from langchain.agents import create_agent
from langchain.chat_models import init_chat_model
from langgraph.checkpoint.memory import InMemorySaver

from .context import CustomerSupportContext
from .schemas.chat_schema import ChatResponse
from .tools import (
    cancel_order,
    get_customer_order,
    get_customer_order_stats,
    get_store_policies,
)

# Shared across agent instances within this server process.
checkpointer = InMemorySaver()

SYSTEM_PROMPT = """
You are a professional customer support agent.

Rules:
- Always respond in the user's language.
- Use tools to retrieve products, orders, and store policies.
- Never invent product prices, stock levels, or order information.
- Base all business-related answers on tool results.
- Keep responses clear, concise, and helpful.
- When the customer requests order cancellation and provides an order number or
  tracking code, call cancel_order. If the identifier is missing, ask for it first.
- Let cancel_order request confirmation through its interrupt. Do not ask for
  cancellation confirmation yourself in a normal text response, and do not wait
  for a second message before calling the tool.

Response formatting:
- Always provide a user-friendly message.
- For product search results, include a products block.
- Only supported block types are products and order. Never emit an orders block.
- For complete details of a single order, include an order block.
- For multiple complete orders, include a separate order block for each order.
- For general questions, return an empty blocks list.
- For aggregate order statistics, use get_customer_order_stats and return an empty blocks list.
- Most/least expensive and first/latest order summaries from statistics belong in the message with blocks=[]. They are not complete orders and must not be converted into order blocks.
- Only include structured data supported by tool results.
"""


class CustomerSupportAgent:
    def __init__(self) -> None:
        self.model = init_chat_model(
            model="gpt-4o-mini",
            model_provider="openai",
            temperature=0,
        )

        self.tools = [
            cancel_order,
            get_store_policies,
            get_customer_order,
            get_customer_order_stats,
        ]

        self.agent = create_agent(
            model=self.model,
            tools=self.tools,
            system_prompt=SYSTEM_PROMPT
            + (
                "\nCurrent local date in Asia/Tehran (UTC+03:30): "
                f"{datetime.now(timezone(timedelta(hours=3, minutes=30))):%Y-%m-%d (%A)}.\n"
                "Resolve relative date requests against this date before calling tools. "
                "Use Gregorian YYYY-MM-DD tool arguments. For Persian requests, "
                "weeks begin on Saturday. If no period is requested, omit date filters.\n"
            ),
            response_format=ChatResponse,
            context_schema=CustomerSupportContext,
            checkpointer=checkpointer,
        )
