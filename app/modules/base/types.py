from collections.abc import Iterator
from typing import TypeAlias

RagResult: TypeAlias = Iterator[str] | str | dict[str, str | bool]
