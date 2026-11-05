from typing import TypedDict


class DatabaseConnection(TypedDict):
    database_type: str
    host: str
    port: int
    database: str
    username: str
    password: str
    container_name: str
    project_name: str
