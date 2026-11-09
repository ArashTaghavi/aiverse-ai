from fastapi import APIRouter
from langchain_community.document_loaders import Docx2txtLoader

from app.core.database import DbSession
from app.modules.base import RAGEngine
from app.modules.base.ingestion import DocumentIndexer
from app.modules.database_analyst.app import DatabaseAnalyst

from .config import COLLECTION_NAME
from .schemas import AskRequest, AskResponse, IngestDocumentRequest

router = APIRouter(prefix="/database-analyst", tags=["Database Analyst"])


@router.post(
    "/ingest",
)
def ingest(request: IngestDocumentRequest):
    documents = Docx2txtLoader(file_path=request.file_path).load()
    indexer = DocumentIndexer(
        collection_name=COLLECTION_NAME,
        ownership_metadata={
            "database_id": request.database_id,
            "owner_id": request.owner_id,
        },
    )
    return indexer.ingest_document(documents)


@router.post("/ask")
def ask(db: DbSession, request: AskRequest):
    rag = DatabaseAnalyst(
        db=db,
        ownership_metadata={
            "database_id": request.database_id,
            "owner_id": request.owner_id,
        },
    )
    engine = RAGEngine(rag=rag)
    answer = engine.ask(question=request.question)
    return AskResponse(answer=answer)
