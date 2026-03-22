# Airflow Production Pipeline Example: Postgres + API + S3 + dbt

## 1. Purpose of this file

This document shows a realistic production-style Airflow pipeline that integrates:

- Postgres as a source system
- an external HTTP API as an enrichment source
- S3 as storage for raw and intermediate files
- dbt as the transformation layer

The goal of this file is not only to show one DAG, but to explain how to design such a pipeline in a way that is:

- understandable for a mid-level engineer
- safe for retries and reruns
- production-friendly
- architecturally correct

This example is intentionally practical. You should be able to use parts of it directly in your own Airflow project.

--------------------------------------------------

## 2. Business scenario

A company wants to build a daily analytics dataset for order reporting.

Data comes from multiple places:

- operational order data is stored in Postgres
- customer enrichment data is fetched from an external API
- raw extracts and enrichment snapshots are stored in S3
- dbt transforms the staged data into reporting models in the warehouse

The pipeline should:

- extract daily orders from Postgres for a specific interval
- fetch enrichment data from an API for the same interval
- store both datasets in S3 in deterministic locations
- load or expose those raw files to the warehouse
- run dbt models to build analytics-ready tables
- run validation checks
- publish success or fail clearly

This is a realistic pattern because Airflow is often used exactly for this type of coordination.

--------------------------------------------------

## 3. High-level architecture

The pipeline is designed as orchestration, not compute.

Airflow is responsible for:

- scheduling the pipeline
- controlling dependencies
- passing interval context
- managing retries and alerts
- coordinating systems

External systems are responsible for actual work:

- Postgres returns source data
- API returns enrichment data
- S3 stores files
- dbt performs transformation logic in the warehouse

Architecture view:

    Postgres --------\
                      \
                       -> S3 raw/stage -> Warehouse external/staging -> dbt -> marts
                      /
    HTTP API --------/

                       Airflow orchestrates all steps

This separation is important because it keeps Airflow in the control plane and external systems in the data plane.

--------------------------------------------------

## 4. Design principles used in this pipeline

### Interval-driven design

Every task works on a specific Airflow data interval.

This means:

- extraction is scoped to the interval
- enrichment is scoped to the interval
- file paths are interval-based
- dbt is executed with interval parameters

This is critical for:

- retries
- reruns
- backfill
- reproducibility

### Idempotency

The pipeline is designed so that running it again for the same interval produces the same correct result.

This is achieved by:

- deterministic S3 paths
- interval-based extraction
- overwrite-style writes where needed
- dbt transformations that target deterministic partitions or models

### Clear boundaries

The DAG does not embed heavy transformation logic.

Instead:

- extraction tasks extract
- file tasks write files
- dbt task transforms
- validation task validates

This makes failures easier to isolate and recover from.

### Small but meaningful tasks

Tasks are not too small and not too large.

Bad task sizing:

- one giant Python task does extraction + API + write + transform
- ten tiny tasks split one SQL statement into meaningless pieces

Good task sizing:

- extract from Postgres
- fetch API enrichment
- validate raw outputs
- run dbt
- validate final outputs

--------------------------------------------------

## 5. Connections and secrets required

This pipeline assumes the following Airflow Connections exist:

- `postgres_orders` for the Postgres source system
- `customer_api` for the enrichment HTTP API
- `aws_default` for S3 access
- `warehouse_db` if dbt or validation needs warehouse connectivity

It also assumes the following environment variables or secrets are available:

- `DBT_PROFILES_DIR`
- `DBT_PROJECT_DIR`
- `API_TIMEOUT_SECONDS`
- `S3_RAW_BUCKET`
- `S3_STAGE_BUCKET`
- `ALERT_EMAIL`

### Good strategy

Use Airflow Connections and secrets backend or environment variables.

### Bad strategy

Hardcode:

- hostnames
- passwords
- tokens
- bucket names
- dbt profile paths

### Why bad is bad

- unsafe in production
- difficult to rotate credentials
- difficult to move across environments
- fragile deployment process

--------------------------------------------------

## 6. Target task flow

The DAG will contain the following conceptual steps:

1. start
2. extract orders from Postgres for the interval
3. fetch enrichment from API for the interval
4. validate raw files in S3
5. run dbt staging and mart models
6. validate warehouse outputs
7. publish success marker
8. end

Dependency view:

    start
      |\
      | \
      |  \
      |   \
      v    v
    extract_orders_to_s3    fetch_customer_enrichment_to_s3
              \             /
               \           /
                v         v
                 validate_raw_inputs
                         |
                         v
                      run_dbt
                         |
                         v
                 validate_reporting_models
                         |
                         v
                  publish_success_marker
                         |
                         v
                        end

This structure is intentionally simple and production-friendly.

--------------------------------------------------

## 7. Full production-style DAG example

    from datetime import datetime, timedelta
    import json
    import os
    import tempfile

    import requests

    from airflow import DAG
    from airflow.operators.empty import EmptyOperator
    from airflow.operators.bash import BashOperator
    from airflow.operators.python import PythonOperator
    from airflow.exceptions import AirflowFailException
    from airflow.models import Variable

    from airflow.providers.postgres.hooks.postgres import PostgresHook
    from airflow.providers.http.hooks.http import HttpHook
    from airflow.providers.amazon.aws.hooks.s3 import S3Hook


    DEFAULT_ARGS = {
        "owner": "data_platform",
        "depends_on_past": False,
        "email_on_failure": True,
        "email_on_retry": False,
        "retries": 2,
        "retry_delay": timedelta(minutes=10),
    }


    def _get_runtime_config():
        return {
            "raw_bucket": os.environ.get("S3_RAW_BUCKET", "company-raw-data"),
            "stage_bucket": os.environ.get("S3_STAGE_BUCKET", "company-stage-data"),
            "api_timeout_seconds": int(os.environ.get("API_TIMEOUT_SECONDS", "30")),
            "dbt_project_dir": os.environ.get("DBT_PROJECT_DIR", "/opt/airflow/dbt_project"),
            "dbt_profiles_dir": os.environ.get("DBT_PROFILES_DIR", "/opt/airflow/dbt_profiles"),
        }


    def extract_orders_to_s3(**context):
        config = _get_runtime_config()

        start = context["data_interval_start"]
        end = context["data_interval_end"]

        pg_hook = PostgresHook(postgres_conn_id="postgres_orders")
        s3_hook = S3Hook(aws_conn_id="aws_default")

        sql = """
        SELECT
            order_id,
            customer_id,
            order_status,
            order_total,
            created_at
        FROM orders
        WHERE created_at >= %(start)s
          AND created_at < %(end)s
        ORDER BY created_at
        """

        records = pg_hook.get_records(sql, parameters={"start": start, "end": end})

        rows = []
        for row in records:
            rows.append({
                "order_id": row[0],
                "customer_id": row[1],
                "order_status": row[2],
                "order_total": float(row[3]),
                "created_at": row[4].isoformat() if row[4] else None,
            })

        key = (
            f"orders_raw/"
            f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
            f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/"
            f"orders.json"
        )

        payload = json.dumps(rows, ensure_ascii=False)

        s3_hook.load_string(
            string_data=payload,
            key=key,
            bucket_name=config["raw_bucket"],
            replace=True
        )

        context["ti"].xcom_push(key="orders_raw_s3_key", value=key)
        context["ti"].xcom_push(key="orders_record_count", value=len(rows))


    def fetch_customer_enrichment_to_s3(**context):
        config = _get_runtime_config()

        start = context["data_interval_start"]
        end = context["data_interval_end"]

        http_hook = HttpHook(method="GET", http_conn_id="customer_api")
        s3_hook = S3Hook(aws_conn_id="aws_default")

        endpoint = (
            f"/customer-enrichment"
            f"?start={start.isoformat()}"
            f"&end={end.isoformat()}"
        )

        response = http_hook.run(
            endpoint=endpoint,
            extra_options={"timeout": config["api_timeout_seconds"]}
        )

        if response.status_code != 200:
            raise AirflowFailException(
                f"Customer enrichment API returned status {response.status_code}"
            )

        payload = response.text

        key = (
            f"customer_enrichment_raw/"
            f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
            f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/"
            f"enrichment.json"
        )

        s3_hook.load_string(
            string_data=payload,
            key=key,
            bucket_name=config["raw_bucket"],
            replace=True
        )

        context["ti"].xcom_push(key="customer_enrichment_s3_key", value=key)


    def validate_raw_inputs(**context):
        config = _get_runtime_config()

        ti = context["ti"]
        s3_hook = S3Hook(aws_conn_id="aws_default")

        orders_key = ti.xcom_pull(task_ids="extract_orders_to_s3", key="orders_raw_s3_key")
        enrichment_key = ti.xcom_pull(task_ids="fetch_customer_enrichment_to_s3", key="customer_enrichment_s3_key")
        orders_count = ti.xcom_pull(task_ids="extract_orders_to_s3", key="orders_record_count")

        if not orders_key or not enrichment_key:
            raise AirflowFailException("Missing S3 keys from upstream tasks")

        if not s3_hook.check_for_key(key=orders_key, bucket_name=config["raw_bucket"]):
            raise AirflowFailException(f"Orders file does not exist in S3: {orders_key}")

        if not s3_hook.check_for_key(key=enrichment_key, bucket_name=config["raw_bucket"]):
            raise AirflowFailException(f"Enrichment file does not exist in S3: {enrichment_key}")

        if orders_count is None:
            raise AirflowFailException("Orders count missing from XCom")

        if int(orders_count) < 0:
            raise AirflowFailException("Orders count cannot be negative")


    def validate_reporting_models(**context):
        warehouse = PostgresHook(postgres_conn_id="warehouse_db")

        start = context["data_interval_start"]
        end = context["data_interval_end"]

        sql = """
        SELECT COUNT(*)
        FROM analytics.daily_orders_report
        WHERE report_interval_start = %(start)s
          AND report_interval_end = %(end)s
        """

        result = warehouse.get_first(sql, parameters={"start": start, "end": end})

        if result is None:
            raise AirflowFailException("Validation query returned no result")

        row_count = result[0]

        if row_count == 0:
            raise AirflowFailException(
                f"No rows found in analytics.daily_orders_report for interval {start} -> {end}"
            )


    def publish_success_marker(**context):
        config = _get_runtime_config()
        s3_hook = S3Hook(aws_conn_id="aws_default")

        start = context["data_interval_start"]
        end = context["data_interval_end"]

        key = (
            f"pipeline_markers/daily_orders_pipeline/"
            f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
            f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/"
            f"_SUCCESS"
        )

        s3_hook.load_string(
            string_data="success",
            key=key,
            bucket_name=config["stage_bucket"],
            replace=True
        )


    with DAG(
        dag_id="daily_orders_pipeline",
        description="Daily production-style pipeline: Postgres + API + S3 + dbt",
        default_args=DEFAULT_ARGS,
        start_date=datetime(2024, 1, 1),
        schedule="@daily",
        catchup=False,
        max_active_runs=1,
        tags=["production", "orders", "dbt", "s3"],
    ) as dag:

        start = EmptyOperator(task_id="start")

        extract_orders_to_s3_task = PythonOperator(
            task_id="extract_orders_to_s3",
            python_callable=extract_orders_to_s3,
        )

        fetch_customer_enrichment_to_s3_task = PythonOperator(
            task_id="fetch_customer_enrichment_to_s3",
            python_callable=fetch_customer_enrichment_to_s3,
        )

        validate_raw_inputs_task = PythonOperator(
            task_id="validate_raw_inputs",
            python_callable=validate_raw_inputs,
        )

        run_dbt_task = BashOperator(
            task_id="run_dbt",
            bash_command=(
                "cd $DBT_PROJECT_DIR && "
                "dbt run "
                "--profiles-dir $DBT_PROFILES_DIR "
                "--target prod "
                "--vars "
                "'{"
                "interval_start: \"{{ data_interval_start.isoformat() }}\", "
                "interval_end: \"{{ data_interval_end.isoformat() }}\""
                "}'"
            ),
            env={
                "DBT_PROJECT_DIR": "{{ var.value.get('dbt_project_dir', '/opt/airflow/dbt_project') }}",
                "DBT_PROFILES_DIR": "{{ var.value.get('dbt_profiles_dir', '/opt/airflow/dbt_profiles') }}",
            },
        )

        validate_reporting_models_task = PythonOperator(
            task_id="validate_reporting_models",
            python_callable=validate_reporting_models,
        )

        publish_success_marker_task = PythonOperator(
            task_id="publish_success_marker",
            python_callable=publish_success_marker,
        )

        end = EmptyOperator(task_id="end")

        start >> [extract_orders_to_s3_task, fetch_customer_enrichment_to_s3_task]
        [extract_orders_to_s3_task, fetch_customer_enrichment_to_s3_task] >> validate_raw_inputs_task
        validate_raw_inputs_task >> run_dbt_task >> validate_reporting_models_task
        validate_reporting_models_task >> publish_success_marker_task >> end

--------------------------------------------------

## 8. Why this DAG is architecturally correct

### It uses interval-driven logic

The DAG uses:

- `data_interval_start`
- `data_interval_end`

instead of:

- `datetime.now()`
- `today()`
- "latest available data"

This means the pipeline works correctly for:

- normal scheduled runs
- manual reruns
- retries
- backfills

### It keeps Airflow as orchestrator

The DAG does not transform large datasets in Python.

Instead:

- Postgres serves source data
- API serves enrichment data
- S3 stores files
- dbt transforms data

This is the correct Airflow boundary.

### It uses deterministic outputs

S3 keys are based on interval boundaries.

That gives:

- one canonical file location per interval
- rerun-safe behavior
- easier debugging
- easier lineage reasoning

### It validates before and after transformation

This is important because orchestration without validation is weak.

The pipeline validates:

- that raw files exist
- that dbt outputs are populated

This makes failures visible earlier and closer to the source.

--------------------------------------------------

## 9. Good strategy vs bad strategy

### Good strategy

Build pipelines where:

- each task has one clear responsibility
- interval is passed from Airflow context
- external systems do the heavy work
- outputs are deterministic
- retries are safe
- failures are isolated
- validation is explicit

### Bad strategy

Build pipelines where:

- one task performs extraction + API calls + transformation + publishing
- current time is used instead of interval
- output files use random names
- secrets are hardcoded
- retries can duplicate data
- validation is skipped

### Why bad is bad

It creates several production problems at once:

- partial failure is hard to recover from
- reruns change results unpredictably
- scheduler or workers become overloaded
- lineage becomes unclear
- downstream systems consume bad data silently

--------------------------------------------------

## 10. Bad example of the same pipeline

This is an example of how not to design the same workflow.

    def bad_orders_pipeline():
        pg = connect_to_postgres("host=db user=admin password=secret")
        api_key = "my-hardcoded-token"

        orders = pg.query("SELECT * FROM orders WHERE created_at >= NOW() - interval '1 day'")
        enrichment = requests.get(
            "https://customer-api/internal/enrichment",
            headers={"Authorization": f"Bearer {api_key}"}
        ).json()

        combined = []
        for order in orders:
            combined.append(enrich_order(order, enrichment))

        path = f"/tmp/orders_{datetime.now().timestamp()}.json"
        with open(path, "w") as f:
            json.dump(combined, f)

        os.system("dbt run")

### Why this is bad

This example has multiple serious problems:

- hardcoded credentials
- direct use of `NOW()` and `datetime.now()`
- local filesystem output path that is not canonical
- random file naming
- transformation logic mixed into orchestration
- no deterministic interval contract
- no validation
- no safe retry model
- no clear separation between systems

### Production failure scenario

If this task fails after writing the file but before dbt finishes:

- retry creates a second different output file
- dbt may read a stale or wrong file
- analysts see inconsistent reporting results
- debugging is difficult because there is no canonical output path

--------------------------------------------------

## 11. Why each task exists

### `extract_orders_to_s3`

This task is responsible only for extracting interval-scoped order data from Postgres and writing it to a deterministic S3 location.

This is good because:

- its responsibility is narrow
- rerun logic is clear
- if it fails, the problem is local to Postgres extraction or S3 write

### `fetch_customer_enrichment_to_s3`

This task is responsible only for API-based enrichment extraction.

This separation matters because API failures and database failures are different classes of operational issues.

If you combine them in one task:

- retries become more expensive
- one flaky system causes rework in another
- debugging becomes slower

### `validate_raw_inputs`

This task checks whether the expected raw artifacts exist and whether upstream metadata is sane.

This is important because it catches:

- missing files
- incomplete upstream behavior
- incorrect XCom usage
- dependency contract violations

### `run_dbt`

This task delegates business transformation to dbt.

This is the correct architectural boundary because dbt is built for:

- SQL transformation
- lineage
- testing
- modular modeling

Airflow should orchestrate dbt, not replace it.

### `validate_reporting_models`

This task verifies the final business output, not only raw data movement.

This is important because a pipeline can succeed technically but fail semantically.

Example:

- files exist
- dbt ran
- but final report table is empty

Without this task, the DAG could appear healthy while producing bad data.

### `publish_success_marker`

This task creates a success artifact for downstream systems or operations.

This is useful for:

- external consumers
- audit trails
- cross-system coordination

--------------------------------------------------

## 12. Idempotency in this example

This pipeline is designed to be rerun safely.

### Where idempotency comes from

- interval-based extraction
- deterministic S3 keys
- overwrite-style writes to S3
- dbt called with deterministic interval vars
- validation aligned to the same interval

### Good strategy

For any rerun of the same interval:

- read the same source slice
- write to the same target paths
- rebuild the same downstream output

### Bad strategy

For any rerun of the same interval:

- read "latest" data
- write to a new random file
- append blindly to downstream tables

### Why bad is bad

The result starts depending on:

- time of rerun
- number of retries
- random filenames
- side effects

That breaks reproducibility.

--------------------------------------------------

## 13. Airflow Variables and environment usage in this example

The example shows two ways of managing configuration:

### Environment variables

Used for:

- buckets
- dbt project paths
- dbt profiles directory
- timeouts

This is good because environment values are deployment-scoped.

### Airflow Variables

Used in the dbt task example for project and profiles directory lookup.

This is useful for small operational configuration.

### Good strategy

Use:

- Connections for external systems
- environment variables for deployment config
- Variables for small, non-sensitive runtime config
- secrets backend for sensitive values

### Bad strategy

Use Variables for passwords and tokens.

### Why bad is bad

- sensitive values become visible in Airflow metadata/UI
- poor security practice
- harder to audit and rotate

--------------------------------------------------

## 14. dbt integration guidance

This example uses a `BashOperator` to run dbt.

That is a common and practical starting point.

### Good strategy

Use dbt as a separate transformation layer and pass interval parameters from Airflow.

### Bad strategy

Reimplement dbt model logic inside Airflow Python tasks.

### Why bad is bad

- duplicates transformation logic
- weakens lineage
- weakens testing discipline
- creates maintenance problems

### Production note

In more mature setups, teams often run dbt using:

- BashOperator in the Airflow container
- a dedicated Docker/Kubernetes job
- a separate transformation service triggered by Airflow

All three are valid if the boundary remains clear: Airflow orchestrates, dbt transforms.

--------------------------------------------------

## 15. S3 design guidance

S3 is used here for raw artifact storage.

### Good strategy

Use deterministic object keys based on interval and dataset name.

Example:

    orders_raw/interval_start=2024-01-01T00:00:00/interval_end=2024-01-02T00:00:00/orders.json

### Bad strategy

Use random object names.

Example:

    orders_raw/7d9139ae-3f70-4db3-b0d7-42ea0d4b3e1f.json

### Why bad is bad

Random naming causes:

- duplicate artifacts
- hard debugging
- weak lineage
- no canonical output

### Production failure scenario

If a task is retried and writes a new random key:

- downstream readers may read the wrong artifact
- old bad artifacts remain
- operators cannot easily identify the correct output

--------------------------------------------------

## 16. API design guidance

External APIs are usually the least stable part of pipelines.

### Good strategy

Treat APIs as unreliable systems and design around that:

- use retries
- use timeouts
- validate response codes
- validate response payload shape
- isolate API tasks from other tasks

### Bad strategy

Assume API availability and correctness.

### Why bad is bad

APIs commonly fail because of:

- timeouts
- 500 errors
- rate limits
- auth expiry
- partial or malformed payloads

### Production failure scenario

Customer enrichment API returns HTTP 200 but malformed JSON:

- task may write corrupted raw payload
- dbt may fail later
- root cause becomes harder to trace

A stronger version of this pipeline would also validate JSON schema before writing to S3.

--------------------------------------------------

## 17. Postgres extraction guidance

Postgres extraction should be interval-based and explicit.

### Good strategy

Filter by interval boundaries passed from Airflow.

### Bad strategy

Use `NOW()` or latest available data.

### Why bad is bad

Using database current time means:

- reruns do not reproduce the same slice
- backfills become wrong
- results change depending on when the task executes

### Production failure scenario

A delayed DAG run that should process yesterday executes today.

If the SQL uses `NOW()`:
- it extracts the wrong time window
- reporting becomes inconsistent
- historical correction becomes difficult

--------------------------------------------------

## 18. Validation strategy

Validation is often the difference between a pipeline that "runs" and a pipeline that is reliable.

### Raw-level validation

Check:

- file exists
- file count expectations
- non-empty payloads if required
- schema or payload sanity

### Final-model validation

Check:

- downstream table contains rows
- interval partition exists
- row count is within expected bounds
- business constraints pass

### Good strategy

Validate both raw and transformed outputs.

### Bad strategy

Assume success if task execution finished.

### Why bad is bad

Task success is not the same as data correctness.

--------------------------------------------------

## 19. Production failure chains

This section explains how failures propagate in real systems.

### Failure chain 1: Postgres slowdown

- Postgres becomes slow
- extraction task runtime increases
- workers stay occupied longer
- queue time increases for unrelated DAGs
- downstream dbt starts late
- reporting SLA is missed

Architectural lesson:
- upstream source instability can propagate through the orchestration layer if worker resources are limited

### Failure chain 2: API instability

- enrichment API intermittently fails
- task retries increase
- worker slots stay busy
- validation is delayed
- dbt run starts late or not at all
- consumers see missing analytics data

Architectural lesson:
- isolate flaky external systems into separate tasks and retry budgets

### Failure chain 3: Non-deterministic output path

- task writes to random path
- retry creates additional random path
- validation checks only one path
- dbt reads old path or wrong path
- inconsistent business reporting appears

Architectural lesson:
- deterministic storage conventions are part of correctness, not just organization

### Failure chain 4: Weak validation

- raw files are written
- dbt runs successfully
- final model is empty due to logic bug
- DAG reports success
- dashboards show missing data

Architectural lesson:
- success without validation is not reliability

--------------------------------------------------

## 20. Blast radius thinking

Architects should always ask:

- if this task fails, what else fails?
- if this system is slow, what downstream SLA is affected?
- if this write is non-idempotent, how much data gets corrupted?
- if this secret changes, how many DAGs break?

### Good strategy

Minimize blast radius by:

- separating tasks by system responsibility
- using clear contracts
- validating early
- making outputs deterministic
- isolating flaky systems

### Bad strategy

Build one giant task or one giant DAG.

### Why bad is bad

It makes every failure larger than necessary.

--------------------------------------------------

## 21. What to change before real production

This example is strong, but a real production deployment may still add:

- request schema validation for API responses
- structured logging
- metrics emission
- alert routing
- retries tuned separately per task type
- pools and concurrency limits
- deferrable sensors if waiting on external systems
- stronger dbt test integration
- file format optimization such as Parquet instead of JSON for large data
- better warehouse load patterns
- stronger data quality framework

This does not invalidate the example. It means the example is a solid production pattern that can be hardened further as scale grows.

--------------------------------------------------

## 22. Recommended extensions

If you build on top of this pipeline, a good next step is:

- add dbt tests as a dedicated Airflow task
- add row-count reconciliation between Postgres extract and warehouse staging
- move S3 raw files from JSON to Parquet for larger scale
- add alerting task for failure notifications
- add success metrics to monitoring system
- add concurrency controls for API tasks
- add retry differentiation between Postgres and API tasks

--------------------------------------------------

## 23. Summary

This example demonstrates the correct role of Airflow in a production-style data pipeline.

The key principles are:

- Airflow orchestrates, external systems compute
- tasks must be interval-driven
- outputs must be deterministic
- retries must be safe
- validations must be explicit
- responsibilities must be separated
- failures must be isolated where possible

A mid-level engineer can learn from this example by following the structure and reasoning.

An architect can use it as a reference for designing reliable orchestration boundaries and safe production workflows.

--------------------------------------------------