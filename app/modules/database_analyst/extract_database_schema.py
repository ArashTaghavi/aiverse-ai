"""Extract compact table DDL for a CRUD context, without application rows."""

import json

from sqlalchemy import MetaData, inspect, select
from sqlalchemy.engine import Connection
from sqlalchemy.schema import CreateIndex, CreateTable

from app.core.database import DbSession

from .models.database import Database
from .provisioning.database_connection_factory import DatabaseConnectionFactory
from .provisioning.types import DatabaseConnection


def _reflect_schema(connection: Connection) -> str:
    """Keep columns, types, nullability, generated values, keys and checks only."""
    inspector = inspect(connection)
    if connection.dialect.name in {"mysql", "mariadb"}:
        # In MySQL a schema is a database; inspect only the requested database.
        schemas = [connection.engine.url.database or inspector.default_schema_name]
    else:
        schemas = inspector.get_schema_names()
    schemas = sorted(
        schema for schema in schemas
        if schema not in {"information_schema", "INFORMATION_SCHEMA", "pg_catalog", "sys"}
        and not schema.startswith(("pg_toast", "pg_temp_"))
    )

    metadata = MetaData()
    for schema in schemas:
        metadata.reflect(bind=connection, schema=schema, views=False)

    statements = []
    for table in sorted(metadata.tables.values(), key=lambda item: item.key):
        # Strip names and comments only from the in-memory reflection.
        for constraint in table.constraints:
            constraint.name = None
        table.comment = None
        for column in table.columns:
            column.comment = None

        ddl = str(CreateTable(table).compile(dialect=connection.dialect))
        statements.append("\n".join(line.strip() for line in ddl.splitlines() if line.strip()))

        # Unique indexes impose write constraints, including filtered ones.
        # Ordinary indexes do not add logical schema information.
        unique_indexes = sorted(
            (index for index in table.indexes if index.unique),
            key=lambda index: index.name or "",
        )
        for position, index in enumerate(unique_indexes, start=1):
            index.name = f"unique_{position}"
            ddl = str(CreateIndex(index).compile(dialect=connection.dialect))
            statements.append(ddl.strip())

    return ";\n".join(statements) + (";" if statements else "")


async def extract_database_schema(
    db: DbSession,
    database_id: int,
    owner_id: int,
) -> str:
    """Read the owner's saved connection and return compact JSON schema context."""
    database = db.scalar(select(Database).where(
        Database.id == database_id, Database.owner_id == owner_id,
    ))
    if database is None:
        raise ValueError("Database not found")

    stored = database.connection
    credentials = json.loads(stored) if isinstance(stored, str) else stored
    return await extract_schema_from_connection(credentials)


async def extract_schema_from_connection(credentials: DatabaseConnection) -> str:
    """Return database type and table DDL; no routines, permissions or catalog dump."""
    connection_args = {key: credentials[key] for key in (
        "database_type", "host", "port", "database", "username", "password",
    )}
    engine = DatabaseConnectionFactory.create(**connection_args)
    try:
        async with engine.connect() as connection:
            schema = await connection.run_sync(_reflect_schema)
        return json.dumps(
            {"database_type": credentials["database_type"], "schema": schema},
            ensure_ascii=False,
            separators=(",", ":"),
        )
    finally:
        await engine.dispose()
