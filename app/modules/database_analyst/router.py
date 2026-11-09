import subprocess

from fastapi import APIRouter
from fastapi.responses import JSONResponse

from app.core.database import DbSession

from .pipeline import DatabaseAnalyst
from .provisioning.types import DatabaseType
from .schemas import (
    AskRequest,
    DatabaseFileErrorResponse,
    DatabaseProvisionErrorResponse,
    ProvisionDatabaseResponse,
)

router = APIRouter(prefix="/database-analyst", tags=["Database Analyst"])


@router.post(
    "/ingest",
    response_model=ProvisionDatabaseResponse,
    responses={
        400: {"model": DatabaseFileErrorResponse},
        500: {"model": DatabaseProvisionErrorResponse},
    },
)
def ingest(
    file_path: str,
    database_type: DatabaseType = "postgres",
):
    app = DatabaseAnalyst()

    try:
        connection = app.provision_database(
            file_path=file_path,
            database_type=database_type,
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

    return ProvisionDatabaseResponse(**connection)


@router.post("/ask")
async def ask(db: DbSession, request: AskRequest):
    app = DatabaseAnalyst(
        db=db,
        database_id=request.database_id,
        owner_id=request.owner_id,
    )

    return app.ask(question=request.question)
