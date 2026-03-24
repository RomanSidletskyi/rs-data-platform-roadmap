# Solution - Airflow With External Jobs

This topic is about keeping orchestration and compute separate.

## Example DAG Shape

    trigger_spark_job -> wait_for_completion -> publish_result

## Example

```python
from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator


with DAG(
    dag_id="external_job_orchestration_demo",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
) as dag:
    trigger_spark_job = BashOperator(
        task_id="trigger_spark_job",
        bash_command=(
            "spark-submit jobs/orders_job.py "
            "--start '{{ data_interval_start }}' "
            "--end '{{ data_interval_end }}'"
        ),
    )

    wait_for_completion = EmptyOperator(task_id="wait_for_completion")
    publish_result = EmptyOperator(task_id="publish_result")

    trigger_spark_job >> wait_for_completion >> publish_result
```

## What Airflow Controls Vs What Spark Executes

Airflow controls:

- schedule
- dependencies
- retry behavior
- workflow visibility

Spark executes:

- the actual data processing
- distributed compute
- heavy transformations

## Why This Boundary Matters

- retries are clearer
- execution is easier to scale
- Airflow workers are not overloaded with heavy compute

## Common Mistakes

- treating `PythonOperator` as a Spark replacement
- hiding orchestration and compute inside one task
- skipping validation after the external job completes

## Definition Of Done

This topic is complete if you can:

- model an external job as a DAG
- explain orchestration vs compute clearly
- describe why Airflow should trigger external systems instead of becoming the compute engine itself