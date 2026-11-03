from pathlib import Path

from langchain_community.document_loaders import Docx2txtLoader
from langchain_core.documents import Document


def load_document(file_path: str | Path) -> list[Document]:
    """Load the text and source metadata from a DOCX file."""
    loader = Docx2txtLoader(file_path=str(file_path))
    return loader.load()
