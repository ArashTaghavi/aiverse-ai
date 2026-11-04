import json
import subprocess
from pathlib import Path
from typing import Literal

from .database import create_database


def start_database(database_type: Literal["postgres", "mysql"]) -> dict[str, str | int]:
    """Start the server and create a unique database for this import."""
    if database_type not in ("postgres", "mysql"):
        raise ValueError(f"Unsupported database type: {database_type}")

    compose_path = (
        Path(__file__).resolve().parent.parent
        / "docker"
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
    service = config["services"][database_type]
    environment = service["environment"]
    prefix = "POSTGRES" if database_type == "postgres" else "MYSQL"

    subprocess.run(
        [*command, "up", "-d", "--wait", "--wait-timeout", "120"],
        capture_output=True,
        text=True,
        check=True,
    )

    connection = {
        "database_type": database_type,
        "host": "localhost",
        "port": int(service["ports"][0]["published"]),
        "database": environment[
            f"{prefix}_DB" if prefix == "POSTGRES" else "MYSQL_DATABASE"
        ],
        "username": environment[f"{prefix}_USER"],
        "password": environment[f"{prefix}_PASSWORD"],
        "container_name": service["container_name"],
        "project_name": config["name"],
    }
    return create_database(
        connection=connection,
        admin_password=environment.get("MYSQL_ROOT_PASSWORD"),
    )
