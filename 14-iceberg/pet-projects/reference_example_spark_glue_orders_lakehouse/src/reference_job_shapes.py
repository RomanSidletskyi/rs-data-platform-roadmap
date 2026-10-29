from __future__ import annotations

import json
from pathlib import Path


def load_runtime_config(config_path: Path) -> dict:
    return json.loads(config_path.read_text(encoding="utf-8"))


def build_table_names(config: dict) -> dict:
    prefix = f"{config['catalog_name']}.{config['namespace']}"
    return {
        "raw": f"{prefix}.{config['raw_table']}",
        "current_orders": f"{prefix}.{config['current_orders_table']}",
        "customer_history": f"{prefix}.{config['customer_history_table']}",
    }


def required_maintenance_procedures(config: dict) -> list[str]:
    procedures = list(config.get("maintenance_procedures", []))
    return sorted(procedures)