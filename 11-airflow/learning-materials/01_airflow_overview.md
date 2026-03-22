# Apache Airflow Overview

## 1. Introduction to Apache Airflow

### What Apache Airflow is

Apache Airflow is a workflow orchestration system used to coordinate execution of distributed tasks across multiple systems.

Airflow defines workflows as Directed Acyclic Graphs (DAGs), where each node represents a task and edges represent dependencies.

Airflow does not process data itself. It controls when and how external systems execute work.

Think about Airflow as a system that answers:

- what should run  
- when it should run  
- in what order it should run  
- what to do if something fails  

#### Good strategy

Use Airflow as a coordination layer that orchestrates:

- SQL queries in warehouses  
- Spark or Databricks jobs  
- dbt transformations  
- API ingestion jobs  

#### Bad strategy

Use Airflow as a system where:

- all data is processed inside Python tasks  
- all logic is centralized in DAG files  

#### Why bad is bad

- no separation between orchestration and compute  
- difficult to scale  
- retry logic becomes unsafe  
- small failures affect entire pipelines  

#### Example

    def bad_pipeline():
        df = load_all_data()
        df = transform(df)
        save(df)

    def good_pipeline():
        trigger_spark_job("sales_transform")

#### Production failure scenario

A Python task processes a large dataset and fails after partial write:

- retry runs again and duplicates data  
- downstream tasks consume inconsistent data  
- data quality issues appear in dashboards  

This is a typical failure when Airflow is misused as compute layer.

--------------------------------------------------

### What Airflow is not

Airflow is not:

- a compute engine  
- a storage system  
- a real-time streaming system  

#### Good strategy

Use:

- warehouses for SQL  
- Spark for distributed compute  
- dbt for transformations  

#### Bad strategy

Load large datasets into Airflow memory and process them.

#### Why bad is bad

- worker crashes due to memory limits  
- slow execution  
- no horizontal scaling  

#### Example

    def bad():
        df = pandas.read_parquet("huge_file")
        df = complex_transform(df)

    def good():
        run_sql("INSERT INTO table SELECT ...")

#### Production failure scenario

Worker runs out of memory:

- task killed by system  
- Airflow retries  
- same failure repeats  
- queue builds up  
- other DAGs are delayed  

--------------------------------------------------

### Why Airflow exists

Airflow exists to solve coordination complexity.

Without Airflow:

- scripts run independently  
- dependencies are implicit  
- no retry control  
- no centralized visibility  

#### Good strategy

Use Airflow for pipelines with:

- multiple steps  
- dependencies  
- retries  
- SLA requirements  

#### Bad strategy

Use Airflow for single independent tasks.

#### Why bad is bad

- scheduler overloaded with trivial DAGs  
- increased operational complexity  

#### Example

    # bad
    one_task_dag

    # good
    extract >> transform >> validate >> publish

#### Production failure scenario

Thousands of trivial DAGs:

- scheduler spends time parsing DAGs  
- real pipelines get delayed  
- UI becomes slow  

--------------------------------------------------

### Workflow orchestration vs job execution

Orchestration defines dependencies.
Execution performs actual work.

Airflow orchestrates.
External systems execute.

#### Good strategy

Keep execution outside Airflow.

#### Bad strategy

Mix orchestration and execution in the same task.

#### Why bad is bad

- no isolation between steps  
- retry restarts entire pipeline  
- debugging becomes difficult  

#### Example

    def bad():
        extract()
        transform()
        load()

    def good():
        trigger_extract()
        trigger_transform()
        trigger_load()

#### Production failure scenario

Transform step fails:

- extract step re-runs unnecessarily  
- duplicate data appears  
- increased load on upstream systems  

--------------------------------------------------

### Orchestration vs automation

Automation = run tasks.
Orchestration = manage relationships between tasks.

#### Good strategy

Use Airflow when tasks depend on each other.

#### Bad strategy

Use Airflow as a cron replacement.

#### Why bad is bad

- adds overhead without benefit  
- does not use Airflow strengths  

--------------------------------------------------

### Airflow as control plane, not data plane

Airflow controls execution but does not process data.

#### Good strategy

Airflow triggers jobs, not performs them.

#### Bad strategy

Airflow processes datasets.

#### Why bad is bad

- blocks worker slots  
- increases latency  
- reduces system throughput  

#### Example

    def bad():
        process_large_dataset()

    def good():
        run_databricks_job()

#### Production failure scenario

Heavy task occupies worker:

- queue grows  
- scheduler delays increase  
- SLA missed for unrelated pipelines  

This is called **resource contention across DAGs**.

--------------------------------------------------

## 2. Core mental model

### DAGs as workflow definitions

DAGs define structure, not execution.

They should be lightweight and declarative.

#### Good strategy

Keep DAG files simple and fast to parse.

#### Bad strategy

Execute logic during DAG import.

#### Why bad is bad

- scheduler becomes slow  
- parsing delays affect all DAGs  

#### Example

    # bad
    config = call_external_api()

    # good
    define_tasks_only()

#### Production failure scenario

API call in DAG:

- API latency slows parsing  
- scheduler cannot keep up  
- tasks are delayed across system  

--------------------------------------------------

### Airflow as a stateful orchestration system

Airflow tracks state of every task instance.

States include:

- scheduled  
- queued  
- running  
- success  
- failed  
- retry  

#### Good strategy

Design tasks to be idempotent.

#### Bad strategy

Assume tasks run once.

#### Why bad is bad

- retries create duplicates  
- data becomes inconsistent  

#### Example

    def bad():
        insert_into_table()

    def good():
        merge_into_table()

#### Production failure scenario

Partial insert:

- retry duplicates rows  
- aggregation doubles results  
- business reports become incorrect  

--------------------------------------------------

### Airflow as scheduler + metadata-driven state machine

Airflow uses metadata DB as source of truth.

Scheduler continuously evaluates:

- what should run  
- what can run  
- what failed  

#### Good strategy

Keep metadata small and efficient.

#### Bad strategy

Store large data in XCom.

#### Why bad is bad

- DB grows rapidly  
- scheduler queries slow down  
- system latency increases  

#### Example

    # bad
    xcom_push(large_dataframe)

    # good
    xcom_push("s3://path/file")

#### Production failure scenario

Large XCom:

- metadata DB reaches GBs quickly  
- scheduler loop slows  
- DAGs start late  

--------------------------------------------------

### Why Airflow is not cron with UI

Cron runs tasks blindly.
Airflow manages dependencies and state.

#### Good strategy

Use Airflow for dependency-driven workflows.

#### Bad strategy

Use Airflow only for scheduling.

#### Why bad is bad

- complexity without benefit  

--------------------------------------------------

## 3. Where Airflow fits in a data platform

Airflow orchestrates interactions between systems.

    Sources -> Ingestion -> Storage -> Transform -> Serving
                         ^
                      Airflow

#### Good strategy

Airflow connects systems, not replaces them.

#### Bad strategy

Embed transformation logic inside Airflow.

#### Why bad is bad

- tight coupling  
- difficult scaling  

#### Production failure scenario

Single DAG controls entire pipeline:

- ingestion fails  
- transformation blocked  
- dashboards not updated  
- SLA violation  

This is **large blast radius failure**.

--------------------------------------------------

## 4. What Airflow usually orchestrates

Airflow orchestrates:

- SQL jobs  
- dbt models  
- Spark jobs  
- API ingestion  
- file transfers  

#### Good strategy

Each task has one responsibility.

#### Bad strategy

Tasks do multiple steps.

#### Why bad is bad

- debugging becomes difficult  
- retries unsafe  

#### Example

    def bad():
        extract_transform_load()

    def good():
        extract_task
        transform_task
        load_task

#### Production failure scenario

Multi-step task fails at step 3:

- steps 1 and 2 rerun unnecessarily  
- duplicates generated  

--------------------------------------------------

## 5. When Airflow is a good fit

Airflow is best for:

- batch pipelines  
- dependency-heavy workflows  
- scheduled processing  

#### Good strategy

Use Airflow for multi-step pipelines.

#### Bad strategy

Use Airflow for low-latency systems.

#### Why bad is bad

- latency mismatch  

--------------------------------------------------

## 6. When Airflow is not a good fit

Airflow is not suitable for:

- real-time systems  
- event streaming  

#### Good strategy

Use streaming tools.

#### Bad strategy

Force Airflow into real-time.

#### Why bad is bad

- poor performance  

--------------------------------------------------

## 7. Airflow execution philosophy

Airflow uses logical time.

Each run processes a specific interval.

#### Good strategy

Use interval-based processing.

#### Bad strategy

Use current time.

#### Why bad is bad

- inconsistent results  
- broken backfills  

#### Example

    def bad():
        datetime.now()

    def good():
        context["data_interval_start"]

#### Production failure scenario

Backfill job:

- uses current time  
- processes wrong data  
- historical reports incorrect  

--------------------------------------------------

## 8. Airflow in production: common deployment combinations

Airflow runs in distributed environments.

#### Good strategy

Use CeleryExecutor or KubernetesExecutor.

#### Bad strategy

Use single-node setup.

#### Why bad is bad

- single point of failure  
- no scalability  

--------------------------------------------------

## 9. Typical production architecture combinations

Airflow integrates with:

- warehouses  
- Spark  
- dbt  
- object storage  

#### Good strategy

Use modular architecture.

#### Bad strategy

Monolithic pipelines.

#### Why bad is bad

- large failure impact  

--------------------------------------------------

## 10. Common roles around Airflow

Airflow is used by multiple roles.

#### Good strategy

Assign ownership.

#### Bad strategy

No ownership.

#### Why bad is bad

- unclear responsibility  

--------------------------------------------------

## 11. Advantages of Airflow

- flexible orchestration  
- strong scheduling  
- large ecosystem  

--------------------------------------------------

## 12. Limitations and trade-offs

- scheduler bottlenecks  
- metadata DB dependency  

#### Production failure scenario

Too many tasks:

- scheduler cannot schedule fast enough  
- tasks start late  
- SLA violated  

--------------------------------------------------

## 13. Airflow maturity model

- beginner: writing DAGs  
- intermediate: orchestrating systems  
- advanced: designing pipelines  
- architect: defining boundaries  

--------------------------------------------------

## 14. Summary and key principles

Airflow orchestrates distributed systems.

Key principles:

- separate orchestration and compute  
- design idempotent tasks  
- use interval-based logic  
- minimize blast radius  
- keep DAGs lightweight  
- design for failure  

--------------------------------------------------