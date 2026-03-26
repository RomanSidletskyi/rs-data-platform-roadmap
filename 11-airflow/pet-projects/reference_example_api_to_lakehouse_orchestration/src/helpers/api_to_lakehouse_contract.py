from __future__ import annotations

import json
from pathlib import Path


def build_interval_path(raw_base_path: str, raw_prefix: str, interval_label: str) -> Path:
    return Path(raw_base_path) / raw_prefix / f"interval={interval_label}"


def build_payload_path(raw_base_path: str, raw_prefix: str, interval_label: str) -> Path:
    return build_interval_path(raw_base_path, raw_prefix, interval_label) / "payload.json"


def build_marker_path(raw_base_path: str, raw_prefix: str, interval_label: str, marker_name: str) -> Path:
    return build_interval_path(raw_base_path, raw_prefix, interval_label) / marker_name


def validate_payload(payload: list[dict], minimum_records: int) -> None:
    if len(payload) < minimum_records:
        raise ValueError("Payload does not meet minimum record threshold")

    required_fields = {"order_id", "customer_id", "order_total", "order_date"}
    for record in payload:
        missing = required_fields.difference(record.keys())
        if missing:
            raise ValueError(f"Payload record missing required fields: {sorted(missing)}")


def write_json_file(target_path: Path, payload: object) -> Path:
    target_path.parent.mkdir(parents=True, exist_ok=True)
    target_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    return target_path