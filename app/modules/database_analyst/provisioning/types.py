from typing import Literal, TypedDict


type DatabaseType = Literal["postgres", "mysql", "mariadb", "sqlserver"]


class DatabaseConnection(TypedDict):
    database_type: DatabaseType
    host: str
    port: int
    database: str
    username: str
    password: str
    container_name: str
    project_name: str
