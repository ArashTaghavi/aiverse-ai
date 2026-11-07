import logging
from collections.abc import AsyncIterator
from functools import lru_cache
from time import perf_counter

from langchain.chat_models import init_chat_model
from langchain_core.messages import BaseMessage
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from starlette.concurrency import run_in_threadpool

from app.core.database import DbSession
from app.modules.chat_with_document.retrieval import chat_history, retrieve_documents

from .config import (
    MODEL_NAME,
    MODEL_PROVIDER,
    REWRITE_PROMPT,
    SYSTEM_PROMPT,
    TEMPERATURE,
)

logger = logging.getLogger(__name__)


@lru_cache(maxsize=1)
def _get_model():
    return init_chat_model(
        model=MODEL_NAME,
        model_provider=MODEL_PROVIDER,
        temperature=TEMPERATURE,
    )


class ChatWithDocument:
    def __init__(self, db: DbSession, document_id: int, owner_id: int) -> None:
        self.db = db
        self.document_id = document_id
        self.owner_id = owner_id

        self.model = _get_model()
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

    async def _rewrite_question(self, question: str, history: list[BaseMessage]) -> str:
        if not history:
            return question
        return await self.rewrite_chain.ainvoke(
            {"question": question, "chat_history": history}
        )

    def _create_context(self, query: str) -> str:
        return retrieve_documents(
            query=query,
            document_id=self.document_id,
            owner_id=self.owner_id,
        )

    async def ask(self, question: str) -> AsyncIterator[str]:
        started = perf_counter()
        history = await run_in_threadpool(self._get_history)
        history_done = perf_counter()
        query = await self._rewrite_question(
            question=question,
            history=history,
        )
        rewrite_done = perf_counter()
        # PGVector and the existing database session use synchronous drivers.
        context = await run_in_threadpool(self._create_context, query=query)
        retrieval_done = perf_counter()
        logger.info(
            "Document chat preparation: history=%.3fs rewrite=%.3fs retrieval=%.3fs",
            history_done - started,
            rewrite_done - history_done,
            retrieval_done - rewrite_done,
        )

        first_chunk = True
        async for chunk in self.answer_chain.astream(
            {
                "question": question,
                "context": context,
                "chat_history": history,
            }
        ):
            if first_chunk and chunk:
                logger.info(
                    "Document chat first text: total=%.3fs generation=%.3fs",
                    perf_counter() - started,
                    perf_counter() - retrieval_done,
                )
                first_chunk = False
            yield chunk
