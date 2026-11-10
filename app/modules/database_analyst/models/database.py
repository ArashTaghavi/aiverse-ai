from app.core.database import Base
from sqlalchemy import JSON, BigInteger, String
from sqlalchemy.orm import Mapped, mapped_column


class Database(Base):
    """Map the existing databases table; migrations are owned by Laravel."""

    __tablename__ = "databases"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    owner_id: Mapped[int] = mapped_column(BigInteger)
    original_name: Mapped[str] = mapped_column(String(255))
    storage_path: Mapped[str] = mapped_column(String(255))
    connection: Mapped[str] = mapped_column(String)
