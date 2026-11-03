from langchain.chat_models import init_chat_model
from langchain_core.messages import BaseMessage
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder

from app.core.database import DbSession
from app.modules.chat_with_document.retrieval import chat_history, retrieve_documents

from .config import (
    MODEL_NAME,
    MODEL_PROVIDER,
    REWRITE_PROMPT,
    SYSTEM_PROMPT,
    TEMPERATURE,
)


class ChatWithDocument:
    def __init__(self, db: DbSession, document_id: int, owner_id: int) -> None:
        self.db = db
        self.document_id = document_id
        self.owner_id = owner_id

        self.model = init_chat_model(
            model=MODEL_NAME,
            model_provider=MODEL_PROVIDER,
            temperature=TEMPERATURE,
        )
        self.answer_chain = (
            self._create_prompt(SYSTEM_PROMPT) | self.model | StrOutputParser()
        )
        self.rewrite_chain = (
            self._create_prompt(REWRITE_PROMPT) | self.model | StrOutputParser()
        )

    @staticmethod
    def _create_prompt(instructions: str) -> ChatPromptTemplate:
        return ChatPromptTemplate.from_messages(
            [
                ("system", instructions),
                MessagesPlaceholder(variable_name="chat_history"),
                ("human", "{question}"),
            ]
        )

    def _get_history(self) -> list[BaseMessage]:
        return chat_history(
            db=self.db,
            document_id=self.document_id,
        )

    def _rewrite_question(self, question: str, history: list[BaseMessage]) -> str:
        if not history:
            return question
        return self.rewrite_chain.invoke(
            {"question": question, "chat_history": history}
        )

    def _create_context(self, query: str) -> str:
        return retrieve_documents(
            query=query,
            document_id=self.document_id,
            owner_id=self.owner_id,
        )

    def ask(self, question: str) -> str:
        history = self._get_history()
        query = self._rewrite_question(
            question=question,
            history=history,
        )
        context = self._create_context(query=query)

        return self.answer_chain.invoke(
            {
                "question": question,
                "context": context,
                "chat_history": history,
            }
        )
