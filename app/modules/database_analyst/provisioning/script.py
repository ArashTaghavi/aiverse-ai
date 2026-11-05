import subprocess
from pathlib import Path

from .types import DatabaseConnection


def execute_script(
    file_path: str | Path,
    connection: DatabaseConnection,
) -> None:
    """Execute a SQL script inside the database container."""

    database_type = connection["database_type"]
    container_name = connection["container_name"]

    command = ["docker", "exec", "-i"]

    if database_type == "postgres":
        command.extend(
            [
                "--env",
                f"PGPASSWORD={connection['password']}",
                container_name,
                "psql",
                "--host",
                "127.0.0.1",
                "-X",
                "--set",
                "ON_ERROR_STOP=1",
                "--username",
                connection["username"],
                "--dbname",
                connection["database"],
            ]
        )

    elif database_type in ("mysql", "mariadb"):
        command.extend(
            [
                "--env",
                f"MYSQL_PWD={connection['password']}",
                container_name,
                "mariadb" if database_type == "mariadb" else "mysql",
                "--binary-mode",
                "--default-character-set=utf8mb4",
                "--user",
                connection["username"],
                "--database",
                connection["database"],
            ]
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
                "-d",
                connection["database"],
                "-C",
                "-b",
                "-i",
                "/dev/stdin",
            ]
        )

    else:
        raise ValueError(f"Unsupported database type: {database_type}")

    with Path(file_path).open("rb") as script:
        try:
            subprocess.run(
                command,
                stdin=script,
                capture_output=True,
                check=True,
            )
        except subprocess.CalledProcessError as error:
            details = (
                (error.stderr or error.stdout or b"")
                .decode("utf-8", errors="replace")
                .strip()
            )

            raise RuntimeError(
                f"Failed to import SQL script '{file_path}' "
                f"into {database_type}: "
                f"{details or f'client exited with code {error.returncode}'}"
            ) from error
