import subprocess
from pathlib import Path


def execute_script(file_path: str | Path, connection: dict[str, str | int]) -> None:
    """Stream a plain SQL script to the database client inside its container."""
    database_type = connection["database_type"]
    command = ["docker", "exec", "-i"]
    if database_type == "postgres":
        command.extend(
            [
                str(connection["container_name"]),
                "psql",
                "-X",
                "--set",
                "ON_ERROR_STOP=1",
                "--username",
                str(connection["username"]),
                "--dbname",
                str(connection["database"]),
            ]
        )
    elif database_type == "mysql":
        command.extend(
            [
                "--env",
                f"MYSQL_PWD={connection['password']}",
                str(connection["container_name"]),
                "mysql",
                "--binary-mode",
                "--default-character-set=utf8mb4",
                "--user",
                str(connection["username"]),
                "--database",
                str(connection["database"]),
            ]
        )
    else:
        raise ValueError(f"Unsupported database type: {database_type}")

    with Path(file_path).open("rb") as script:
        try:
            subprocess.run(command, stdin=script, capture_output=True, check=True)
        except subprocess.CalledProcessError as error:
            details = (
                (error.stderr or error.stdout or b"")
                .decode("utf-8", errors="replace")
                .strip()
            )
            raise RuntimeError(
                f"Failed to import SQL script '{file_path}' into {database_type}: "
                f"{details or f'client exited with code {error.returncode}'}"
            ) from error
