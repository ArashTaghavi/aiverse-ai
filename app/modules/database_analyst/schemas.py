from typing import Literal

from pydantic import BaseModel

from .provisioning.types import DatabaseType


class ProvisionDatabaseResponse(BaseModel):
    database_type: DatabaseType
    host: str
    port: int
    database: str
    username: str
    password: str
    container_name: str


class DatabaseFileErrorResponse(BaseModel):
    error: Literal["invalid_script_file"] = "invalid_script_file"
    detail: str


class DatabaseProvisionErrorResponse(BaseModel):
    error: Literal["database_provision_failed"] = "database_provision_failed"
    detail: str


class IngestDatabaseRequest(BaseModel):
    file_path: str
    database_id: int
    owner_id: int
    # database_type: DatabaseType


class AskRequest(BaseModel):
    database_id: int
    owner_id: int
    question: str


class AskResponse(BaseModel):
    answer: str
