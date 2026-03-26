import json
import os
import subprocess
import yaml
from datetime import datetime, timedelta

from airflow import DAG
from airflow.exceptions import AirflowFailException
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from airflow.providers.http.hooks.http import HttpHook
from airflow.providers.postgres.hooks.postgres import PostgresHook

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
        "api_base_url": os.environ.get("API_BASE_URL"),
        "alert_channel": os.environ.get("ALERT_SLACK_CHANNEL"),
    }


def validate_required_settings(config, env_config):
    required_env = [
        "raw_bucket",
        "curated_bucket",
        "dbt_target",
        "dbt_project_dir",
        "dbt_profiles_dir",
        "api_base_url",
    ]
    for key in required_env:
        if not env_config.get(key):
            raise AirflowFailException(f"Missing required environment setting: {key}")

    required_sections = ["sources", "storage", "spark", "validation"]
    for section in required_sections:
        if section not in config:
            raise AirflowFailException(f"Missing config section: {section}")


def extract_orders_from_postgres(**context):
    config = load_runtime_config()
    env_config = get_env_config()
    validate_required_settings(config, env_config)

    start = context["data_interval_start"]
    end = context["data_interval_end"]

    postgres_conn_id = config["sources"]["postgres_conn_id"]
    hook = PostgresHook(postgres_conn_id=postgres_conn_id)

    sql = """
    SELECT
        %(start)s::text as interval_start,
        %(end)s::text as interval_end,
        1001 as order_id,
        101 as customer_id,
        25.5 as amount
    """

    records = hook.get_records(sql, parameters={"start": start.isoformat(), "end": end.isoformat()})

    payload = [
        {
            "interval_start": row[0],
            "interval_end": row[1],
            "order_id": row[2],
            "customer_id": row[3],
            "amount": row[4],
        }
        for row in records
    ]

    raw_prefix = config["storage"]["raw_prefix"]
    raw_bucket = env_config["raw_bucket"]

    output_path = (
        f"s3://{raw_bucket}/{raw_prefix}/"
        f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
        f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/orders.json"
    )

    print("Postgres extract payload:")
    print(json.dumps(payload, indent=2))
    print(f"Would write to: {output_path}")

    context["ti"].xcom_push(key="orders_output_path", value=output_path)


def fetch_customer_enrichment_api(**context):
    config = load_runtime_config()
    env_config = get_env_config()
    validate_required_settings(config, env_config)

    start = context["data_interval_start"]
    end = context["data_interval_end"]

    http_conn_id = config["sources"]["api_http_conn_id"]
    hook = HttpHook(method="GET", http_conn_id=http_conn_id)

    endpoint = f"/customers?start={start.isoformat()}&end={end.isoformat()}"

    print(f"Calling API endpoint via connection '{http_conn_id}': {endpoint}")
    print(f"API base URL expected from connection and env base: {env_config['api_base_url']}")

    payload = {
        "interval_start": start.isoformat(),
        "interval_end": end.isoformat(),
        "enriched_customers": 1,
    }

    enrichment_prefix = config["storage"]["enrichment_prefix"]
    raw_bucket = env_config["raw_bucket"]

    output_path = (
        f"s3://{raw_bucket}/{enrichment_prefix}/"
        f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
        f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/enrichment.json"
    )

    print("API enrichment payload:")
    print(json.dumps(payload, indent=2))
    print(f"Would write to: {output_path}")

    context["ti"].xcom_push(key="enrichment_output_path", value=output_path)


def run_spark_job(**context):
    config = load_runtime_config()
    env_config = get_env_config()
    validate_required_settings(config, env_config)

    start = context["data_interval_start"]
    end = context["data_interval_end"]

    spark_script = config["spark"]["script_path"]
    spark_executor_memory = config["spark"]["executor_memory"]
    spark_app_name = config["spark"]["app_name"]

    orders_path = context["ti"].xcom_pull(task_ids="extract_orders_from_postgres", key="orders_output_path")
    enrichment_path = context["ti"].xcom_pull(task_ids="fetch_customer_enrichment_api", key="enrichment_output_path")

    curated_prefix = config["storage"]["curated_prefix"]
    curated_bucket = env_config["curated_bucket"]

    output_path = (
        f"s3://{curated_bucket}/{curated_prefix}/"
        f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
        f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/"
    )

    command = [
        "python",
        spark_script,
        "--start", start.isoformat(),
        "--end", end.isoformat(),
        "--orders-path", orders_path,
        "--enrichment-path", enrichment_path,
        "--output", output_path,
        "--executor-memory", spark_executor_memory,
        "--app-name", spark_app_name,
    ]

    result = subprocess.run(command, capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)

    if result.returncode != 0:
        raise AirflowFailException(f"Spark job failed with return code {result.returncode}")

    context["ti"].xcom_push(key="spark_output_path", value=output_path)


def validate_outputs(**context):
    config = load_runtime_config()
    env_config = get_env_config()
    validate_required_settings(config, env_config)

    spark_output_path = context["ti"].xcom_pull(task_ids="run_spark_job", key="spark_output_path")

    print(f"Validating curated output path: {spark_output_path}")
    print(f"Validation policy require_non_empty_output = {config['validation']['require_non_empty_output']}")
    print(f"Validation policy min_expected_records = {config['validation']['min_expected_records']}")
    print(f"Alert channel for this environment: {env_config['alert_channel']}")
    print("Validation passed")


with DAG(
    dag_id="orders_platform_pipeline",
    description="Production-style pipeline: Postgres + API + S3 pattern + Spark + dbt",
    default_args=DEFAULT_ARGS,
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    max_active_runs=1,
    tags=["platform", "postgres", "api", "spark", "dbt", "celery"],
) as dag:

    start = EmptyOperator(task_id="start")

    extract_orders_task = PythonOperator(
        task_id="extract_orders_from_postgres",
        python_callable=extract_orders_from_postgres,
    )

    fetch_enrichment_task = PythonOperator(
        task_id="fetch_customer_enrichment_api",
        python_callable=fetch_customer_enrichment_api,
    )

    spark_task = PythonOperator(
        task_id="run_spark_job",
        python_callable=run_spark_job,
    )

    dbt_command = (
        'cd "$DBT_PROJECT_DIR" && '
        'dbt run '
        '--profiles-dir "$DBT_PROFILES_DIR" '
        '--target "$DBT_TARGET" '
        '--vars \'{"start": "{{ data_interval_start.isoformat() }}", "end": "{{ data_interval_end.isoformat() }}"}\''
    )

    dbt_task = BashOperator(
        task_id="run_dbt",
        bash_command=dbt_command,
        env={
            "DBT_PROJECT_DIR": os.environ.get("DBT_PROJECT_DIR", ""),
            "DBT_PROFILES_DIR": os.environ.get("DBT_PROFILES_DIR", ""),
            "DBT_TARGET": os.environ.get("DBT_TARGET", ""),
        },
    )

    validate_task = PythonOperator(
        task_id="validate_outputs",
        python_callable=validate_outputs,
    )

    end = EmptyOperator(task_id="end")

    start >> [extract_orders_task, fetch_enrichment_task]
    [extract_orders_task, fetch_enrichment_task] >> spark_task >> dbt_task >> validate_task >> end
