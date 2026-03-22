# Airflow Execution Model and Task Runtime

## 1. End-to-end execution model

Airflow execution is not direct. It is a coordinated process across components.

Full flow:

    DAG file -> Scheduler -> Metadata DB -> Executor -> Worker -> Task execution -> DB update

### Step-by-step

1. Scheduler parses DAG
2. Scheduler creates DAG Run
3. Scheduler evaluates dependencies
4. TaskInstance moves to "scheduled"
5. TaskInstance moves to "queued"
6. Executor sends task to worker
7. Worker executes task
8. Worker updates state in DB

### Good strategy

Understand that:

- execution is distributed
- DB is source of truth
- scheduler does not execute tasks

### Bad strategy

Assume task runs immediately after scheduling.

### Why bad is bad

- wrong mental model
- incorrect debugging
- misunderstanding delays

### Production failure scenario

Task is "scheduled" but not running:

- executor queue is full
- workers are busy
- DB is slow

--------------------------------------------------

## 2. Task execution lifecycle

### What is TaskInstance

TaskInstance = task + DAG Run + execution context

Each instance is unique per interval.

### Lifecycle

- none
- scheduled
- queued
- running
- success / failed

### Good strategy

Design tasks assuming:

- retries
- reruns
- state transitions

### Bad strategy

Assume one-time execution.

### Why bad is bad

- duplicate data
- inconsistent results

--------------------------------------------------

## 3. Executors (deep explanation)

### What executor does

Executor decides:

- where task runs
- how task is queued
- how task is dispatched

---

### LocalExecutor

- runs tasks as local processes
- parallel but limited

#### Good

- small environments

#### Bad

- production scale

#### Failure scenario

CPU overloaded → tasks delayed

---

### CeleryExecutor

- distributed workers
- message queue (Redis/RabbitMQ)

Flow:

    Scheduler -> Broker -> Worker

#### Good

- scalable
- production-ready

#### Bad

- requires queue management

#### Failure scenario

Queue overload:

- tasks pile up
- delays increase

---

### KubernetesExecutor

- each task runs in its own pod

Flow:

    Scheduler -> Kubernetes API -> Pod -> Execution

#### Good

- isolation
- auto-scaling

#### Bad

- complex setup

#### Failure scenario

Pod startup slow:

- task latency increases

---

### Good strategy

Choose executor based on:

- scale
- isolation needs
- infrastructure

### Bad strategy

Use LocalExecutor in production.

### Why bad is bad

- no scaling
- bottlenecks

--------------------------------------------------

## 4. Workers (deep dive)

### What worker does

Worker:

- receives task
- builds execution context
- runs operator
- reports result

### Inside worker

- task runs in separate process
- logs streamed
- state written to DB

### Good strategy

Keep tasks:

- short
- stateless
- idempotent

### Bad strategy

Long-running heavy tasks.

### Why bad is bad

- worker blocked
- memory leaks
- retry storms

### Production failure scenario

Worker crash:

- task lost or retried
- duplicate execution possible

--------------------------------------------------

## 5. How tasks communicate

### Important principle

Tasks DO NOT communicate directly.

They communicate via:

- metadata DB (XCom)
- external storage (S3, DB, files)
- APIs

---

### Communication types

| Method | Use case |
|------|---------|
| XCom | small metadata |
| S3 / files | large data |
| DB | structured data |

---

### Good strategy

Use:

- XCom for small data
- external storage for large data

### Bad strategy

Use XCom for data transfer.

### Why bad is bad

- DB overload
- scheduler slowdown

--------------------------------------------------

## 6. XCom deep dive

### What is XCom

Cross-communication mechanism between tasks.

Stored in metadata DB.

### How it works

    push → store in DB
    pull → retrieve from DB

### Example

    ti.xcom_push(key="file_path", value="s3://path")

    ti.xcom_pull(task_ids="task1", key="file_path")

---

### Internal behavior

- serialized (JSON/pickle)
- stored in DB table
- retrieved via scheduler/worker

---

### Good strategy

Use XCom for:

- IDs
- paths
- small metadata

### Bad strategy

Store large datasets.

### Why bad is bad

- DB size explosion
- slow queries
- scheduler lag

### Production failure scenario

Large XCom:

- DB grows to GBs
- scheduler loop slows
- tasks delayed

--------------------------------------------------

## 7. Data exchange patterns

### Pattern 1: XCom

    small metadata

### Pattern 2: S3

    large files

### Pattern 3: DB

    structured data

### Good strategy

Choose correct layer.

### Bad strategy

Mix everything in XCom.

### Why bad is bad

- performance issues
- system instability

--------------------------------------------------

## 8. Execution context

### What is context

Context is runtime metadata passed to task.

Contains:

- data_interval_start
- data_interval_end
- dag_run
- task_instance

### Example

    context["data_interval_start"]

### Good strategy

Use context for:

- interval logic
- dynamic behavior

### Bad strategy

Ignore context.

### Why bad is bad

- incorrect results
- broken backfills

--------------------------------------------------

## 9. State updates and consistency

### How state works

Worker updates state in metadata DB.

Scheduler reads state.

### Good strategy

Design for eventual consistency.

### Bad strategy

Assume immediate state sync.

### Why bad is bad

- race conditions
- incorrect assumptions

### Production scenario

Task marked running but actually failed:

- retry triggered later
- duplicate work possible

--------------------------------------------------

## 10. Failure scenarios

### Worker crash

- task interrupted
- retry triggered

### Duplicate execution

- retry overlaps
- non-idempotent logic breaks

### Lost tasks

- queue issues
- worker failure

### Partial success

- task writes partial data
- retry corrupts state

--------------------------------------------------

## 11. Anti-patterns

- large XCom
- long blocking tasks
- tight coupling
- no retry design
- stateful tasks

### Why bad is bad

- instability
- poor scaling
- hard debugging

--------------------------------------------------

## 12. Best practices

- keep tasks idempotent
- use external storage for data
- use XCom only for metadata
- design for retries
- monitor workers and queues
- understand executor behavior

--------------------------------------------------