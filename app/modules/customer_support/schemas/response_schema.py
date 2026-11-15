from typing import Generic, TypeVar

from pydantic import BaseModel

T = TypeVar("T")


class SuccessResponse(BaseModel, Generic[T]):
    status: str = "success"
    message: str = "Request completed successfully."
    data: T


class NotFoundResponse(BaseModel):
    status: str = "not_found"
    message: str = "The requested resource was not found."


class ErrorResponse(BaseModel):
    status: str = "error"
    message: str = "Error"
