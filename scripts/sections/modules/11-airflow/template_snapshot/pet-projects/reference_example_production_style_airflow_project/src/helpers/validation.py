from __future__ import annotations

import json
from pathlib import Path


def build_publish_directory(raw_output_root: str) -> Path:
    return Path(raw_output_root) / "published" / "orders_daily"


def validate_publish_contract(publish_directory: Path, minimum_output_files: int) -> None:
    if not publish_directory.exists():
        raise FileNotFoundError(f"Publish directory does not exist: {publish_directory}")

    data_files = [path for path in publish_directory.iterdir() if path.is_file() and not path.name.startswith("_")]
    if len(data_files) < minimum_output_files:
        raise ValueError("Publish contract minimum output files not met")


def write_success_marker(publish_directory: Path, marker_name: str, runtime_env: str) -> Path:
    marker_path = publish_directory / marker_name
    marker_path.write_text(
        json.dumps({"status": "success", "runtime_env": runtime_env}, indent=2),
        encoding="utf-8",
    )
    return marker_path