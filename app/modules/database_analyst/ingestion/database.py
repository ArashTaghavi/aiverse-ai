import subprocess
from uuid import uuid4


def create_database(
    connection: dict[str, str | int], admin_password: str | None = None
) -> dict[str, str | int]:
    """Create a separate database for this import and return its connection."""
    name = f"analyst_{uuid4().hex}"
    command = ["docker", "exec", "-i"]
    if connection["database_type"] == "postgres":
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
        sql = f'CREATE DATABASE "{name}";'
    elif connection["database_type"] == "mysql":
        if not admin_password:
            raise ValueError("MySQL admin password is required to create a database.")
        command.extend(
            [
                "--env",
                f"MYSQL_PWD={admin_password}",
                str(connection["container_name"]),
                "mysql",
                "--user",
                "root",
            ]
        )
        username = str(connection["username"]).replace("'", "''")
        # Escape underscores: database names in MySQL grants are patterns.
        grant_name = name.replace("_", "\\_")
        sql = (
            f"CREATE DATABASE `{name}` CHARACTER SET utf8mb4;\n"
            f"GRANT ALL PRIVILEGES ON `{grant_name}`.* TO '{username}'@'%';"
        )
    else:
        raise ValueError(f"Unsupported database type: {connection['database_type']}")

    try:
        subprocess.run(
            command, input=sql.encode("utf-8"), capture_output=True, check=True
        )
    except subprocess.CalledProcessError as error:
        details = (
            (error.stderr or error.stdout or b"")
            .decode("utf-8", errors="replace")
            .strip()
        )
        raise RuntimeError(f"Failed to create database '{name}': {details}") from error

    return {**connection, "database": name}
