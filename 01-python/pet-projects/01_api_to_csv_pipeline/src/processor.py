from __future__ import annotations

from typing import Any


def transform_records(data: Any, selected_fields: list[str]) -> list[dict[str, Any]]:
    """
    Supports:
    - list[dict]
    - dict with 'data' key containing list[dict]
    - single dict
    """
    if isinstance(data, dict) and "data" in data and isinstance(data["data"], list):
        raw_records = data["data"]
    elif isinstance(data, list):
        raw_records = data
    elif isinstance(data, dict):
        raw_records = [data]
    else:
        raise ValueError("Unsupported response format")

    transformed: list[dict[str, Any]] = []

    for record in raw_records:
        if not isinstance(record, dict):
            continue

        row = {field: record.get(field) for field in selected_fields}
        transformed.append(row)

    return transformed