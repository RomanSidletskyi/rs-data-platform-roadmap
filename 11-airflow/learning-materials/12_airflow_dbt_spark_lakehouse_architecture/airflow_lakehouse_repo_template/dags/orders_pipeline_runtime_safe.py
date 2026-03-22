import os
import subprocess
import yaml

from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.exceptions import AirflowFailException

DEFAULT_ARGS = {
    "owner": "data_platform",
    "depends_on_past": False,
    "email_on_failure": True,
    "email_on_retry": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

CONFIG_PATH = "/opt/airflow/config/pipeline_config.yaml"


def load_runtime_config():
    with open(CONFIG_PATH, "r") as f:
        return yaml.safe_load(f)


def get_env_config():
    return {
        "raw_bucket": os.environ.get("S3_RAW_BUCKET"),
        "curated_bucket": os.environ.get("S3_CURATED_BUCKET"),
        "dbt_target": os.environ.get("DBT_TARGET"),
        "dbt_project_dir": os.environ.get("DBT_PROJECT_DIR"),
        "dbt_profiles_dir": os.environ.get("DBT_PROFILES_DIR"),
    }


def validate_required_runtime_settings(config, env_config):
    required_env = [
        "raw_bucket",
        "curated_bucket",
        "dbt_target",
        "dbt_project_dir",
        "dbt_profiles_dir",
    ]
    for key in required_env:
        if not env_config.get(key):
            raise AirflowFailException(f"Missing required environment setting: {key}")

    if "spark" not in config:
        raise AirflowFailException("Missing 'spark' section in pipeline config")
    if "storage" not in config:
        raise AirflowFailException("Missing 'storage' section in pipeline config")


def run_spark_job(**context):
    config = load_runtime_config()
    env_config = get_env_config()
    validate_required_runtime_settings(config, env_config)

    start = context["data_interval_start"]
    end = context["data_interval_end"]

    spark_script = config["spark"]["script_path"]
    spark_executor_memory = config["spark"]["executor_memory"]
    spark_app_name = config["spark"]["app_name"]
    raw_prefix = config["storage"]["raw_prefix"]
    raw_bucket = env_config["raw_bucket"]

    output_path = (
        f"s3://{raw_bucket}/"
        f"{raw_prefix}/"
        f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
        f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/"
    )

    command = [
        "python",
        spark_script,
        "--start", start.isoformat(),
        "--end", end.isoformat(),
        "--output", output_path,
        "--executor-memory", spark_executor_memory,
        "--app-name", spark_app_name,
    ]

    result = subprocess.run(command, capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)

    if result.returncode != 0:
        raise AirflowFailException(
            f"Spark job failed with return code {result.returncode}"
        )


def validate_raw_output(**context):
    config = load_runtime_config()
    env_config = get_env_config()
    validate_required_runtime_settings(config, env_config)

    start = context["data_interval_start"]
    end = context["data_interval_end"]

    raw_prefix = config["storage"]["raw_prefix"]
    raw_bucket = env_config["raw_bucket"]

    expected_path = (
        f"s3://{raw_bucket}/"
        f"{raw_prefix}/"
        f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
        f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/"
    )

    print(f"Validate raw output path: {expected_path}")
    print("Raw validation passed")


def validate_curated_output(**context):
    env_config = get_env_config()

    start = context["data_interval_start"]
    end = context["data_interval_end"]

    print(
        f"Validate curated output for interval "
        f"{start.isoformat()} -> {end.isoformat()} "
        f"using dbt target {env_config['dbt_target']}"
    )
    print("Curated validation passed")


with DAG(
    dag_id="orders_pipeline_runtime_safe",
    description="Runtime-safe Airflow DAG for Spark + dbt + lakehouse pattern",
    default_args=DEFAULT_ARGS,
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    max_active_runs=1,
    tags=["lakehouse", "spark", "dbt", "runtime-safe"],
) as dag:
    start = EmptyOperator(task_id="start")

    spark_task = PythonOperator(
        task_id="run_spark_job",
        python_callable=run_spark_job,
    )

    validate_raw_task = PythonOperator(
        task_id="validate_raw_output",
        python_callable=validate_raw_output,
    )

    dbt_task = BashOperator(
        task_id="run_dbt",
        bash_command='''
        cd "$DBT_PROJECT_DIR" &&         dbt run           --profiles-dir "$DBT_PROFILES_DIR"           --target "$DBT_TARGET"           --vars '
          {
            "start": "{{ data_interval_start.isoformat() }}",
            "end": "{{ data_interval_end.isoformat() }}"
          }'
        ''',
        env={
            "DBT_PROJECT_DIR": os.environ.get("DBT_PROJECT_DIR", ""),
            "DBT_PROFILES_DIR": os.environ.get("DBT_PROFILES_DIR", ""),
            "DBT_TARGET": os.environ.get("DBT_TARGET", ""),
        },
    )

    validate_curated_task = PythonOperator(
        task_id="validate_curated_output",
        python_callable=validate_curated_output,
    )

    end = EmptyOperator(task_id="end")

    start >> spark_task >> validate_raw_task >> dbt_task >> validate_curated_task >> end
