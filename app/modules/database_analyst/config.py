DATABASE_CONFIGS = {
    "postgres": {
        "service": "postgres",
        "database_env": "POSTGRES_DB",
        "username_env": "POSTGRES_USER",
        "password_env": "POSTGRES_PASSWORD",
    },
    "mysql": {
        "service": "mysql",
        "database_env": "MYSQL_DATABASE",
        "username_env": "MYSQL_USER",
        "password_env": "MYSQL_PASSWORD",
        "admin_password_env": "MYSQL_ROOT_PASSWORD",
    },
    "mariadb": {
        "service": "mariadb",
        "database_env": "MARIADB_DATABASE",
        "username_env": "MARIADB_USER",
        "password_env": "MARIADB_PASSWORD",
        "admin_password_env": "MARIADB_ROOT_PASSWORD",
    },
    "sqlserver": {
        "service": "sqlserver",
        "database_env": None,
        "username_env": None,
        "password_env": "MSSQL_SA_PASSWORD",
        "default_database": "master",
        "username": "sa",
    },
}
