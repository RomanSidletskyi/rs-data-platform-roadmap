import json
from pathlib import Path

from src.reference_job_shapes import build_table_names, load_runtime_config, required_maintenance_procedures


def test_build_table_names_and_maintenance(tmp_path: Path) -> None:
    config_path = tmp_path / "runtime_config.json"
    config_path.write_text(
        json.dumps(
            {
                "catalog_name": "prod",
                "namespace": "analytics",
                "raw_table": "raw_orders_events",
                "current_orders_table": "curated_orders_current",
                "customer_history_table": "dim_customer_history",
                "maintenance_procedures": ["expire_snapshots", "rewrite_data_files"],
            }
        ),
        encoding="utf-8",
    )

    config = load_runtime_config(config_path)
    table_names = build_table_names(config)

    assert table_names["raw"] == "prod.analytics.raw_orders_events"
    assert table_names["current_orders"] == "prod.analytics.curated_orders_current"
    assert required_maintenance_procedures(config) == ["expire_snapshots", "rewrite_data_files"]