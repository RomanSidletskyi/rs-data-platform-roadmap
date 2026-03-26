# Solution - Task Dependencies

This topic is about modeling execution order clearly.

## Example Dependency Shape

    extract -> validate -> transform -> load
                  \-> quality_report /

## Example

```python
from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator


with DAG(
    dag_id="task_dependencies_demo",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
) as dag:
    extract = EmptyOperator(task_id="extract")
    validate = EmptyOperator(task_id="validate")
    transform = EmptyOperator(task_id="transform")
    quality_report = EmptyOperator(task_id="quality_report")
    load = EmptyOperator(task_id="load")
    finish = EmptyOperator(task_id="finish")

    extract >> validate
    validate >> transform
    validate >> quality_report
    [transform, quality_report] >> load >> finish
```

## What Matters Here

- `transform` starts only after `validate`
- one task can fan out into parallel downstream tasks
- multiple upstream tasks can converge into one downstream task

## Good Dependency Thinking

- define only real dependencies
- keep the graph readable
- avoid fake chaining just to force a visual order

## Common Mistakes

- chaining everything linearly when some tasks could run in parallel
- hiding real dependencies inside task code
- using one giant task instead of meaningful task boundaries

## Definition Of Done

This topic is complete if you can:

- model sequential and parallel dependencies
- explain why `validate` must happen before `transform`
- read the DAG graph and describe the workflow correctly