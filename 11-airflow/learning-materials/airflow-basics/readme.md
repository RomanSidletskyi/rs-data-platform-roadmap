# Airflow Basics (Deep Learning File)

## 1. What Airflow Really Is

Apache Airflow is a workflow orchestration system.

It is designed to:
- define workflows
- schedule workflows
- monitor workflows
- enforce dependencies between tasks

Airflow does NOT process data itself.

It coordinates execution across systems.

--------------------------------------------------

## 2. What Airflow Is NOT

Airflow is not:

- a data processing engine
- a database
- a streaming system
- a real-time system
- a compute engine

--------------------------------------------------

### Good strategy

Use Airflow to orchestrate:

- SQL queries
- dbt runs
- Spark jobs
- API calls
- data movement

--------------------------------------------------

### Bad strategy

Put business logic directly inside DAG:

    def task():
        data = load_big_dataframe()
        process(data)

--------------------------------------------------

### Why bad

- memory issues
- retry complexity
- scaling problems
- Airflow becomes bottleneck

--------------------------------------------------

## 3. Core Concepts

### DAG (Directed Acyclic Graph)

A DAG defines:
- tasks
- dependencies
- schedule

Important:
DAG is NOT execution.

DAG = definition

--------------------------------------------------

### Task

A task is:
- a unit of work
- atomic
- retryable

--------------------------------------------------

### Task Instance

Task Instance = task + specific run

Example:

- task: load_data
- run: 2024-01-01

--------------------------------------------------

### DAG Run

Represents:
- one execution of entire DAG

--------------------------------------------------

## 4. Logical Time vs Real Time

Airflow works with logical time.

Not:

    datetime.now()

But:

    data_interval_start
    data_interval_end

--------------------------------------------------

### Example

Daily DAG:

- run at 2024-01-02
- processes data for 2024-01-01

--------------------------------------------------

### Good

Use interval:

    start = context["data_interval_start"]

--------------------------------------------------

### Bad

Use current time:

    now = datetime.now()

--------------------------------------------------

### Why bad

- reruns break
- backfills inconsistent

--------------------------------------------------

## 5. Dependencies

Dependencies define execution order.

    task_a >> task_b

Means:
- task_b runs after task_a

--------------------------------------------------

### Good

Clear linear or graph structure

--------------------------------------------------

### Bad

Hidden dependencies via code

--------------------------------------------------

### Why bad

- unpredictable execution
- debugging complexity

--------------------------------------------------

## 6. Execution Model

Steps:

1. DAG parsed
2. DAG run created
3. tasks evaluated
4. tasks scheduled
5. tasks executed

--------------------------------------------------

## 7. Operators

Operators define WHAT to do.

Examples:

- PythonOperator
- BashOperator
- PostgresOperator
- HttpOperator

--------------------------------------------------

### Good

Use operator per responsibility

--------------------------------------------------

### Bad

Overload one operator

--------------------------------------------------

### Why bad

- unclear logic
- hard debugging

--------------------------------------------------

## 8. Retries

Airflow supports retries per task.

    retries=3

--------------------------------------------------

### Good

Idempotent tasks

--------------------------------------------------

### Bad

Side effects without control

--------------------------------------------------

### Why bad

- duplicate data
- inconsistent outputs

--------------------------------------------------

## 9. Idempotency

A task must produce same result if run multiple times.

--------------------------------------------------

### Good

    write overwrite partition

--------------------------------------------------

### Bad

    append blindly

--------------------------------------------------

### Why bad

- duplicates
- corrupted datasets

--------------------------------------------------

## 10. Airflow Architecture (Simplified)

Components:

- Scheduler
- Metadata DB
- Executor
- Workers
- Web UI

--------------------------------------------------

### Scheduler

- decides what to run

--------------------------------------------------

### Metadata DB

- stores state

--------------------------------------------------

### Executor

- sends tasks to workers

--------------------------------------------------

### Workers

- execute tasks

--------------------------------------------------

## 11. Production Mindset

Airflow success depends on:

- clean DAG design
- proper task boundaries
- idempotency
- externalized logic
- good observability

--------------------------------------------------

## 12. Common Beginner Mistakes

### 1. Using Airflow as compute engine

### 2. Using datetime.now()

### 3. Not thinking about retries

### 4. Large XCom

### 5. No validation

--------------------------------------------------

## 13. Production Scenarios

--------------------------------------------------

### Scenario 1: Retry causes duplicates

Problem:
- task writes data twice

Fix:
- idempotent writes

--------------------------------------------------

### Scenario 2: Backfill breaks pipeline

Problem:
- using current time

Fix:
- use interval

--------------------------------------------------

### Scenario 3: Scheduler slow

Problem:
- heavy DAG parsing

Fix:
- lightweight DAG

--------------------------------------------------

## 14. Final Principles

- DAG is definition, not execution
- tasks must be small and isolated
- Airflow orchestrates, not computes
- logical time is key
- idempotency is mandatory
- retries are normal behavior
- failures must be expected

--------------------------------------------------