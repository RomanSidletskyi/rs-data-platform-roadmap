import json
from pathlib import Path

from src.runtime_config import build_table_names, load_runtime_config


def test_runtime_config_builds_expected_table_names(tmp_path: Path) -> None:
    config_path = tmp_path / "runtime_config.json"
    config_path.write_text(
        json.dumps(
            {
                "catalog_name": "prod",
                "namespace": "analytics",
                "raw_orders_table": "raw_order_events",
                "current_orders_table": "fct_orders_current",
                "customer_history_table": "dim_customer_history"
            }
        ),
        encoding="utf-8",
    )

    config = load_runtime_config(config_path)
    table_names = build_table_names(config)

    assert table_names["raw_orders"] == "prod.analytics.raw_order_events"
    assert table_names["current_orders"] == "prod.analytics.fct_orders_current"
    assert table_names["customer_history"] == "prod.analytics.dim_customer_history"