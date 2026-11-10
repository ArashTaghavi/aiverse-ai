import subprocess

from fastapi import APIRouter
from fastapi.responses import JSONResponse

from app.core.database import DbSession
from app.modules.base import RAGEngine
from app.modules.database_analyst.app import DatabaseAnalyst
from app.modules.database_analyst.provisioning.docker import start_database
from app.modules.database_analyst.provisioning.script import execute_script
from app.modules.database_analyst.provisioning.types import DatabaseType

from .schemas import (
    AskRequest,
    AskResponse,
    DatabaseFileErrorResponse,
    DatabaseProvisionErrorResponse,
    ProvisionDatabaseResponse,
)

router = APIRouter(prefix="/database-analyst", tags=["Database Analyst"])


@router.post("/ingest")
def ingest(
    file_path: str,
    database_type: DatabaseType = "postgres",
):
    try:
        connection = start_database(database_type=database_type)
        execute_script(file_path=file_path, connection=connection)
    except (
        FileNotFoundError,
        IsADirectoryError,
        NotADirectoryError,
        PermissionError,
        ValueError,
    ) as error:
        response = DatabaseFileErrorResponse(detail=str(error))
        return JSONResponse(status_code=400, content=response.model_dump())
    except (RuntimeError, subprocess.SubprocessError, OSError) as error:
        if isinstance(error, subprocess.CalledProcessError):
            detail = error.stderr or "Docker command failed."
            if isinstance(detail, bytes):
                detail = detail.decode("utf-8", errors="replace")
        else:
            detail = str(error)
        response = DatabaseProvisionErrorResponse(detail=detail)
        return JSONResponse(status_code=500, content=response.model_dump())

    return ProvisionDatabaseResponse(**connection)


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
