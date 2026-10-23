from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Iterable, Protocol


@dataclass(frozen=True)
class Record:
    source: str
    fetched_at: str
    payload: Any


class Fetcher(Protocol):
    def fetch(self, url: str) -> bytes: ...


class Parser(Protocol):
    def parse(self, raw: bytes) -> Iterable[Record]: ...


class Sink(Protocol):
    def write(self, records: Iterable[Record]) -> None: ...
