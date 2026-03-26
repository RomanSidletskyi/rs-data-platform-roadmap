from __future__ import annotations

import csv
import json
from datetime import datetime
from pathlib import Path
from typing import Any


def ensure_directories(*dirs: str) -> None:
    for directory in dirs:
        Path(directory).mkdir(parents=True, exist_ok=True)


def timestamped_filename(prefix: str, extension: str) -> str:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return f"{prefix}_{timestamp}.{extension}"


def save_json(data: Any, file_path: Path) -> None:
    with file_path.open("w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, ensure_ascii=False)


def save_csv(records: list[dict[str, Any]], file_path: Path) -> None:
    if not records:
        raise ValueError("Cannot save empty records list to CSV")

    fieldnames = list(records[0].keys())
    with file_path.open("w", encoding="utf-8", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(records)