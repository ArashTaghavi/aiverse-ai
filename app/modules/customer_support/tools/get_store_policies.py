from pathlib import Path

from langchain_core.tools import tool

KNOWLEDGE_PATH = Path("policies.txt")


@tool
def get_store_policies() -> str:
    """Get store policies about shipping, returns, refunds, cancellations,
    payments, warranties, and customer support.

    Use this tool when answering questions about store rules or policies.
    """

    return KNOWLEDGE_PATH.read_text(encoding="utf-8")
