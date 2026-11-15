from langchain.agents import create_agent
from langchain.chat_models import init_chat_model

from .schemas.chat_schema import ChatResponse
from .tools import get_customer_order, get_store_policies, search_product

SYSTEM_PROMPT = """
You are a professional customer support agent.

Rules:
- Always respond in the user's language.
- Use tools to retrieve products, orders, and store policies.
- Never invent product prices, stock levels, or order information.
- Base all business-related answers on tool results.
- Keep responses clear, concise, and helpful.

Response formatting:
- Always provide a user-friendly message.
- For product search results, include a products block.
- For a single order, include an order block.
- For multiple orders, include an orders block.
- For general questions, return an empty blocks list.
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
            get_store_policies,
            search_product,
            get_customer_order,
        ]

        self.agent = create_agent(
            model=self.model,
            tools=self.tools,
            system_prompt=SYSTEM_PROMPT,
            response_format=ChatResponse,
        )
