# Airflow Components and Internal Mechanics

## 1. High-level system overview

Apache Airflow is not a single application. It is a distributed system composed of multiple components working together.

At a high level, Airflow consists of:

- scheduler
- workers
- metadata database
- webserver (UI)
- executor
- optional triggerer

Airflow operates as a control plane that coordinates execution across these components.

### Control plane vs execution plane

Control plane:

- scheduler
- metadata database
- webserver

Execution plane:

- workers
- external systems (Spark, DB, APIs, dbt)

### Good strategy

Think about Airflow as a distributed system where:

- state is centralized (DB)
- execution is distributed (workers)
- scheduling is continuous (scheduler loop)

### Bad strategy

Think about Airflow as a simple Python script runner.

### Why bad is bad

- leads to poor scaling decisions
- ignores distributed nature
- causes resource mismanagement

### Production failure scenario

If you treat Airflow as a single app:

- you deploy everything on one machine
- scheduler overload blocks execution
- DB contention slows everything
- entire system becomes unstable

--------------------------------------------------

## 2. DAG file and parsing model

### What a DAG file really is

A DAG file is not executed once.

It is imported repeatedly by the scheduler.

Every parse cycle:

- Python file is executed
- DAG objects are reconstructed
- scheduler updates internal state

### Parse frequency

Scheduler continuously parses DAG files:

- every few seconds
- across multiple processes

### Top-level code problem

Any code outside task definitions runs at parse time.

#### Bad example

    data = call_external_api()

#### Why bad

- runs on every parse
- slows scheduler
- introduces instability

### Good strategy

Keep DAG files:

- lightweight
- deterministic
- free of side effects

### Production failure scenario

Heavy DAG parsing:

- scheduler loop slows down
- DAG runs delayed
- system-wide latency increases

--------------------------------------------------

## 3. DAG, DAG Run, Task, Task Instance

### DAG

A DAG is a template that defines workflow structure.

### DAG Run

A DAG Run represents execution for a specific interval.

### Task

A task is a node in the DAG.

### Task Instance

A task instance is a specific execution of a task within a DAG Run.

### State machine

Each task instance moves through states:

- none
- scheduled
- queued
- running
- success
- failed
- retry

### Good strategy

Design tasks assuming:

- multiple executions
- retries
- reruns

### Bad strategy

Assume tasks run only once.

### Why bad is bad

- duplicate data
- inconsistent results

### Production failure scenario

Task fails after partial work:

- retry executes again
- duplicates are created
- downstream systems break

--------------------------------------------------

## 4. Scheduler (core component)

### What scheduler does

Scheduler continuously:

- parses DAGs
- creates DAG Runs
- evaluates dependencies
- queues tasks

### Scheduler loop

Each loop:

- read metadata DB
- evaluate tasks
- send tasks to executor

### Good strategy

Keep scheduler workload low:

- lightweight DAGs
- limited number of tasks

### Bad strategy

Large DAGs with thousands of tasks.

### Why bad is bad

- scheduler loop slows
- tasks delayed
- system backlog grows

### Production failure scenario

Too many tasks:

- scheduler cannot keep up
- queue grows
- SLAs missed

--------------------------------------------------

## 5. Executor

### What executor does

Executor decides how tasks are executed.

Types:

- LocalExecutor
- CeleryExecutor
- KubernetesExecutor

### Good strategy

Use distributed executors in production.

### Bad strategy

Use SequentialExecutor.

### Why bad is bad

- no parallelism
- slow pipelines

### Production failure scenario

Single executor:

- tasks run sequentially
- backlog builds up
- delays propagate

--------------------------------------------------

## 6. Operators and hooks boundary

### Operator

An operator defines what Airflow should execute as a unit of orchestration.

Examples:

- `PythonOperator`
- `BashOperator`
- `EmptyOperator`
- SQL or provider-specific operators

### Hook

A hook is the connection-aware integration layer used to talk to an external system.

Examples:

- `PostgresHook`
- `HttpHook`
- cloud storage hooks

### Correct relationship

    Operator -> Hook -> External system

### Good strategy

- operator controls orchestration intent
- hook handles connectivity and system interaction

### Bad strategy

- create raw client connections manually inside every task

### Why bad is bad

- no consistent Airflow connection management
- duplicate integration logic
- weaker observability and maintainability

### Example

    # better pattern
    hook = PostgresHook(postgres_conn_id="orders_db")
    records = hook.get_records("SELECT 1")

--------------------------------------------------

## 7. Choosing the right operator shape

### PythonOperator

Good for:

- lightweight orchestration logic
- passing metadata
- calling an external client or wrapper

Bad for:

- heavy in-memory data processing

### BashOperator

Good for:

- CLI-based tools
- dbt commands
- shell entrypoints for external jobs

Bad for:

- complex control flow hidden in shell code

### EmptyOperator

Good for:

- DAG structure
- start and end markers
- grouping workflow shape clearly

### Good strategy

Pick operators based on responsibility and execution style.

### Bad strategy

Force one operator type to solve every integration problem.

### Why bad is bad

- DAGs become harder to reason about
- debugging boundaries become unclear

--------------------------------------------------

## 8. Workers

### What workers do

Workers:

- receive tasks
- execute them
- update state in DB

### Good strategy

Keep tasks lightweight and isolated.

### Bad strategy

Run heavy processing inside workers.

### Why bad is bad

- memory exhaustion
- slow execution

### Production failure scenario

Worker crash:

- task fails
- retry triggered
- repeated crash loop

--------------------------------------------------

## 9. Metadata database

### Role

Metadata DB stores:

- DAG runs
- task instances
- states
- XCom
- variables
- connections metadata

### Good strategy

Keep DB load minimal.

### Bad strategy

Store large data in XCom.

### Why bad is bad

- DB grows rapidly
- scheduler slows

### Production failure scenario

DB slowdown:

- scheduler blocked
- tasks not scheduled
- entire system degraded

--------------------------------------------------

## 10. Webserver / UI

### What UI does

- displays DAGs
- shows task states
- allows manual triggers

### Good strategy

Use UI for monitoring.

### Bad strategy

Depend on UI for execution logic.

### Why bad is bad

- UI is not execution layer

### Production failure scenario

Large DAG rendering:

- UI becomes slow
- debugging difficult

--------------------------------------------------

## 11. Triggerer and deferrable tasks

### What triggerer does

Handles async waiting tasks.

### Good strategy

Use deferrable operators for waiting tasks.

### Bad strategy

Use blocking sensors.

### Why bad is bad

- blocks worker slots

### Production failure scenario

Many sensors:

- workers occupied
- no capacity for real tasks

--------------------------------------------------

## 12. Task lifecycle

Task lifecycle:

1. DAG parsed
2. DAG Run created
3. Task scheduled
4. Task queued
5. Worker executes
6. State updated

### Good strategy

Understand lifecycle for debugging.

### Bad strategy

Ignore task states.

### Why bad is bad

- hard troubleshooting

--------------------------------------------------

## 13. Concurrency, pools, queues

### Concepts

- parallelism
- max_active_runs
- pools
- queues

### Good strategy

Limit resource usage.

### Bad strategy

Unlimited concurrency.

### Why bad is bad

- overload systems

### Production failure scenario

Too many parallel API calls:

- API rate limit hit
- failures cascade

--------------------------------------------------

## 12. XCom

### What is XCom

Small data sharing between tasks.

### Good strategy

Store small metadata only.

### Bad strategy

Store large datasets.

### Why bad is bad

- DB overload

### Production failure scenario

Large XCom:

- DB grows
- scheduler slows

--------------------------------------------------

## 13. System-wide failure chains

### Example chain

- API fails
- retries increase
- worker slots consumed
- queue grows
- downstream tasks delayed
- SLA missed

### Good strategy

Isolate failures.

### Bad strategy

Couple tasks tightly.

### Why bad is bad

- cascading failures

--------------------------------------------------

## 14. Common bottlenecks

- scheduler CPU
- DB latency
- worker memory
- task count
- DAG complexity

### Good strategy

Monitor and optimize.

### Bad strategy

Ignore system metrics.

--------------------------------------------------

## 15. Anti-patterns

- heavy DAG parsing
- large XCom
- monolithic DAG
- no limits
- bad dependencies

### Why bad is bad

- unstable system
- hard debugging

--------------------------------------------------

## 16. Summary

Airflow is a distributed system.

Key principles:

- separate control and execution
- design for retries
- keep DAGs lightweight
- monitor system health
- control concurrency
- minimize blast radius

--------------------------------------------------