import secrets
import subprocess
from uuid import uuid4

from .types import DatabaseConnection


def create_database(
    connection: DatabaseConnection,
    admin_password: str | None = None,
) -> DatabaseConnection:
    """Create a unique database inside an existing container."""

    name = f"analyst_{uuid4().hex}"
    # MySQL usernames are limited to 32 characters. Use only SQL-safe characters.
    username = f"u{uuid4().hex[:30]}"
    password = f"Aa1!{secrets.token_hex(24)}"
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

        sql = (
            f'CREATE ROLE "{username}" LOGIN PASSWORD \'{password}\' '
            'NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;\n'
            f'CREATE DATABASE "{name}";\n'
            f'REVOKE ALL ON DATABASE "{name}" FROM PUBLIC;\n'
            f'GRANT CONNECT, TEMPORARY ON DATABASE "{name}" TO "{username}";\n'
            f'\\connect {name}\n'
            'REVOKE ALL ON SCHEMA public FROM PUBLIC;\n'
            f'GRANT USAGE, CREATE ON SCHEMA public TO "{username}";\n'
        )

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

        grant_name = name.replace("_", "\\_")

        sql = (
            f"CREATE DATABASE `{name}` CHARACTER SET utf8mb4;\n"
            f"CREATE USER '{username}'@'%' IDENTIFIED BY '{password}';\n"
            f"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP, INDEX, "
            f"REFERENCES, CREATE VIEW, SHOW VIEW, TRIGGER, CREATE TEMPORARY TABLES, "
            f"LOCK TABLES ON `{grant_name}`.* TO '{username}'@'%';"
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

        sql = (
            f"CREATE DATABASE [{name}];\nGO\n"
            f"CREATE LOGIN [{username}] WITH PASSWORD = '{password}', "
            f"DEFAULT_DATABASE = [{name}], CHECK_POLICY = ON;\nGO\n"
            f"USE [{name}];\nGO\n"
            "REVOKE CONNECT FROM guest;\n"
            f"CREATE USER [{username}] FOR LOGIN [{username}];\n"
            f"GRANT CONNECT TO [{username}];\n"
            f"ALTER ROLE db_datareader ADD MEMBER [{username}];\n"
            f"ALTER ROLE db_datawriter ADD MEMBER [{username}];\n"
            f"ALTER ROLE db_ddladmin ADD MEMBER [{username}];\nGO\n"
        )

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

    return {
        **connection,
        "database": name,
        "username": username,
        "password": password,
    }
