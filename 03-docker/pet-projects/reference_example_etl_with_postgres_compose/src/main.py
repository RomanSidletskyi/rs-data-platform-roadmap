import json
import os

from config_loader import load_config
from db import ensure_tables, get_connection, load_daily_summary, load_raw_rows
from transformer import build_daily_summary, read_orders_csv


def main() -> None:
    config_path = os.getenv("CONFIG_PATH", "config/etl_config.json")
    input_path = os.getenv("INPUT_PATH", "data/input/orders.csv")

    config = load_config(config_path)
    rows = read_orders_csv(input_path, config["required_fields"])
    summary_rows = build_daily_summary(rows)

    connection = get_connection()
    try:
        ensure_tables(connection, config["source_table"], config["summary_table"])
        load_raw_rows(connection, config["source_table"], rows)
        load_daily_summary(connection, config["summary_table"], summary_rows)
    finally:
        connection.close()

    print(
        json.dumps(
            {
                "loaded_rows": len(rows),
                "summary_rows": len(summary_rows),
                "source_table": config["source_table"],
                "summary_table": config["summary_table"],
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()