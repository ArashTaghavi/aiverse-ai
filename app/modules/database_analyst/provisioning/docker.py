import json
import subprocess
from pathlib import Path

from ..config import DATABASE_CONFIGS
from .database import create_database
from .types import DatabaseConnection, DatabaseType


def start_database(database_type: DatabaseType) -> DatabaseConnection:
    """Start a database server and create a unique database."""

    if database_type not in DATABASE_CONFIGS:
        raise ValueError(f"Unsupported database type: {database_type}")

    settings = DATABASE_CONFIGS[database_type]

    compose_path = (
        Path(__file__).resolve().parent.parent
        / "docker_compose_files"
        / f"compose.{database_type}.yaml"
    )

    command = ["docker", "compose", "-f", str(compose_path)]

    config_result = subprocess.run(
        [*command, "config", "--format", "json"],
        capture_output=True,
        text=True,
        check=True,
    )

    config = json.loads(config_result.stdout)
    service = config["services"][settings["service"]]
    environment = service["environment"]

    subprocess.run(
        [*command, "up", "-d", "--wait", "--wait-timeout", "120"],
        capture_output=True,
        text=True,
        check=True,
    )

    connection: DatabaseConnection = {
        "database_type": database_type,
        "host": "localhost",
        "port": int(service["ports"][0]["published"]),
        "database": (
            environment[settings["database_env"]]
            if settings["database_env"]
            else settings["default_database"]
        ),
        "username": (
            environment[settings["username_env"]]
            if settings["username_env"]
            else settings["username"]
        ),
        "password": environment[settings["password_env"]],
        "container_name": service["container_name"],
    }

    admin_password_env = settings.get("admin_password_env")

    return create_database(
        connection=connection,
        admin_password=(
            environment[admin_password_env] if admin_password_env else None
        ),
    )
