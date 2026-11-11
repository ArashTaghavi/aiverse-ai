import json

from sqlalchemy import select, text
from sqlalchemy.exc import SQLAlchemyError

from app.core.database import DbSession

from ..models.database import Database
from . import DatabaseConnectionFactory


async def execute_sql(
    db: DbSession,
    sql: str,
    database_id: int,
    owner_id: int,
) -> tuple[str, bool]:
    database = db.scalar(
        select(Database).where(
            Database.id == database_id,
            Database.owner_id == owner_id,
        )
    )

    if database is None:
        raise ValueError("Database not found")

    connection = json.loads(database.connection)
    connection_args = {key: connection[key] for key in (
        "database_type", "host", "port", "database", "username", "password",
    )}
    engine = DatabaseConnectionFactory.create(**connection_args)

    try:
        async with engine.begin() as conn:
            result = await conn.execute(text(sql))

            if result.returns_rows:
                rows = result.mappings().fetchmany(100)

                output = json.dumps(
                    [dict(row) for row in rows],
                    ensure_ascii=False,
                    default=str,
                    indent=2,
                )
            else:
                output = json.dumps(
                    {
                        "message": "Query executed successfully.",
                        "affected_rows": result.rowcount,
                    }
                )

            return output, True

    except SQLAlchemyError as e:
        return str(e), False

    finally:
        await engine.dispose()
