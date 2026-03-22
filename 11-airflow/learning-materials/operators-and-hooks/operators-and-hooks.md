# Operators and Hooks (Production-Level Deep Dive)

## 1. Foundations

### What is an Operator

Operator defines:
- WHAT to execute
- HOW Airflow triggers execution

Operator = execution unit

--------------------------------------------------

### What is a Hook

Hook is:
- connection wrapper
- client factory
- integration layer

Hook = HOW to talk to external system

--------------------------------------------------

### Relationship

    Operator → uses Hook → talks to system

--------------------------------------------------

### Example

    hook = PostgresHook(postgres_conn_id="my_db")
    hook.get_records("SELECT 1")

--------------------------------------------------

### Good strategy

- Operator orchestrates
- Hook connects

--------------------------------------------------

### Bad strategy

    def task():
        conn = psycopg2.connect(...)

--------------------------------------------------

### Why bad

- no connection reuse
- no Airflow integration
- no central config

--------------------------------------------------

## 2. Core Operators

--------------------------------------------------

### PythonOperator

    def my_task():
        print("hello")

    task = PythonOperator(
        task_id="python_task",
        python_callable=my_task
    )

--------------------------------------------------

Good:
- orchestration logic
- lightweight tasks

Bad:
- heavy data processing

Why bad:
- memory pressure
- scaling issues

--------------------------------------------------

### BashOperator

    task = BashOperator(
        task_id="run_script",
        bash_command="echo hello"
    )

--------------------------------------------------

Good:
- CLI tools
- dbt
- scripts

Bad:
- complex logic in bash

Why bad:
- hard debugging

--------------------------------------------------

### EmptyOperator

    EmptyOperator(task_id="start")

--------------------------------------------------

Used for:
- structure
- grouping

--------------------------------------------------

### BranchPythonOperator

    def choose():
        return "task_a"

    branch = BranchPythonOperator(
        task_id="branch",
        python_callable=choose
    )

--------------------------------------------------

Used for:
- conditional execution

--------------------------------------------------

### ShortCircuitOperator

    def condition():
        return False

    task = ShortCircuitOperator(
        task_id="check",
        python_callable=condition
    )

--------------------------------------------------

Stops downstream tasks

--------------------------------------------------

### TriggerDagRunOperator

    TriggerDagRunOperator(
        task_id="trigger",
        trigger_dag_id="other_dag"
    )

--------------------------------------------------

Used for:
- DAG chaining

--------------------------------------------------

## 3. SQL / Database Hooks and Operators

--------------------------------------------------

### PostgresHook

    hook = PostgresHook(postgres_conn_id="postgres_source")
    records = hook.get_records("SELECT * FROM table")

--------------------------------------------------

### SQLExecuteQueryOperator

    task = SQLExecuteQueryOperator(
        task_id="run_sql",
        conn_id="postgres_source",
        sql="SELECT 1"
    )

--------------------------------------------------

Good:
- push compute to DB

Bad:
- fetching large data to Airflow

Why bad:
- memory issues

--------------------------------------------------

### MySqlHook

    MySqlHook(mysql_conn_id="mysql_db")

--------------------------------------------------

### JdbcHook

Used for:
- generic JDBC systems

--------------------------------------------------

### OdbcHook

Used for:
- ODBC-based systems

--------------------------------------------------

## 4. HTTP / API Integration

--------------------------------------------------

### HttpHook

    hook = HttpHook(method="GET", http_conn_id="api")
    response = hook.run(endpoint="/data")

--------------------------------------------------

### Example Operator

    def fetch():
        hook = HttpHook(http_conn_id="api")
        r = hook.run(endpoint="/items")
        return r.text

--------------------------------------------------

Good:
- retries
- small payloads

Bad:
- large downloads

Why bad:
- XCom / memory

--------------------------------------------------

### Pagination Pattern

    page = 1
    while True:
        r = hook.run(endpoint=f"/data?page={page}")
        if not r.json():
            break
        page += 1

--------------------------------------------------

## 5. S3 / Object Storage

--------------------------------------------------

### S3Hook

    hook = S3Hook(aws_conn_id="aws_default")
    hook.load_string("data", "key", "bucket")

--------------------------------------------------

### List objects

    hook.list_keys(bucket_name="my-bucket")

--------------------------------------------------

Good:
- store data externally

Bad:
- store data in XCom

Why bad:
- DB overload

--------------------------------------------------

## 6. Spark / Compute

--------------------------------------------------

### SparkSubmitOperator

    SparkSubmitOperator(
        task_id="spark",
        application="job.py"
    )

--------------------------------------------------

### Alternative (Bash)

    BashOperator(
        task_id="spark",
        bash_command="spark-submit job.py"
    )

--------------------------------------------------

Good:
- external compute

Bad:
- pandas in Airflow

Why bad:
- not scalable

--------------------------------------------------

### KubernetesPodOperator

    KubernetesPodOperator(
        task_id="pod",
        image="my-image",
        cmds=["python", "job.py"]
    )

--------------------------------------------------

Used for:
- containerized execution

--------------------------------------------------

## 7. dbt Execution

--------------------------------------------------

    BashOperator(
        task_id="dbt",
        bash_command="""
        dbt run --target prod
        """
    )

--------------------------------------------------

Good:
- external tool

Bad:
- embed SQL logic in DAG

--------------------------------------------------

## 8. Sensors

--------------------------------------------------

### FileSensor

    FileSensor(
        task_id="wait_file",
        filepath="/tmp/file"
    )

--------------------------------------------------

### S3KeySensor

    S3KeySensor(
        task_id="wait_s3",
        bucket_key="file"
    )

--------------------------------------------------

### HttpSensor

    HttpSensor(
        task_id="wait_api",
        endpoint="/status"
    )

--------------------------------------------------

Good:
- event waiting

Bad:
- long blocking sensors

Why bad:
- worker starvation

--------------------------------------------------

## 9. Messaging / Alerts

--------------------------------------------------

### Email

    EmailOperator(
        task_id="email",
        to="user@test.com"
    )

--------------------------------------------------

### Slack (via hook)

    hook = HttpHook(http_conn_id="slack")
    hook.run(endpoint="/webhook")

--------------------------------------------------

## 10. Hooks Deep Dive

Hook responsibilities:

- get connection
- create client
- execute request

--------------------------------------------------

### Example

    hook = PostgresHook(postgres_conn_id="db")
    conn = hook.get_conn()

--------------------------------------------------

Good:
- reuse hooks

Bad:
- direct clients

--------------------------------------------------

## 11. Real Patterns

--------------------------------------------------

### Extract

    hook = PostgresHook(...)
    data = hook.get_records(...)

--------------------------------------------------

### API

    hook = HttpHook(...)
    response = hook.run(...)

--------------------------------------------------

### Store

    hook = S3Hook(...)
    hook.load_string(...)

--------------------------------------------------

## 12. Anti-Patterns

--------------------------------------------------

### 1. Giant PythonOperator

### 2. Raw credentials

### 3. Large XCom

### 4. No retries

### 5. Sensors blocking workers

--------------------------------------------------

## 13. Operator Selection Guide

--------------------------------------------------

If task is:

- SQL → SQLExecuteQueryOperator
- API → HttpHook + PythonOperator
- Spark → SparkSubmitOperator
- dbt → BashOperator
- container → KubernetesPodOperator

--------------------------------------------------

## 14. Production Scenarios

--------------------------------------------------

### Scenario 1: API fails

Fix:
- retries
- timeout

--------------------------------------------------

### Scenario 2: DB overload

Fix:
- push compute to DB

--------------------------------------------------

### Scenario 3: worker blocked

Cause:
- sensor

Fix:
- deferrable sensor

--------------------------------------------------

## 15. Final Principles

- Operator orchestrates
- Hook integrates
- data stays outside Airflow
- tasks must be small
- retries must be safe
- use right tool per task

--------------------------------------------------