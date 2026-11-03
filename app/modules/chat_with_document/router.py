from fastapi import APIRouter

from app.core.database import DbSession

from .ingestion import ingest_document
from .pipline import ChatWithDocument
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


@router.post("/ask", response_model=AskResponse)
def ask(db: DbSession, request: AskRequest):
    app = ChatWithDocument(
        db=db,
        document_id=request.document_id,
        owner_id=request.owner_id,
    )

    return AskResponse(answer=app.ask(question=request.question))
