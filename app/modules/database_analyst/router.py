import json
import subprocess
from pathlib import Path
from uuid import uuid4

from fastapi import APIRouter
from fastapi.responses import JSONResponse
from sqlalchemy.exc import SQLAlchemyError
from starlette.concurrency import run_in_threadpool

from app.core.database import DbSession
from app.modules.base import RAGEngine

from . import DatabaseAnalyst
from .extract_database_schema import extract_schema_from_connection
from .provisioning.docker import start_database
from .provisioning.script import execute_script
from .schemas import (
    AskRequest,
    DatabaseFileErrorResponse,
    DatabaseProvisionErrorResponse,
    IngestDatabaseRequest,
    ProvisionDatabaseResponse,
)

router = APIRouter(prefix="/database-analyst", tags=["Database Analyst"])


@router.post("/ingest")
async def ingest(request: IngestDatabaseRequest):
    try:
        connection = await run_in_threadpool(start_database, database_type="sqlserver")
        await run_in_threadpool(
            execute_script, file_path=request.file_path, connection=connection
        )
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

    try:
        schema = await extract_schema_from_connection(connection)
        schema_directory = Path(__file__).resolve().parents[3] / "uploads" / "database_schemas"
        schema_path = schema_directory / f"{request.database_id}_{uuid4().hex}.json"
        await run_in_threadpool(schema_directory.mkdir, parents=True, exist_ok=True)
        await run_in_threadpool(
            schema_path.write_text,
            json.dumps(json.loads(schema), ensure_ascii=False, indent=2),
            encoding="utf-8",
        )
    except (SQLAlchemyError, OSError, ValueError) as error:
        response = DatabaseProvisionErrorResponse(
            detail=f"Schema extraction or file save failed ({type(error).__name__})."
        )
        return JSONResponse(status_code=500, content=response.model_dump())

    return {
        **ProvisionDatabaseResponse(**connection).model_dump(),
        "schema_path": str(schema_path),
    }


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
