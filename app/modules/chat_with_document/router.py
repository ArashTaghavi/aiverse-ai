from fastapi import APIRouter
from fastapi.responses import StreamingResponse

from app.core.database import DbSession

from .ingestion import ingest_document
from .pipeline import ChatWithDocument
from .schemas import AskRequest, IngestDocumentRequest

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
async def ask(db: DbSession, request: AskRequest):
    app = ChatWithDocument(
        db=db,
        document_id=request.document_id,
        owner_id=request.owner_id,
    )

    return StreamingResponse(
        app.ask(question=request.question),
        media_type="text/plain; charset=utf-8",
    )
