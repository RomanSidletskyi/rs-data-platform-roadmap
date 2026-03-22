# DAG Design (Production-Level Deep Dive)

## 1. What DAG Design Really Means

DAG design is not about writing code.

It is about:
- defining boundaries
- controlling dependencies
- ensuring reliability
- enabling safe retries
- making pipelines debuggable

A bad DAG can break a production platform even if code is correct.

--------------------------------------------------

## 2. DAG = Workflow Contract

A DAG defines:

- what happens
- in what order
- under what conditions

It is NOT:
- a script
- a data transformation file
- a business logic container

--------------------------------------------------

## 3. Core Design Principles

### 1. Tasks must be atomic

Each task:
- does one thing
- has one responsibility

--------------------------------------------------

### Good

    extract_orders
    validate_orders
    load_orders

--------------------------------------------------

### Bad

    process_everything

--------------------------------------------------

### Why bad

- cannot retry partially
- hard to debug
- unclear failures

--------------------------------------------------

### 2. Tasks must be idempotent

Running task multiple times must not break data.

--------------------------------------------------

### Good

    write partition overwrite

--------------------------------------------------

### Bad

    append blindly

--------------------------------------------------

### Why bad

- duplicates
- inconsistent results

--------------------------------------------------

### 3. DAG must be deterministic

Same inputs → same outputs

--------------------------------------------------

### Bad

    if random():
        do_something()

--------------------------------------------------

### Why bad

- impossible to debug
- non-reproducible runs

--------------------------------------------------

## 4. Task Granularity

Finding correct task size is critical.

--------------------------------------------------

### Too small

- too many tasks
- scheduler overhead

--------------------------------------------------

### Too large

- hard retries
- large failure blast radius

--------------------------------------------------

### Good strategy

- each task = logical unit
- each task = retry-safe

--------------------------------------------------

## 5. Dependency Design

Dependencies define:
- execution order
- data flow

--------------------------------------------------

### Good

    extract >> transform >> validate >> publish

--------------------------------------------------

### Bad

    hidden dependencies in code

--------------------------------------------------

### Why bad

- scheduler unaware
- inconsistent execution

--------------------------------------------------

## 6. Data Passing Between Tasks

Airflow is NOT a data pipeline engine.

--------------------------------------------------

### Good

- pass metadata via XCom
- store data in S3 / DB

--------------------------------------------------

### Bad

    return dataframe

--------------------------------------------------

### Why bad

- XCom overload
- DB performance issues

--------------------------------------------------

## 7. XCom Pattern

Use XCom only for:
- paths
- IDs
- small metadata

--------------------------------------------------

    context["ti"].xcom_push(key="path", value="/s3/path")

--------------------------------------------------

## 8. DAG Complexity Control

DAG should remain readable.

--------------------------------------------------

### Bad

- deeply nested logic
- dynamic chaos

--------------------------------------------------

### Good

- clear structure
- predictable flow

--------------------------------------------------

## 9. Dynamic DAGs

Dynamic DAGs generate tasks programmatically.

--------------------------------------------------

### Good use

    for table in tables:
        create_task(table)

--------------------------------------------------

### Bad use

- dynamic DAG from API at parse time

--------------------------------------------------

### Why bad

- scheduler load
- instability

--------------------------------------------------

## 10. Modular DAG Design

Separate:

- extraction
- transformation
- validation
- publishing

--------------------------------------------------

### Good

    extract_task
    transform_task
    validate_task

--------------------------------------------------

### Bad

    one huge task

--------------------------------------------------

## 11. Reusable Patterns

Use:
- helper functions
- shared logic modules

--------------------------------------------------

### Good

    def build_extract_task(name):
        ...

--------------------------------------------------

## 12. DAG Parameters

Use params for flexibility.

    params={"table": "orders"}

--------------------------------------------------

### Bad

Hardcoded values

--------------------------------------------------

## 13. Error Handling Design

Design for failure:

- retries
- fallback
- alerts

--------------------------------------------------

## 14. Validation Tasks

Always validate outputs.

--------------------------------------------------

### Good

    validate_row_count

--------------------------------------------------

### Bad

no validation

--------------------------------------------------

### Why bad

- silent data corruption

--------------------------------------------------

## 15. Parallelism Design

Use parallel tasks where possible.

    task_a
    task_b
    task_c

--------------------------------------------------

## 16. Anti-Patterns

### 1. Monolithic DAG

### 2. Business logic in DAG

### 3. External calls in parse time

### 4. Large XCom

### 5. Hidden dependencies

--------------------------------------------------

## 17. Production Scenarios

--------------------------------------------------

### Scenario 1: Partial failure

Good DAG:
- retry only failed task

Bad DAG:
- rerun everything

--------------------------------------------------

### Scenario 2: Data duplication

Cause:
- non-idempotent tasks

--------------------------------------------------

### Scenario 3: Scheduler overload

Cause:
- too many small tasks

--------------------------------------------------

## 18. Good vs Bad Summary

### Good

- atomic tasks
- idempotent
- clear dependencies
- external storage
- validation

--------------------------------------------------

### Bad

- monolithic tasks
- hidden logic
- non-deterministic behavior

--------------------------------------------------

## 19. Final Principles

- DAG defines workflow, not logic
- tasks must be small and safe
- dependencies must be explicit
- data should live outside Airflow
- failures must be isolated
- design for retries from day one

--------------------------------------------------