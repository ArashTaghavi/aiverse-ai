from pathlib import Path

from .provisioning import execute_script, start_database
from .provisioning.types import DatabaseConnection, DatabaseType


class DatabaseAnalyst:

    def provision_database(
        self,
        file_path: str | Path,
        database_type: DatabaseType = "postgres",
    ) -> DatabaseConnection:
        script_path = Path(file_path).resolve(strict=True)
        if not script_path.is_file():
            raise ValueError(f"SQL script path is not a file: {script_path}")

        connection = start_database(database_type=database_type)
        execute_script(file_path=script_path, connection=connection)
        return connection
