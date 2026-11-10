from sqlalchemy.engine import URL
from sqlalchemy.ext.asyncio import AsyncEngine, create_async_engine

from .types import DatabaseType


class DatabaseConnectionFactory:

    DRIVERS = {  # noqa: RUF012
        "postgres": "postgresql+asyncpg",
        "mysql": "mysql+asyncmy",
        "mariadb": "mariadb+asyncmy",
        "sqlserver": "mssql+aioodbc",
    }

    @classmethod
    def create(
        cls,
        database_type: DatabaseType,
        host: str,
        port: int,
        database: str,
        username: str,
        password: str,
    ) -> AsyncEngine:

        url = URL.create(
            drivername=cls.DRIVERS[database_type],
            username=username,
            password=password,
            host=host,
            port=port,
            database=database,
            query=(
                {
                    "driver": "ODBC Driver 18 for SQL Server",
                    "TrustServerCertificate": "yes",
                    "Encrypt": "yes",
                }
                if database_type == "sqlserver"
                else {}
            ),
        )

        return create_async_engine(
            url,
            pool_pre_ping=True,
        )
