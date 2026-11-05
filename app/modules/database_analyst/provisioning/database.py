import subprocess
from uuid import uuid4

from .types import DatabaseConnection


def create_database(
    connection: DatabaseConnection,
    admin_password: str | None = None,
) -> DatabaseConnection:
    """Create a unique database inside an existing container."""

    name = f"analyst_{uuid4().hex}"
    database_type = connection["database_type"]
    container_name = connection["container_name"]

    command = ["docker", "exec", "-i"]

    if database_type == "postgres":
        command.extend(
            [
                container_name,
                "psql",
                "-X",
                "--set",
                "ON_ERROR_STOP=1",
                "--username",
                connection["username"],
                "--dbname",
                connection["database"],
            ]
        )

        sql = f'CREATE DATABASE "{name}";'

    elif database_type in ("mysql", "mariadb"):
        if not admin_password:
            raise ValueError(f"{database_type} admin password is required.")

        command.extend(
            [
                "--env",
                f"MYSQL_PWD={admin_password}",
                container_name,
                "mariadb" if database_type == "mariadb" else "mysql",
                "--user",
                "root",
            ]
        )

        username = connection["username"].replace("'", "''")
        grant_name = name.replace("_", "\\_")

        sql = (
            f"CREATE DATABASE `{name}` CHARACTER SET utf8mb4;\n"
            f"GRANT ALL PRIVILEGES ON `{grant_name}`.* TO '{username}'@'%';"
        )

    elif database_type == "sqlserver":
        command.extend(
            [
                container_name,
                "/opt/mssql-tools18/bin/sqlcmd",
                "-S",
                "localhost",
                "-U",
                connection["username"],
                "-P",
                connection["password"],
                "-C",
                "-b",
            ]
        )

        sql = f"CREATE DATABASE [{name}];\nGO\n"

    else:
        raise ValueError(f"Unsupported database type: {database_type}")

    try:
        subprocess.run(
            command,
            input=sql.encode("utf-8"),
            capture_output=True,
            check=True,
        )
    except subprocess.CalledProcessError as error:
        details = (
            (error.stderr or error.stdout or b"")
            .decode("utf-8", errors="replace")
            .strip()
        )

        raise RuntimeError(f"Failed to create database '{name}': {details}") from error

    return {**connection, "database": name}
