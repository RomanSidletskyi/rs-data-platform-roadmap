# Airflow Internals Deep Dive (Production-Level)

## 1. Mental Model: What Airflow Really Is

Apache Airflow is a **stateful orchestration system**.

It is NOT:
- a data processing engine
- a task runner
- a distributed compute framework

It IS:
- a control plane
- a scheduler
- a metadata-driven state machine

### Control Plane vs Execution Plane

Control plane:
- scheduler
- metadata DB
- DAG parsing

Execution plane:
- workers
- executors
- external systems (Spark, dbt, APIs)

Good strategy:
- Airflow coordinates systems

Bad strategy:
- Airflow performs heavy computation

Why bad:
- memory pressure
- scheduler slowdown
- retry instability

--------------------------------------------------

## 2. Scheduler Loop (Real Behavior)

The scheduler runs in a loop:

1. Parse DAG files
2. Build DagBag
3. Sync serialized DAGs to DB
4. Create DAG runs
5. Evaluate task dependencies
6. Move tasks to SCHEDULED
7. Send tasks to executor (QUEUED)
8. Monitor task states

### Parsing Cycle

    dags/
      file.py → parsed → DagBag

Key facts:
- happens repeatedly (every few seconds)
- imports Python code
- executes top-level code

Good:
- lightweight imports
- static DAG structure

Bad:
- API calls in top-level
- reading S3 in top-level

Why bad:
- scheduler becomes bottleneck

--------------------------------------------------

### DagBag

DagBag:
- in-memory collection of DAG objects

Problems:
- large DAG files → slow parse
- many DAGs → CPU bound scheduler

--------------------------------------------------

### Scheduling Decisions

Scheduler checks:
- dependencies
- retries
- task state
- concurrency limits

State transitions:

    NONE → SCHEDULED → QUEUED → RUNNING → SUCCESS

--------------------------------------------------

### Scheduler Pressure Points

- many DAGs
- heavy parsing
- slow metadata DB
- high task volume

Symptoms:
- delayed scheduling
- tasks stuck in SCHEDULED

--------------------------------------------------

## 3. Metadata DB (The Core)

The metadata database is the **single source of truth**.

Key conceptual tables:

- dag
- dag_run
- task_instance
- job
- xcom

--------------------------------------------------

### dag_run

Represents:
- one execution of a DAG

Important fields:
- execution_date / data interval
- state

--------------------------------------------------

### task_instance

Represents:
- one task in one DAG run

Fields:
- state
- try_number
- start_date / end_date

--------------------------------------------------

### State Machine

    dag_run:
        running → success / failed

    task_instance:
        none → scheduled → queued → running → success

--------------------------------------------------

### Race Conditions

Example:
- scheduler marks task QUEUED
- worker picks task
- scheduler heartbeat delay
- duplicate scheduling possible

--------------------------------------------------

### DB Performance Impact

If DB is slow:
- scheduler slows
- tasks delayed
- UI becomes unresponsive

--------------------------------------------------

Good:
- fast DB (Postgres tuned)

Bad:
- overloaded DB
- large XCom

Why bad:
- scheduler blocked by DB

--------------------------------------------------

## 4. Executors (Deep Dive)

Executor = bridge between scheduler and workers

--------------------------------------------------

### CeleryExecutor (Most Important)

Flow:

    scheduler → queue → Redis → worker → result backend → DB

Steps:

1. Scheduler sends task to queue
2. Redis stores message
3. Worker pulls task
4. Worker executes
5. Result written back

--------------------------------------------------

### Acknowledgement

- worker ACKs task when accepted
- if not ACKed → re-queued

--------------------------------------------------

### Retry Layers

2 levels:

1. Airflow retry (task retries)
2. Celery retry (message-level)

--------------------------------------------------

### What Airflow knows vs Celery

Airflow:
- logical state

Celery:
- execution state

mismatch possible

--------------------------------------------------

Good:
- idempotent tasks

Bad:
- side effects without control

Why bad:
- duplicate execution

--------------------------------------------------

## 5. Worker Lifecycle

When worker starts a task:

1. Receives task payload
2. Loads DAG code
3. Builds context
4. Executes operator
5. Writes logs
6. Updates DB

--------------------------------------------------

### Code Loading

Worker must:
- have DAG file
- have dependencies

Problems:
- version mismatch
- missing packages

--------------------------------------------------

### Context Injection

Includes:
- data_interval_start
- params
- XCom

--------------------------------------------------

### Worker Failure

If worker dies:
- task stays RUNNING
- becomes zombie

--------------------------------------------------

## 6. XCom Internals

XCom:
- stored in metadata DB

Table:
- xcom

--------------------------------------------------

### Serialization

- JSON or pickle

--------------------------------------------------

### Limits

- should be small (< few KB)

--------------------------------------------------

### Performance Impact

Large XCom:
- DB bloat
- slow queries

--------------------------------------------------

Good:
- pass metadata

Bad:
- pass dataframes

Why bad:
- DB overload

--------------------------------------------------

## 7. Task Lifecycle (End-to-End)

1. DAG parsed
2. DAG run created
3. task_instance created
4. state → SCHEDULED
5. state → QUEUED
6. worker executes
7. state → SUCCESS/FAILED

--------------------------------------------------

## 8. Production Failure Scenarios

--------------------------------------------------

### 1. Scheduler Lag

Symptoms:
- tasks delayed

Causes:
- heavy DAG parsing
- DB slow

--------------------------------------------------

### 2. Zombie Tasks

Symptoms:
- task RUNNING but dead

Fix:
- scheduler cleanup

--------------------------------------------------

### 3. Stuck QUEUED

Causes:
- no workers
- queue misconfig

--------------------------------------------------

### 4. Lost Tasks

Causes:
- worker crash
- broker issues

--------------------------------------------------

### 5. Duplicate Runs

Causes:
- retries
- race conditions

--------------------------------------------------

## 9. Good / Bad Patterns

### Good

- idempotent tasks
- small XCom
- external storage

### Bad

- heavy DAG parsing
- large XCom
- side effects

### Why bad

- instability
- scaling issues

--------------------------------------------------

## 10. Debugging Playbook

--------------------------------------------------

### Where to look

1. Airflow UI:
   - Graph view
   - Gantt
   - Logs

--------------------------------------------------

### CLI

    airflow dags list
    airflow tasks list DAG_ID
    airflow tasks test DAG_ID TASK_ID DATE

--------------------------------------------------

### Logs

- scheduler logs
- worker logs

--------------------------------------------------

### DB (conceptual)

    SELECT * FROM task_instance WHERE dag_id='...';

--------------------------------------------------

### Debug strategy

1. Identify stuck state
2. Check scheduler logs
3. Check worker logs
4. Check DB state
5. Validate config

--------------------------------------------------

## Final Principles

- Airflow is a state machine
- DB is the source of truth
- Scheduler is the brain
- Workers execute only
- XCom is metadata only
- Tasks must be idempotent
- Failures are normal and must be designed for

--------------------------------------------------