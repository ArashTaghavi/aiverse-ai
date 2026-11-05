from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter

from ...chat_with_document.config import CHUNK_OVERLAP, CHUNK_SIZE


def chunking(documents: list[Document]) -> list[Document]:
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=CHUNK_SIZE,
        chunk_overlap=CHUNK_OVERLAP,
        separators=["\n\n", "\n", " ", ""],
    )
    return splitter.split_documents(documents=documents)
