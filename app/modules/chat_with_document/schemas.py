from pydantic import BaseModel


class IngestDocumentRequest(BaseModel):
    file_path: str
    document_id: int
    owner_id: int


class AskRequest(BaseModel):
    document_id: int
    owner_id: int
    question: str


class AskResponse(BaseModel):
    answer: str
