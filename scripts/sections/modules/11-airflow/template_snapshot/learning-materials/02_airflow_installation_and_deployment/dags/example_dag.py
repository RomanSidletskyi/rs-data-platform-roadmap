from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator


def print_context(**context):
    print("Logical date:", context["logical_date"])
    print("Data interval start:", context["data_interval_start"])
    print("Data interval end:", context["data_interval_end"])


with DAG(
    dag_id="example_local_validation_dag",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["starter", "validation"],
) as dag:
    start = BashOperator(
        task_id="start",
        bash_command="echo 'Airflow is running correctly'",
    )

    show_context = PythonOperator(
        task_id="show_context",
        python_callable=print_context,
    )

    finish = BashOperator(
        task_id="finish",
        bash_command="echo 'Validation complete'",
    )

    start >> show_context >> finish
