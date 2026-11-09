from fastapi import APIRouter

from app.core.database import DbSession
from app.modules.base import RAGEngine
from app.modules.chat_with_document import ChatWithDocument

from .schemas import AskRequest, AskResponse, IngestDocumentRequest

router = APIRouter(prefix="/chat-with-document", tags=["Chat with Document"])


@router.post(
    "/ingest",
)
def ingest(request: IngestDocumentRequest):

    ingest_document(
        file_path=request.file_path,
        document_id=request.document_id,
        owner_id=request.owner_id,
    )


@router.post("/ask")
def ask(db: DbSession, request: AskRequest):
    rag = ChatWithDocument(
        db=db,
        ownership_metadata={
            "document_id": request.document_id,
            "owner_id": request.owner_id,
        },
    )
    engine = RAGEngine(rag=rag)
    answer = engine.ask(question=request.question)

    return AskResponse(answer=answer)
