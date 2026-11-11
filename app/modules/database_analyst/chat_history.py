from langchain.messages import AIMessage, HumanMessage
from langchain_core.messages import BaseMessage
from sqlalchemy import select

from app.core.database import DbSession

from .config import HISTORY_TURNS
from .models import DatabaseChatTurn


def chat_history(db: DbSession, database_id: int) -> list[BaseMessage]:
    messages: list[BaseMessage] = []

    histories = db.scalars(
        select(DatabaseChatTurn)
        .where(
            DatabaseChatTurn.database_id == database_id,
            DatabaseChatTurn.answer.is_not(None),
        )
        .order_by(DatabaseChatTurn.id.desc())
        .limit(HISTORY_TURNS)
    ).all()

    for turn in reversed(histories):
        messages.extend(
            [
                HumanMessage(content=turn.question),
                AIMessage(content=turn.answer),
            ]
        )

    return messages
