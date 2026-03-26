# Solution - Python Operator Pipeline

This topic is about running lightweight Python tasks while keeping Airflow as an orchestrator.

## Example

```python
from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator


def fetch_data(**context):
    context["ti"].xcom_push(key="input_path", value="/tmp/raw/orders.json")


def clean_data(**context):
    input_path = context["ti"].xcom_pull(task_ids="fetch_data", key="input_path")
    cleaned_path = input_path.replace("raw", "clean")
    context["ti"].xcom_push(key="cleaned_path", value=cleaned_path)


def save_data(**context):
    cleaned_path = context["ti"].xcom_pull(task_ids="clean_data", key="cleaned_path")
    print(f"Saving data from {cleaned_path}")


with DAG(
    dag_id="python_operator_pipeline_demo",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
) as dag:
    fetch = PythonOperator(task_id="fetch_data", python_callable=fetch_data)
    clean = PythonOperator(task_id="clean_data", python_callable=clean_data)
    save = PythonOperator(task_id="save_data", python_callable=save_data)

    fetch >> clean >> save
```

## Why This Shape Works

- each task has one responsibility
- XCom only carries small metadata such as file paths
- the DAG remains easy to debug

## Better Structure For Real Projects

- move task functions into separate Python modules
- keep DAG files mostly declarative
- keep business logic outside the DAG definition file

## Common Mistakes

- passing large datasets through XCom
- doing heavy pandas processing inside Airflow tasks
- writing a giant PythonOperator that performs the whole pipeline alone

## Definition Of Done

This topic is complete if you can:

- define several Python tasks in one DAG
- pass small metadata between them safely
- explain why Airflow should orchestrate lightweight task boundaries instead of one giant in-memory script