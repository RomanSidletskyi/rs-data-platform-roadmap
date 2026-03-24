from __future__ import annotations

import json
import os
import sys
from datetime import datetime, timedelta
from pathlib import Path

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from airflow.providers.http.hooks.http import HttpHook

PROJECT_SRC = Path(__file__).resolve().parents[1]
if str(PROJECT_SRC) not in sys.path:
    sys.path.append(str(PROJECT_SRC))

from helpers.api_to_lakehouse_contract import (  # noqa: E402
    build_marker_path,
    build_payload_path,
    validate_payload,
    write_json_file,
)


def _load_runtime_config() -> dict:
    config_path = PROJECT_SRC.parent / "config" / "api_runtime.json"
    return json.loads(config_path.read_text(encoding="utf-8"))


def fetch_api_payload(**context) -> None:
    runtime_config = _load_runtime_config()
    interval_label = context["data_interval_start"].strftime("%Y-%m-%d")
    raw_base_path = os.getenv("RAW_BASE_PATH", "/opt/airflow/data/raw/api_orders")
    payload_path = build_payload_path(raw_base_path, runtime_config["raw_prefix"], interval_label)

    hook = HttpHook(method="GET", http_conn_id=os.getenv("API_CONN_ID", "customer_api"))
    response = hook.run(endpoint=runtime_config["endpoint"])
    response.raise_for_status()
    payload = response.json()

    if isinstance(payload, dict):
        payload = payload.get("items", [])

    validate_payload(payload, int(os.getenv("MIN_RECORDS", runtime_config["minimum_records"])))
    write_json_file(payload_path, payload)
    context["ti"].xcom_push(key="payload_path", value=str(payload_path))


def validate_raw_output(**context) -> None:
    payload_path = Path(context["ti"].xcom_pull(task_ids="fetch_api_payload", key="payload_path"))
    if not payload_path.exists():
        raise FileNotFoundError(f"Expected raw payload at {payload_path}")

    payload = json.loads(payload_path.read_text(encoding="utf-8"))
    runtime_config = _load_runtime_config()
    validate_payload(payload, runtime_config["minimum_records"])


def mark_downstream_ready(**context) -> None:
    runtime_config = _load_runtime_config()
    interval_label = context["data_interval_start"].strftime("%Y-%m-%d")
    raw_base_path = os.getenv("RAW_BASE_PATH", "/opt/airflow/data/raw/api_orders")
    marker_path = build_marker_path(
        raw_base_path,
        runtime_config["raw_prefix"],
        interval_label,
        runtime_config["downstream_marker_name"],
    )
    write_json_file(
        marker_path,
        {
            "status": "ready",
            "interval": interval_label,
        },
    )


with DAG(
    dag_id="reference_api_to_lakehouse_orchestration",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "retries": 2,
        "retry_delay": timedelta(minutes=5),
    },
    tags=["reference-example", "airflow", "api", "lakehouse"],
) as dag:
    start = EmptyOperator(task_id="start")
    fetch = PythonOperator(task_id="fetch_api_payload", python_callable=fetch_api_payload)
    validate = PythonOperator(task_id="validate_raw_output", python_callable=validate_raw_output)
    mark_ready = PythonOperator(task_id="mark_downstream_ready", python_callable=mark_downstream_ready)
    finish = EmptyOperator(task_id="finish")

    start >> fetch >> validate >> mark_ready >> finish