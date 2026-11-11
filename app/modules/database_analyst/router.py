import subprocess

from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from sqlalchemy import select
from sqlalchemy.exc import SQLAlchemyError
from starlette.concurrency import run_in_threadpool

from app.core.database import DbSession
from app.modules.base import RAGEngine

from . import DatabaseAnalyst
from .extract_database_schema import extract_schema_from_connection
from .models.database import Database
from .provisioning.detect_database_type import detect_database_type
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
async def ingest(db: DbSession, request: IngestDatabaseRequest):
    database = db.scalar(
        select(Database).where(
            Database.id == request.database_id,
            Database.owner_id == request.owner_id,
        )
    )
    if database is None:
        raise HTTPException(status_code=404, detail="Database not found")

    try:
        detection = await run_in_threadpool(detect_database_type, request.file_path)
        if detection.database_type is None:
            candidates = ", ".join(detection.candidates)
            raise ValueError(
                "Could not determine the database type from the SQL script."
                + (f" Possible types: {candidates}." if candidates else " No distinctive dialect markers found.")
            )
        connection = await run_in_threadpool(
            start_database, database_type=detection.database_type
        )
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
        database.database_schema = schema
        db.commit()
    except (SQLAlchemyError, OSError, ValueError) as error:
        db.rollback()
        response = DatabaseProvisionErrorResponse(
            detail=f"Schema extraction or database save failed ({type(error).__name__})."
        )
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
