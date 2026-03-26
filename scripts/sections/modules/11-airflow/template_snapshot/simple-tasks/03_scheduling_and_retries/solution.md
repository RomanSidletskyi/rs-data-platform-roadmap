# Solution - Scheduling And Retries

This topic is about understanding logical intervals, retries, and safe runtime defaults.

## Example

```python
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.empty import EmptyOperator


with DAG(
    dag_id="scheduling_and_retries_demo",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "retries": 2,
        "retry_delay": timedelta(minutes=5),
    },
) as dag:
    run_daily_check = EmptyOperator(task_id="run_daily_check")
```

## What This Configuration Means

- `schedule="@daily"` creates daily DAG runs
- `start_date` defines when scheduling can begin
- `retries=2` means the task can be retried automatically after failure
- `retry_delay=5 minutes` spaces out retry attempts
- `catchup=False` means Airflow does not create all historical runs automatically

## Manual Trigger Vs Scheduled Run

- a manual trigger runs the DAG on demand
- a scheduled run is created according to the DAG schedule and logical interval rules

## Why Catchup Matters

`catchup=True` can be useful for historical batch processing.

`catchup=False` is safer for a first learning DAG because it avoids accidental backfill storms.

## Common Mistakes

- using `datetime.now()` inside task logic instead of logical interval values
- enabling catchup without understanding historical run creation
- adding retries to non-idempotent tasks

## Definition Of Done

This topic is complete if you can:

- configure schedule, start date, retries, and retry delay
- explain the difference between scheduled and manual runs
- explain when catchup is useful and when it is risky