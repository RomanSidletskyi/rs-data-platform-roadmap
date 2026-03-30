from __future__ import annotations

import json
from pathlib import Path


def load_runtime_config(config_path: Path) -> dict:
    return json.loads(config_path.read_text(encoding="utf-8"))


def build_table_names(config: dict) -> dict:
    prefix = f"{config['catalog_name']}.{config['namespace']}"
    return {
        "raw_orders": f"{prefix}.{config['raw_orders_table']}",
        "current_orders": f"{prefix}.{config['current_orders_table']}",
        "customer_history": f"{prefix}.{config['customer_history_table']}",
    }