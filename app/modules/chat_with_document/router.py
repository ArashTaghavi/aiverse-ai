from fastapi import APIRouter
from fastapi.responses import StreamingResponse
from langchain_community.document_loaders import Docx2txtLoader

from app.core.database import DbSession
from app.modules.base import DocumentIndexer, RAGEngine

from . import ChatWithDocument
from .config import COLLECTION_NAME
from .schemas import AskRequest, IngestDocumentRequest

router = APIRouter(prefix="/chat-with-document", tags=["Chat with Document"])


@router.post("/ingest")
def ingest(request: IngestDocumentRequest):
    documents = Docx2txtLoader(file_path=request.file_path).load()
    indexer = DocumentIndexer(
        collection_name=COLLECTION_NAME,
        ownership_metadata={
            "document_id": request.document_id,
            "owner_id": request.owner_id,
        },
    )
    return indexer.ingest_document(documents)


@router.post("/ask")
async def ask(db: DbSession, request: AskRequest):
    rag = ChatWithDocument(
        db=db,
        ownership_metadata={
            "document_id": request.document_id,
            "owner_id": request.owner_id,
        },
    )

    engine = RAGEngine(rag=rag)

    return StreamingResponse(
        await engine.ask(question=request.question),
        media_type="text/plain; charset=utf-8",
    )
