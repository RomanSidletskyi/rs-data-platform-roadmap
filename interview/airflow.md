# Airflow Interview Cheat Sheet

## What Airflow is

Apache Airflow is a workflow orchestrator.

Its main job is to schedule, coordinate, and monitor tasks, not to perform the heavy business transformation logic itself.

## Key Interview Questions And Answers

### 1. What is Airflow used for?

Airflow is used to orchestrate workflows as DAGs.

It is strong for:

- scheduling jobs
- expressing task dependencies
- retries and alerting
- operational observability

### 2. What is a DAG?

A DAG is a Directed Acyclic Graph.

In Airflow, it defines:

- which tasks exist
- in what order they run
- which tasks depend on others

### 3. What is the difference between a DAG and a task?

A DAG is the full workflow definition.

A task is one unit of work inside that workflow.

### 4. What is the scheduler responsible for?

The scheduler decides when DAG runs should be created and when tasks are ready to run.

It does not execute business logic itself.

### 5. What is the executor?

The executor defines how tasks are actually run.

Examples:

- LocalExecutor
- CeleryExecutor
- KubernetesExecutor

### 6. What is the difference between `schedule_interval`, `start_date`, and catchup?

Strong short answer:

- `start_date` defines when the DAG becomes eligible
- schedule defines how often the DAG should run
- catchup decides whether missed historical intervals should be created automatically

### 7. What is an Airflow logical date or data interval?

The logical date represents the schedule period a DAG run is responsible for, not the actual wall-clock time when it executes.

This is important for partitioned pipelines and backfills.

### 8. How do retries work in Airflow?

If a task fails, Airflow can retry it based on task configuration.

Typical controls are:

- `retries`
- `retry_delay`
- optional exponential backoff

### 9. What is XCom?

XCom is a lightweight mechanism for passing small messages between tasks.

It should not be used for large datasets.

### 10. What is the difference between orchestration and transformation?

Orchestration is about control flow, timing, retries, and dependencies.

Transformation is about changing the data itself.

Strong interview answer:

- Airflow should orchestrate
- dbt, Spark, SQL, or Python jobs should transform

### 11. How would you orchestrate dbt in Airflow?

A common pattern is:

1. validate upstream readiness
2. run `dbt seed` or `dbt deps` if needed
3. run `dbt run`
4. run `dbt test`
5. notify on failure

### 12. How would you design a pipeline from Airflow to Snowflake?

A strong design answer is:

- Airflow triggers staged ingestion and transformation steps
- Snowflake handles SQL execution and storage
- Airflow tracks success, retries, and dependencies
- warehouse-side logic stays in SQL, procedures, dbt, or Snowflake tasks when appropriate

## Minimal DAG Example

```python
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator


default_args = {
    "owner": "data-platform",
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}


with DAG(
    dag_id="dbt_daily_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule="0 6 * * *",
    catchup=False,
    default_args=default_args,
    tags=["dbt", "snowflake"],
) as dag:
    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="cd /opt/project && dbt run --target prod",
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="cd /opt/project && dbt test --target prod",
    )

    dbt_run >> dbt_test
```

## Python Task Example

```python
from airflow.decorators import dag, task
from datetime import datetime


@dag(start_date=datetime(2026, 1, 1), schedule="@daily", catchup=False)
def readiness_check_pipeline():
    @task
    def check_source_ready() -> bool:
        return True

    @task
    def run_transformation(is_ready: bool) -> str:
        if not is_ready:
            raise ValueError("Source is not ready")
        return "Transformation started"

    run_transformation(check_source_ready())


dag = readiness_check_pipeline()
```

## Good Interview Phrases

- "Airflow is the orchestration layer, not the place where I want heavy SQL transformation logic to live."
- "I care a lot about idempotency, because retries are normal in Airflow."
- "For partitioned data, I always think in terms of logical date and data interval, not only wall-clock runtime."
- "I use Airflow to coordinate dbt, Snowflake, and external readiness checks, but I keep transformation semantics in the transformation layer."

## Common Mistakes To Avoid In Answers

- saying Airflow is mainly an ETL engine
- confusing execution time with logical schedule time
- using XCom as a data transport layer
- putting large business logic directly in DAG files

## Quick Summary

Airflow is best described as a workflow control plane. It defines when tasks run, in what order, with what retry behavior, and with what operational visibility. It should coordinate systems like dbt, Snowflake, and Python jobs without becoming the place where all business transformation logic is embedded.