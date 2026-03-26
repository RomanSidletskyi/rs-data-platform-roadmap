from __future__ import annotations

import json
import sys
from datetime import datetime, timedelta
from pathlib import Path

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from airflow.utils.task_group import TaskGroup

PROJECT_SRC = Path(__file__).resolve().parents[1]
if str(PROJECT_SRC) not in sys.path:
    sys.path.append(str(PROJECT_SRC))

from helpers.runtime_config import load_runtime_config  # noqa: E402
from helpers.validation import (  # noqa: E402
    build_publish_directory,
    validate_publish_contract,
    write_success_marker,
)


def _config_path() -> Path:
    return PROJECT_SRC.parent / "config" / "runtime_config.json"


def validate_runtime_contract(**context) -> None:
    runtime_config = load_runtime_config(_config_path())
    required_keys = {"runtime_env", "raw_output_root", "alert_email", "transform_command", "success_marker_name"}
    missing = required_keys.difference(runtime_config.keys())
    if missing:
        raise ValueError(f"Missing runtime config keys: {sorted(missing)}")
    context["ti"].xcom_push(key="runtime_config", value=json.dumps(runtime_config))


def validate_publish_outputs(**context) -> None:
    runtime_config = json.loads(context["ti"].xcom_pull(task_ids="validate_runtime_contract", key="runtime_config"))
    publish_directory = build_publish_directory(runtime_config["raw_output_root"])
    validate_publish_contract(publish_directory, runtime_config["minimum_output_files"])


def publish_success_marker_task(**context) -> None:
    runtime_config = json.loads(context["ti"].xcom_pull(task_ids="validate_runtime_contract", key="runtime_config"))
    publish_directory = build_publish_directory(runtime_config["raw_output_root"])
    write_success_marker(
        publish_directory,
        runtime_config["success_marker_name"],
        runtime_config["runtime_env"],
    )


with DAG(
    dag_id="reference_production_style_orders_platform",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "retries": 2,
        "retry_delay": timedelta(minutes=10),
        "execution_timeout": timedelta(minutes=20),
    },
    tags=["reference-example", "airflow", "production-style"],
) as dag:
    start = EmptyOperator(task_id="start")
    validate_runtime = PythonOperator(
        task_id="validate_runtime_contract",
        python_callable=validate_runtime_contract,
    )

    with TaskGroup(group_id="external_processing") as external_processing:
        run_external_transform = BashOperator(
            task_id="run_external_transform",
            bash_command="{{ ti.xcom_pull(task_ids='validate_runtime_contract', key='runtime_config') | fromjson | attr('get')('transform_command') }}",
        )

    validate_publish = PythonOperator(
        task_id="validate_publish_contract",
        python_callable=validate_publish_outputs,
    )
    publish_success = PythonOperator(
        task_id="publish_success_marker",
        python_callable=publish_success_marker_task,
    )
    finish = EmptyOperator(task_id="finish")

    start >> validate_runtime >> external_processing >> validate_publish >> publish_success >> finish