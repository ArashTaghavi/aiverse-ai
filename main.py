from pathlib import Path

from dotenv import load_dotenv
from fastapi import FastAPI

from app.modules.chat_with_document.router import router as document_router
from app.modules.database_analyst.router import router as database_analyst_router

load_dotenv(Path(__file__).resolve().parent / ".env")

app = FastAPI(title="AIVerse", description="A Universe of AI Projects", version="1.0.0")
app.include_router(document_router)
app.include_router(database_analyst_router)
