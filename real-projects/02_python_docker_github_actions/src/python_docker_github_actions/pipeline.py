from __future__ import annotations

import argparse
import logging
import sys
from datetime import UTC, datetime
from pathlib import Path

from python_docker_github_actions.config_loader import load_config
from python_docker_github_actions.database import (
    build_curated_outputs,
    connect,
    fetch_curated_rows,
    fetch_latest_run_id,
    initialize_schema,
    load_raw_records,
)
from python_docker_github_actions.io_utils import (
    ensure_directories,
    read_csv_records,
    timestamped_filename,
    write_csv_records,
)
from python_docker_github_actions.quality import (
    DataQualityError,
    fail_if_quality_issues,
    validate_records,
    write_quality_report,
)


RUN_MODES = ("full", "extract", "load", "transform")


def setup_logging(log_dir: str) -> None:
    ensure_directories(log_dir)
    log_path = Path(log_dir) / "pipeline.log"

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(message)s",
        handlers=[
            logging.FileHandler(log_path, encoding="utf-8"),
            logging.StreamHandler(sys.stdout),
        ],
        force=True,
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run the Docker + CI ETL reference project")
    parser.add_argument("--config", default="config/settings.json", help="Path to config file")
    parser.add_argument("--source-path", help="Override the source CSV path")
    parser.add_argument("--database-path", help="Override the SQLite database path")
    parser.add_argument(
        "--run-mode",
        choices=RUN_MODES,
        default="full",
        help="Pipeline mode: extract, load, transform, or full",
    )
    return parser.parse_args()


def run_pipeline(
    config_path: str = "config/settings.json",
    source_path: str | None = None,
    database_path: str | None = None,
    run_mode: str = "full",
) -> None:
    config = load_config(config_path)
    if run_mode not in RUN_MODES:
        raise ValueError(f"Unsupported run mode: {run_mode}")

    if source_path is not None:
        config["source_csv"] = source_path
    if database_path is not None:
        config["warehouse_path"] = database_path

    setup_logging(config["log_dir"])
    ensure_directories(
        config["raw_dir"],
        config["quality_dir"],
        str(Path(config["warehouse_path"]).parent),
    )

    run_id = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
    logging.info("Pipeline started | run_id=%s | run_mode=%s", run_id, run_mode)

    if run_mode in {"extract", "load", "full"}:
        records = read_csv_records(config["source_csv"])
        if not records:
            raise ValueError("Source CSV does not contain any records")

        raw_snapshot = Path(config["raw_dir"]) / timestamped_filename("orders_raw", "csv")
        write_csv_records(records, raw_snapshot)
        logging.info("Raw snapshot written to %s", raw_snapshot)

        if run_mode == "extract":
            logging.info("Extract-only mode finished successfully")
            return

        quality_report = validate_records(records)
        quality_report_path = Path(config["quality_dir"]) / timestamped_filename(
            "quality_report", "json"
        )
        write_quality_report(quality_report, quality_report_path)
        logging.info("Quality report written to %s", quality_report_path)
        fail_if_quality_issues(quality_report)

        with connect(config["warehouse_path"]) as connection:
            initialize_schema(connection)
            load_raw_records(connection, run_id, records)

            if run_mode == "load":
                logging.info("Load-only mode finished successfully")
                return

            build_curated_outputs(connection, run_id)
            curated_rows = fetch_curated_rows(connection)
    else:
        with connect(config["warehouse_path"]) as connection:
            initialize_schema(connection)
            latest_run_id = fetch_latest_run_id(connection)
            if latest_run_id is None:
                raise DataQualityError(
                    "Transform mode requires previously loaded raw data in the warehouse"
                )
            build_curated_outputs(connection, latest_run_id)
            curated_rows = fetch_curated_rows(connection)

    logging.info("Curated rows built: %s", len(curated_rows))
    for row in curated_rows:
        logging.info("Curated row | %s", row)

    logging.info("Pipeline finished successfully")


def main() -> None:
    args = parse_args()
    run_pipeline(
        config_path=args.config,
        source_path=args.source_path,
        database_path=args.database_path,
        run_mode=args.run_mode,
    )