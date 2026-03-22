# Airflow Architecture and Pipeline Design

## 1. Architecture-first mindset

### What this means

Airflow is not about writing tasks.  
Airflow is about designing reliable data workflows.

A bad architecture with correct code will fail.  
A good architecture with simple code will succeed.

### Good strategy

Design first:

- what systems are involved
- what each step is responsible for
- what happens on failure
- what happens on retry

### Bad strategy

Start writing DAG code immediately.

### Why bad is bad

- unclear responsibilities  
- tightly coupled logic  
- hard to debug  
- fragile pipelines  

### Production scenario

A DAG works initially but:

- fails when scale increases  
- cannot be rerun safely  
- breaks downstream consumers  

--------------------------------------------------

## 2. Conceptual DAG design

### What is a DAG conceptually

A DAG is not just Python code.  
It is a contract that defines:

- inputs  
- outputs  
- dependencies  
- execution order  

### Good strategy

Think of DAG as:

- a system boundary  
- a unit of orchestration  
- a contract between systems  

### Bad strategy

Think of DAG as “a script that runs tasks”.

### Why bad is bad

- unclear ownership  
- inconsistent outputs  
- hidden dependencies  

### Production scenario

DAG produces different outputs on rerun → downstream breaks.

--------------------------------------------------

## 3. Bounded responsibility

### Definition

Each DAG should have a clear, limited responsibility.

Examples:

- ingestion DAG  
- transformation DAG  
- publishing DAG  

### Good strategy

One DAG = one responsibility.

### Bad strategy

One DAG does everything.

### Why bad is bad

- large blast radius  
- difficult debugging  
- unsafe retries  

### Example

    # bad
    ingest + transform + validate + publish in one DAG

    # good
    ingestion_dag
    transformation_dag
    publishing_dag

--------------------------------------------------

## 4. How to split pipelines

### Dimensions for splitting

- domain (orders, users, payments)
- cadence (hourly vs daily)
- system boundaries
- failure isolation

### Good strategy

Split by:

- ownership  
- data boundaries  
- failure domains  

### Bad strategy

Split randomly or not at all.

### Why bad is bad

- tight coupling  
- cascading failures  

### Production scenario

Single DAG failure blocks entire data platform.

--------------------------------------------------

## 5. Monolithic DAG anti-pattern

### What it looks like

- 50+ tasks
- multiple systems
- unclear dependencies
- mixed responsibilities

### Why people do it

- easier to start  
- everything in one place  

### Why it fails

- scheduler overload  
- hard debugging  
- retries unsafe  

### Production scenario

Task fails in step 30:

- entire DAG must rerun  
- upstream steps repeat  
- duplicates created  

--------------------------------------------------

## 6. Good DAG shape

### Characteristics

- clear stages
- limited number of tasks
- logical grouping
- clear start and end

### Example shape

    extract -> validate -> transform -> validate -> publish

### Good strategy

Design DAG as flow, not collection of tasks.

### Bad strategy

Random task graph.

### Why bad is bad

- hard to reason  
- hidden dependencies  

--------------------------------------------------

## 7. Task design (granularity)

### Too big

- one task does everything

### Too small

- many tiny tasks with no meaning

### Good strategy

Each task:

- one responsibility  
- retry-safe  
- meaningful unit of work  

### Bad strategy

Split or merge tasks arbitrarily.

### Why bad is bad

- hard debugging  
- inefficient retries  

### Example

    # bad
    one_task_all_logic()

    # good
    extract_task
    transform_task
    validate_task

--------------------------------------------------

## 8. Dependency design

### Real dependencies

Only define dependencies that actually exist.

### Fake dependencies

Tasks linked for no real reason.

### Good strategy

Define only necessary dependencies.

### Bad strategy

Chain everything.

### Why bad is bad

- unnecessary delays  
- poor parallelism  

### Production scenario

Unnecessary dependency blocks fast tasks.

--------------------------------------------------

## 9. Airflow vs processing layer boundary

### Airflow should:

- orchestrate  
- schedule  
- monitor  

### Processing layer should:

- transform data  
- compute  
- store  

### Good strategy

Keep transformation outside Airflow.

### Bad strategy

Put business logic in DAG.

### Why bad is bad

- poor scalability  
- hard maintenance  

### Example

    # bad
    pandas_transform_in_airflow()

    # good
    run_dbt()
    run_spark_job()

--------------------------------------------------

## 10. Parse time vs run time

### Parse time

- DAG file is executed by scheduler

### Run time

- tasks are executed by workers

### Good strategy

Keep heavy logic in runtime only.

### Bad strategy

Run logic at parse time.

### Why bad is bad

- scheduler slowdown  
- unstable system  

### Example

    # bad
    config = load_from_api()

    # good
    load_in_task()

--------------------------------------------------

## 11. Top-level code

### Definition

Code outside tasks runs during parsing.

### Good strategy

Keep top-level minimal.

### Bad strategy

Heavy operations in top-level.

### Why bad is bad

- runs repeatedly  
- slows scheduler  

--------------------------------------------------

## 12. Dynamic DAG generation

### When useful

- many similar pipelines

### Risks

- too many DAGs
- heavy parsing

### Good strategy

Generate DAGs carefully.

### Bad strategy

Generate thousands of DAGs dynamically.

### Why bad is bad

- scheduler overload  

--------------------------------------------------

## 13. Logical time and intervals

### Concept

Airflow uses logical intervals.

### Good strategy

Use:

    data_interval_start
    data_interval_end

### Bad strategy

Use current time.

### Why bad is bad

- inconsistent results  

### Production scenario

Backfill produces wrong data.

--------------------------------------------------

## 14. Idempotency

### Definition

Running task multiple times gives same result.

### Good strategy

Design for idempotency.

### Bad strategy

Append blindly.

### Why bad is bad

- duplicate data  

### Example

    # bad
    insert_into_table()

    # good
    merge_into_table()

--------------------------------------------------

## 15. Catchup and backfill

### What it is

Running DAG for past intervals.

### Good strategy

Ensure tasks support reruns.

### Bad strategy

Ignore backfill.

### Why bad is bad

- broken historical data  

--------------------------------------------------

## 16. BAD vs GOOD task examples

### SQL task

    # bad
    SELECT * FROM orders WHERE created_at >= NOW()

    # good
    SELECT * FROM orders WHERE created_at >= %(start)s

### Python task

    # bad
    datetime.now()

    # good
    context["data_interval_start"]

### File writing

    # bad
    file_123.json

    # good
    interval_based_path.json

--------------------------------------------------

## 17. Rerun-safe architecture

### Good strategy

- deterministic outputs  
- idempotent logic  

### Bad strategy

- random outputs  
- stateful behavior  

### Why bad is bad

- inconsistent results  

--------------------------------------------------

## 18. Resource-aware design

### Consider

- API limits  
- DB limits  
- worker capacity  

### Good strategy

Use pools and limits.

### Bad strategy

Unlimited parallelism.

### Why bad is bad

- overload systems  

--------------------------------------------------

## 19. Anti-patterns

- monolithic DAG  
- giant tasks  
- heavy parsing  
- XCom misuse  
- dynamic chaos  

### Why bad is bad

- instability  
- poor scalability  

--------------------------------------------------

## 20. Architecture checklist

- DAG has clear responsibility  
- tasks are idempotent  
- interval-based logic  
- no heavy parse-time code  
- proper dependencies  
- no hardcoded secrets  

--------------------------------------------------

## 21. Final principles

- design first, code second  
- separate orchestration and compute  
- design for failure and retry  
- minimize blast radius  
- keep system simple and observable  

--------------------------------------------------