from pathlib import Path

from .chunking import chunking
from .indexing import get_vector_store
from .loader import load_document


def ingest_document(
    file_path: str | Path, document_id: int, owner_id: int
) -> list[str]:
    documents = load_document(file_path=file_path)
    chunks = chunking(documents=documents)

    if not chunks or not any(chunk.page_content.strip() for chunk in chunks):
        raise ValueError("The document contains no text to index.")

    for index, chunk in enumerate(chunks):
        chunk.metadata.update(
            {
                "document_id": document_id,
                "owner_id": owner_id,
                "chunk_index": index,
            }
        )

    ids = [f"{owner_id}:{document_id}:{index}" for index in range(len(chunks))]
    vector_store = get_vector_store()

    return vector_store.add_documents(documents=chunks, ids=ids)
