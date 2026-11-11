"""Detect SQL dialects without connecting to or executing a database."""

import re
from dataclasses import dataclass
from pathlib import Path

from .types import DatabaseType


@dataclass(frozen=True)
class DatabaseTypeDetection:
    database_type: DatabaseType | None
    candidates: tuple[DatabaseType, ...]
    evidence: tuple[str, ...]


_RULES = {
    "postgres": (
        (r"\bCOPY\s+[^;]+\s+FROM\s+stdin\s*;", "COPY FROM stdin"),
        (r"::\s*(?:regclass|regtype|jsonb|uuid)\b", "PostgreSQL cast"),
        (r"\bSET\s+(?:search_path|statement_timeout|lock_timeout)\s*(?:=|TO\b)", "PostgreSQL SET"),
        (r"\bpg_catalog\s*\.", "PostgreSQL catalog"),
        (r"\bGENERATED\s+(?:ALWAYS|BY\s+DEFAULT)\s+AS\s+IDENTITY\b", "PostgreSQL identity"),
        (r"\b(?:BIGSERIAL|SMALLSERIAL|SERIAL|JSONB|TIMESTAMPTZ)\b", "PostgreSQL type"),
    ),
    "sqlserver": (
        (r"\bSET\s+(?:ANSI_NULLS|QUOTED_IDENTIFIER|IDENTITY_INSERT)\b", "SQL Server SET"),
        (r"\bIDENTITY\s*\(\s*-?\d+\s*,\s*-?\d+\s*\)", "SQL Server identity"),
        (r"\[(?:dbo|sys)\]\s*\.", "SQL Server schema"),
        (r"\b(?:CLUSTERED|NONCLUSTERED)\b", "SQL Server index"),
    ),
    "mysql_family": (
        (r"\bENGINE\s*=\s*\w+", "ENGINE table option"),
        (r"\bAUTO_INCREMENT\b", "AUTO_INCREMENT"),
        (r"^\s*DELIMITER\s+\S+", "DELIMITER"),
        (r"\bLOCK\s+TABLES\b", "LOCK TABLES"),
    ),
}


def detect_sql_database_type(sql: str) -> DatabaseTypeDetection:
    comments: list[str] = []

    def mask(match: re.Match[str]) -> str:
        if match.group("comment"):
            comments.append(match.group(0))
        elif match.group(0).startswith(('"', '`', '[')):
            return match.group(0)
        return re.sub(r"[^\r\n]", " ", match.group(0))

    # Ignore data values and function bodies so their contents cannot become clues.
    code = re.sub(
        r"(?P<tag>\$(?:[A-Za-z_][A-Za-z_0-9]*)?\$)[\s\S]*?(?P=tag)"
        r"|'(?:\\.|''|[^'\\])*'|\"(?:\"\"|[^\"])*\"|`(?:``|[^`])*`|\[(?:\]\]|[^\]])*\]"
        r"|(?P<comment>--[^\r\n]*|/\*[\s\S]*?\*/)",
        mask, sql.lstrip("\ufeff"),
    )
    headers = "\n".join(comments)
    evidence: list[str] = []
    families: set[str] = set()
    for family, rules in _RULES.items():
        for pattern, description in rules:
            if re.search(pattern, code, re.IGNORECASE | re.MULTILINE):
                families.add(family)
                evidence.append(description)

    # Recognize both standard dump headers and this project's sample-file headers.
    sample = re.findall(
        r"^--\s*DatabaseAnalyst sample ecommerce dataset for\s+(POSTGRES(?:QL)?|MYSQL|MARIADB|SQLSERVER)\b",
        headers, re.IGNORECASE | re.MULTILINE,
    )
    markers = {name.lower().replace("postgresql", "postgres") for name in sample}
    for pattern, vendor in (
        (r"^--\s*PostgreSQL database dump\b", "postgres"),
        (r"^--\s*MySQL dump\b", "mysql"),
        (r"^--\s*(?:MariaDB dump\b|(?:Server version|MySQL dump)[^\r\n]*\bMariaDB\b)|/\*M!", "mariadb"),
    ):
        if re.search(pattern, headers, re.IGNORECASE | re.MULTILINE):
            markers.add(vendor)
    # MariaDB's mysqldump may identify itself as a MySQL dump too.
    if "mariadb" in markers:
        markers.discard("mysql")
    for vendor in sorted(markers):
        families.add("mysql_family" if vendor in {"mysql", "mariadb"} else vendor)
        evidence.append(f"{vendor} dump header")
    if re.search(r"/\*!\d{5,6}\s", headers):
        families.add("mysql_family")
        evidence.append("MySQL-compatible executable comment")

    candidates: list[DatabaseType] = []
    for vendor in ("postgres", "sqlserver"):
        if vendor in families:
            candidates.append(vendor)
    if "mysql_family" in families:
        candidates.extend(vendor for vendor in ("mysql", "mariadb") if vendor in markers)
        if not markers.intersection({"mysql", "mariadb"}):
            candidates.extend(("mysql", "mariadb"))
    return DatabaseTypeDetection(
        candidates[0] if len(candidates) == 1 else None,
        tuple(candidates), tuple(evidence),
    )


def detect_database_type(file_path: str | Path) -> DatabaseTypeDetection:
    """Return None for ambiguous or unsupported scripts instead of guessing."""
    data = Path(file_path).read_bytes()
    if data.startswith((b"\xff\xfe\x00\x00", b"\x00\x00\xfe\xff")):
        encoding = "utf-32"
    elif data.startswith((b"\xff\xfe", b"\xfe\xff")):
        encoding = "utf-16"
    else:
        encoding = "utf-8-sig"
    return detect_sql_database_type(data.decode(encoding))
