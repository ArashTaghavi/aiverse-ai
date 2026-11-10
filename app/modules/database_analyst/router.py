import subprocess
from typing import cast

from app.core.database import DbSession
from app.modules.base import RAGEngine
from app.modules.database_analyst.app import DatabaseAnalyst
from app.modules.database_analyst.models.database import Database
from app.modules.database_analyst.provisioning.docker import start_database
from app.modules.database_analyst.provisioning.script import execute_script
from app.modules.database_analyst.provisioning.types import DatabaseConnection
from fastapi import APIRouter
from fastapi.responses import JSONResponse, StreamingResponse
from sqlalchemy import select

from .schemas import (
    AskRequest,
    DatabaseFileErrorResponse,
    DatabaseProvisionErrorResponse,
    IngestDatabaseRequest,
    ProvisionDatabaseResponse,
)
import json

router = APIRouter(prefix="/database-analyst", tags=["Database Analyst"])


@router.post("/ingest")
def ingest(
    request: IngestDatabaseRequest,
):
    try:
        connection = start_database(database_type="sqlserver")
        execute_script(file_path=request.file_path, connection=connection)
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
async def ask(db: DbSession, request: AskRequest):
    rag = DatabaseAnalyst(
        db=db,
        ownership_metadata={
            "database_id": request.database_id,
            "owner_id": request.owner_id,
        },
    )
    engine = RAGEngine(rag=rag)

    return await engine.ask(question=request.question)


@router.post("x")
def x(db: DbSession):
    database = db.scalar(
        select(Database).where(
            Database.id == 5,
            Database.owner_id == 1,
        )
    )
    connection = json.loads(database.connection)
    connection.pop("container_name")
    return connection
