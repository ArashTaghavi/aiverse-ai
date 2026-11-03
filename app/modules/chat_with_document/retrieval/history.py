from langchain.messages import AIMessage, HumanMessage
from langchain_core.messages import BaseMessage
from sqlalchemy import select

from app.core.database import DbSession
from app.modules.chat_with_document.models import DocumentChatTurn


def chat_history(
    db: DbSession,
    document_id: int,
) -> list[BaseMessage]:
    messages: list[BaseMessage] = []

    histories = db.scalars(
        select(DocumentChatTurn)
        .where(
            DocumentChatTurn.document_id == document_id,
            DocumentChatTurn.answer.is_not(None),
        )
        .order_by(DocumentChatTurn.id.asc())
    ).all()

    for turn in histories:
        messages.extend(
            [
                HumanMessage(content=turn.question),
                AIMessage(content=turn.answer),
            ]
        )

    return messages
