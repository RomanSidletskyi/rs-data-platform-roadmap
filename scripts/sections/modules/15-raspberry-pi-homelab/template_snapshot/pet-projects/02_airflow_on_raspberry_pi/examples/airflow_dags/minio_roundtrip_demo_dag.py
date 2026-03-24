from __future__ import annotations

import os
from datetime import datetime
from pathlib import Path

from airflow import DAG
from airflow.exceptions import AirflowFailException
from airflow.operators.python import PythonOperator
from minio import Minio


MINIO_ENDPOINT = os.environ.get("MINIO_ENDPOINT", "minio:9000")
MINIO_ACCESS_KEY = os.environ.get("MINIO_ROOT_USER", "")
MINIO_SECRET_KEY = os.environ.get("MINIO_ROOT_PASSWORD", "")
BUCKET_NAME = "raw-zone"
LOCAL_TMP_DIR = Path("/tmp/airflow_minio_demo")


def build_client() -> Minio:
    if not MINIO_ACCESS_KEY or not MINIO_SECRET_KEY:
        raise AirflowFailException(
            "Missing MINIO_ROOT_USER or MINIO_ROOT_PASSWORD in Airflow environment."
        )

    return Minio(
        MINIO_ENDPOINT,
        access_key=MINIO_ACCESS_KEY,
        secret_key=MINIO_SECRET_KEY,
        secure=False,
    )


def create_local_file(**context: dict) -> str:
    run_id = context["run_id"].replace(":", "_")
    LOCAL_TMP_DIR.mkdir(parents=True, exist_ok=True)
    file_path = LOCAL_TMP_DIR / f"hello_{run_id}.txt"
    file_path.write_text(
        f"hello from airflow run {context['run_id']}\n",
        encoding="utf-8",
    )
    return str(file_path)


def upload_to_minio(**context: dict) -> str:
    client = build_client()
    task_instance = context["ti"]
    run_id = context["run_id"].replace(":", "_")
    file_path = Path(task_instance.xcom_pull(task_ids="create_local_file"))
    object_name = f"airflow/demo/{run_id}/hello.txt"

    if not file_path.is_file():
        raise AirflowFailException(f"Expected local file does not exist: {file_path}")

    if not client.bucket_exists(BUCKET_NAME):
        client.make_bucket(BUCKET_NAME)

    client.fput_object(BUCKET_NAME, object_name, str(file_path))
    return object_name


def download_and_validate(**context: dict) -> None:
    client = build_client()
    task_instance = context["ti"]
    original_path = Path(task_instance.xcom_pull(task_ids="create_local_file"))
    object_name = task_instance.xcom_pull(task_ids="upload_to_minio")
    downloaded_path = LOCAL_TMP_DIR / "downloaded_hello.txt"

    client.fget_object(BUCKET_NAME, object_name, str(downloaded_path))

    original_text = original_path.read_text(encoding="utf-8")
    downloaded_text = downloaded_path.read_text(encoding="utf-8")

    if original_text != downloaded_text:
        raise AirflowFailException("Downloaded file content does not match original.")

    print(f"Validated MinIO roundtrip for {BUCKET_NAME}/{object_name}")


with DAG(
    dag_id="minio_roundtrip_demo",
    description="Create a file in Airflow, upload it to MinIO, then download and validate it.",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
    tags=["raspberry-pi", "minio", "demo"],
) as dag:
    create_local_file_task = PythonOperator(
        task_id="create_local_file",
        python_callable=create_local_file,
    )

    upload_to_minio_task = PythonOperator(
        task_id="upload_to_minio",
        python_callable=upload_to_minio,
    )

    download_and_validate_task = PythonOperator(
        task_id="download_and_validate",
        python_callable=download_and_validate,
    )

    create_local_file_task >> upload_to_minio_task >> download_and_validate_task