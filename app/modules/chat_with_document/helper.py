from config import (
    MODEL_NAME,
    MODEL_PROVIDER,
    REWRITE_PROMPT,
    SYSTEM_PROMPT,
    TEMPERATURE,
)
from langchain.chat_models import BaseChatModel, init_chat_model
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder


def llm() -> BaseChatModel:
    return init_chat_model(
        model=MODEL_NAME,
        model_provider=MODEL_PROVIDER,
        temperature=TEMPERATURE,
    )


main_prompt_template: ChatPromptTemplate = ChatPromptTemplate.from_messages(
    [
        ("system", SYSTEM_PROMPT),
        MessagesPlaceholder(variable_name="chat_history", optional=True),
        ("human", "{question}"),
    ]
)


rewrite_prompt_template: ChatPromptTemplate = ChatPromptTemplate.from_messages(
    [
        ("system", REWRITE_PROMPT),
        MessagesPlaceholder(variable_name="chat_history", optional=True),
        ("human", "{question}"),
    ]
)
