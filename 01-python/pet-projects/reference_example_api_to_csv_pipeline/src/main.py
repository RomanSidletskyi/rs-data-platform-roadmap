from __future__ import annotations

import logging
import sys
from pathlib import Path

from api_client import fetch_data_with_retry
from config_loader import load_config
from processor import transform_records
from writer import ensure_directories, save_csv, save_json, timestamped_filename


def setup_logging(log_dir: str) -> None:
    Path(log_dir).mkdir(parents=True, exist_ok=True)
    log_file = Path(log_dir) / "pipeline.log"

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(message)s",
        handlers=[
            logging.FileHandler(log_file, encoding="utf-8"),
            logging.StreamHandler(sys.stdout),
        ],
    )


def main() -> None:
    config = load_config("config/config.yaml")
    setup_logging(config["logging"]["log_dir"])

    logging.info("Pipeline started")

    raw_dir = config["output"]["raw_dir"]
    processed_dir = config["output"]["processed_dir"]
    ensure_directories(raw_dir, processed_dir)

    api_url = config["api"]["url"]
    timeout = config["api"]["timeout"]
    selected_fields = config["processing"]["selected_fields"]

    try:
        data = fetch_data_with_retry(api_url, timeout=timeout)

        if not data:
            raise ValueError("API response is empty")

        raw_file = Path(raw_dir) / timestamped_filename("raw_response", "json")
        save_json(data, raw_file)
        logging.info("Raw JSON saved to %s", raw_file)

        records = transform_records(data, selected_fields)

        if not records:
            raise ValueError("No valid records after transformation")

        processed_file = Path(processed_dir) / timestamped_filename("processed_data", "csv")
        save_csv(records, processed_file)
        logging.info("Processed CSV saved to %s", processed_file)

        logging.info("Pipeline finished successfully. Records processed: %s", len(records))
    except Exception as exc:
        logging.exception("Pipeline failed: %s", exc)
        raise


if __name__ == "__main__":
    main()