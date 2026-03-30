from __future__ import annotations

from pathlib import Path

from runtime_config import build_table_names, load_runtime_config


def describe_pipeline(config_path: Path) -> dict:
    config = load_runtime_config(config_path)
    table_names = build_table_names(config)
    return {
        "raw_orders_prefix": config["raw_orders_prefix"],
        "raw_customers_prefix": config["raw_customers_prefix"],
        "tables": table_names,
        "maintenance_procedures": config["maintenance_procedures"],
        "steps": [
            "append raw order CDC into raw_orders table",
            "build latest order state staging relation",
            "merge staging into current_orders table",
            "reconcile customer snapshot into customer_history table",
            "run maintenance procedures on curated tables",
        ],
    }


if __name__ == "__main__":
    config_path = Path("config/runtime_config.json")
    print(describe_pipeline(config_path))