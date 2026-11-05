from app.modules.base.ingestion import get_vector_store


def retrieve_documents(
    query: str,
    document_id: int,
    owner_id: int,
    k: int = 4,
) -> str:
    """Find relevant chunks belonging to the given owner and document."""

    query = query.strip()

    vector_store = get_vector_store()
    documents = vector_store.similarity_search(
        query=query,
        k=k,
        filter={
            "document_id": document_id,
            "owner_id": owner_id,
        },
    )

    return "\n\n".join(document.page_content for document in documents)
