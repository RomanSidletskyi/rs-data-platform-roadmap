# Solution - First DAG

This topic is about learning the minimum safe Airflow workflow shape.

## Example DAG Shape

    start -> process_data -> finish

## Example

```python
from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator


with DAG(
    dag_id="first_demo_dag",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["learning", "first-dag"],
) as dag:
    start = EmptyOperator(task_id="start")
    process_data = EmptyOperator(task_id="process_data")
    finish = EmptyOperator(task_id="finish")

    start >> process_data >> finish
```

## Why This Is A Good First Shape

- the DAG is small enough to read in one pass
- task order is explicit
- the DAG has a schedule, start date, and tags
- there is no heavy business logic inside the definition file

## Common Mistakes

- forgetting `start_date`
- using heavy code during DAG import
- mixing task structure with business logic too early

## Definition Of Done

This topic is complete if you can:

- define a small DAG
- add tasks and dependencies
- explain what the DAG represents conceptually
- see the DAG in the Airflow UI