from __future__ import annotations

import csv
from datetime import UTC, datetime
from pathlib import Path


def ensure_directories(*paths: str) -> None:
    for path in paths:
        Path(path).mkdir(parents=True, exist_ok=True)


def timestamped_filename(prefix: str, suffix: str) -> str:
    timestamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
    return f"{prefix}_{timestamp}.{suffix}"


def read_csv_records(csv_path: str) -> list[dict[str, str]]:
    with Path(csv_path).open("r", encoding="utf-8", newline="") as file_handle:
        reader = csv.DictReader(file_handle)
        return list(reader)


def write_csv_records(records: list[dict[str, str]], csv_path: Path) -> None:
    if not records:
        raise ValueError("Cannot write empty record set")

    with csv_path.open("w", encoding="utf-8", newline="") as file_handle:
        writer = csv.DictWriter(file_handle, fieldnames=list(records[0].keys()))
        writer.writeheader()
        writer.writerows(records)