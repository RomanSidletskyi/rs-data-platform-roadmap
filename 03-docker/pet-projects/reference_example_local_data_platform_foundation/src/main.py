import json
import os
import time

from config_loader import load_config
from db import ensure_tables, get_connection, load_raw_events, load_summary
from object_store import ensure_bucket, get_minio_client, upload_summary_json
from transformer import build_event_summary, read_events_csv


def main() -> None:
    config_path = os.getenv("CONFIG_PATH", "config/platform_config.json")
    input_path = os.getenv("INPUT_PATH", "data/input/events.csv")
    config = load_config(config_path)

    rows = read_events_csv(input_path)
    summary_rows = build_event_summary(rows)

    connection = get_connection()
    try:
        ensure_tables(connection, config["raw_table"], config["summary_table"])
        load_raw_events(connection, config["raw_table"], rows)
        load_summary(connection, config["summary_table"], summary_rows)
    finally:
        connection.close()

    time.sleep(2)
    client = get_minio_client()
    ensure_bucket(client, config["bucket_name"])
    upload_summary_json(
        client,
        config["bucket_name"],
        "event_summary.json",
        {"raw_events": len(rows), "summary": summary_rows},
    )

    print(json.dumps({"raw_events": len(rows), "summary_rows": len(summary_rows), "bucket": config["bucket_name"]}, indent=2))


if __name__ == "__main__":
    main()