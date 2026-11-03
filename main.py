from pathlib import Path

from app.modules.chat_with_document.router import router as document_router
from dotenv import load_dotenv
from fastapi import FastAPI

load_dotenv(
    Path(__file__).resolve().parent / ".env"
)

app = FastAPI(title="AIVerse", description="A Universe of AI Projects", version="1.0.0")
app.include_router(document_router)