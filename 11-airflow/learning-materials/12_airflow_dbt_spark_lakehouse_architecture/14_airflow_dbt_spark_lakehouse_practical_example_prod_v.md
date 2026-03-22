# Airflow + dbt + Spark + Lakehouse — Correct Runtime-Safe DAG

## 1. Why this version is better

This version avoids a common Airflow mistake:

- reading configuration at top-level during DAG parsing

Instead, it follows a safer production pattern:

- top-level code only defines DAG structure
- runtime code loads configuration only when task executes

This reduces scheduler pressure and makes the DAG safer for large-scale environments.

--------------------------------------------------

## 2. Project structure

    project/
      dags/
        orders_pipeline.py
      config/
        pipeline_config.yaml
      env/
        dev.env
        stage.env
        prod.env
      spark_jobs/
        orders_job.py
      dbt/
        dbt_project/
      scripts/
        validation.py

--------------------------------------------------

## 3. Example config file

File:

    config/pipeline_config.yaml

Content:

    pipeline:
      name: orders_pipeline

    spark:
      script_path: /opt/airflow/spark_jobs/orders_job.py
      executor_memory: 2g
      app_name: orders_job

    storage:
      raw_prefix: orders/raw
      curated_prefix: orders/curated

    validation:
      require_non_empty_output: true

This file is intentionally:

- small
- local
- deterministic

Even then, in this improved version, it is loaded at runtime, not at parse time.

--------------------------------------------------

## 4. Example environment file

File:

    env/dev.env

Content:

    S3_RAW_BUCKET=company-dev-raw
    S3_CURATED_BUCKET=company-dev-curated
    DBT_TARGET=dev
    DBT_PROJECT_DIR=/opt/airflow/dbt/dbt_project
    DBT_PROFILES_DIR=/opt/airflow/dbt_profiles

--------------------------------------------------

## 5. Design rules used in this DAG

### Rule 1. No heavy top-level code

Top-level code must not:

- call APIs
- query databases
- read from S3
- read large files
- build dynamic structures from external systems

### Rule 2. Runtime config loading

Configuration is loaded inside task execution functions.

### Rule 3. Airflow orchestrates only

- Spark computes
- dbt transforms
- Airflow coordinates

### Rule 4. Interval-driven execution

Everything uses:

- `data_interval_start`
- `data_interval_end`

not:

- `datetime.now()`
- `today()`

--------------------------------------------------

## 6. Full DAG (runtime-safe version)

    import os
    import subprocess
    import yaml

    from datetime import datetime, timedelta

    from airflow import DAG
    from airflow.operators.empty import EmptyOperator
    from airflow.operators.python import PythonOperator
    from airflow.operators.bash import BashOperator
    from airflow.exceptions import AirflowFailException


    DEFAULT_ARGS = {
        "owner": "data_platform",
        "depends_on_past": False,
        "email_on_failure": True,
        "email_on_retry": False,
        "retries": 2,
        "retry_delay": timedelta(minutes=10),
    }


    CONFIG_PATH = "/opt/airflow/config/pipeline_config.yaml"


    def load_runtime_config():
        """
        Runtime-safe config loading.

        This function is called only when a task runs.
        It does not execute during DAG parsing.
        """
        with open(CONFIG_PATH, "r") as f:
            return yaml.safe_load(f)


    def get_env_config():
        """
        Reads environment variables at runtime.
        Environment values are deployment-specific.
        """
        return {
            "raw_bucket": os.environ.get("S3_RAW_BUCKET"),
            "curated_bucket": os.environ.get("S3_CURATED_BUCKET"),
            "dbt_target": os.environ.get("DBT_TARGET"),
            "dbt_project_dir": os.environ.get("DBT_PROJECT_DIR"),
            "dbt_profiles_dir": os.environ.get("DBT_PROFILES_DIR"),
        }


    def validate_required_runtime_settings(config, env_config):
        """
        Fail fast if runtime config or environment variables are missing.
        """
        required_env = [
            "raw_bucket",
            "curated_bucket",
            "dbt_target",
            "dbt_project_dir",
            "dbt_profiles_dir",
        ]

        for key in required_env:
            if not env_config.get(key):
                raise AirflowFailException(f"Missing required environment setting: {key}")

        if "spark" not in config:
            raise AirflowFailException("Missing 'spark' section in pipeline config")

        if "storage" not in config:
            raise AirflowFailException("Missing 'storage' section in pipeline config")


    def run_spark_job(**context):
        """
        Runtime task that:
        - loads config
        - reads Airflow interval
        - builds deterministic output path
        - triggers Spark externally
        """
        config = load_runtime_config()
        env_config = get_env_config()
        validate_required_runtime_settings(config, env_config)

        start = context["data_interval_start"]
        end = context["data_interval_end"]

        spark_script = config["spark"]["script_path"]
        spark_executor_memory = config["spark"]["executor_memory"]
        spark_app_name = config["spark"]["app_name"]

        raw_prefix = config["storage"]["raw_prefix"]
        raw_bucket = env_config["raw_bucket"]

        output_path = (
            f"s3://{raw_bucket}/"
            f"{raw_prefix}/"
            f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
            f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/"
        )

        command = [
            "spark-submit",
            "--name", spark_app_name,
            "--conf", f"spark.executor.memory={spark_executor_memory}",
            spark_script,
            "--start", start.isoformat(),
            "--end", end.isoformat(),
            "--output", output_path,
        ]

        print("Running Spark command:")
        print(" ".join(command))

        result = subprocess.run(command, capture_output=True, text=True)

        print("Spark stdout:")
        print(result.stdout)

        print("Spark stderr:")
        print(result.stderr)

        if result.returncode != 0:
            raise AirflowFailException(
                f"Spark job failed with return code {result.returncode}"
            )


    def validate_raw_output(**context):
        """
        Example validation task.

        In real production this would typically:
        - check S3 path exists
        - validate row counts
        - validate schema
        - validate file freshness
        """
        config = load_runtime_config()
        env_config = get_env_config()
        validate_required_runtime_settings(config, env_config)

        start = context["data_interval_start"]
        end = context["data_interval_end"]

        raw_prefix = config["storage"]["raw_prefix"]
        raw_bucket = env_config["raw_bucket"]

        expected_path = (
            f"s3://{raw_bucket}/"
            f"{raw_prefix}/"
            f"interval_start={start.strftime('%Y-%m-%dT%H:%M:%S')}/"
            f"interval_end={end.strftime('%Y-%m-%dT%H:%M:%S')}/"
        )

        print(f"Validate raw output path: {expected_path}")

        require_non_empty_output = config.get("validation", {}).get("require_non_empty_output", True)

        if require_non_empty_output:
            print("Validation rule enabled: output must not be empty")

        print("Raw validation passed")


    def validate_curated_output(**context):
        """
        Example post-dbt validation task.

        In real production this could:
        - query warehouse
        - validate partition exists
        - validate row counts
        - validate freshness
        """
        env_config = get_env_config()

        start = context["data_interval_start"]
        end = context["data_interval_end"]

        print(
            f"Validate curated output for interval "
            f"{start.isoformat()} -> {end.isoformat()} "
            f"using dbt target {env_config['dbt_target']}"
        )

        print("Curated validation passed")


    with DAG(
        dag_id="orders_pipeline_runtime_safe",
        description="Runtime-safe Airflow DAG for Spark + dbt + lakehouse pattern",
        default_args=DEFAULT_ARGS,
        start_date=datetime(2024, 1, 1),
        schedule="@daily",
        catchup=False,
        max_active_runs=1,
        tags=["lakehouse", "spark", "dbt", "runtime-safe"],
    ) as dag:

        start = EmptyOperator(task_id="start")

        spark_task = PythonOperator(
            task_id="run_spark_job",
            python_callable=run_spark_job,
        )

        validate_raw_task = PythonOperator(
            task_id="validate_raw_output",
            python_callable=validate_raw_output,
        )

        dbt_task = BashOperator(
            task_id="run_dbt",
            bash_command="""
            cd "$DBT_PROJECT_DIR" && \
            dbt run \
              --profiles-dir "$DBT_PROFILES_DIR" \
              --target "$DBT_TARGET" \
              --vars '
              {
                "start": "{{ data_interval_start.isoformat() }}",
                "end": "{{ data_interval_end.isoformat() }}"
              }'
            """,
            env={
                "DBT_PROJECT_DIR": os.environ.get("DBT_PROJECT_DIR", ""),
                "DBT_PROFILES_DIR": os.environ.get("DBT_PROFILES_DIR", ""),
                "DBT_TARGET": os.environ.get("DBT_TARGET", ""),
            },
        )

        validate_curated_task = PythonOperator(
            task_id="validate_curated_output",
            python_callable=validate_curated_output,
        )

        end = EmptyOperator(task_id="end")

        start >> spark_task >> validate_raw_task >> dbt_task >> validate_curated_task >> end

--------------------------------------------------

## 7. Where config is read now

### At top-level

Only safe static values are defined:

    CONFIG_PATH = "/opt/airflow/config/pipeline_config.yaml"

This is safe because it is only a string constant.

### At runtime

The actual config file content is read only inside task execution:

    config = load_runtime_config()

This means:

- scheduler does not read YAML contents during every parse cycle
- config loading happens only when task actually runs
- risk to scheduler is much lower

--------------------------------------------------

## 8. Why this is better than top-level config loading

### Old pattern

    CONFIG = load_config()

Problem:

- executed during DAG parse
- scheduler pays the cost repeatedly
- risk grows with DAG count

### New pattern

    def run_spark_job(**context):
        config = load_runtime_config()

Advantage:

- only task execution pays the cost
- scheduler stays lighter
- runtime failures stay localized to the task

### Good strategy

Top-level should contain only:

- imports
- constants
- DAG structure
- task definitions

### Bad strategy

Top-level should not contain:

- external reads
- network calls
- large file loads
- dynamic heavy generation

### Why bad is bad

Because parse-time cost multiplies across:

- scheduler cycles
- number of DAGs
- number of parsing processes

--------------------------------------------------

## 9. Detailed explanation of the dbt task

This task is created here:

    dbt_task = BashOperator(
        task_id="run_dbt",
        ...
    )

### What it does

- changes directory into the dbt project
- runs `dbt run`
- points dbt to the correct profiles directory
- selects the correct dbt target from environment
- passes Airflow interval boundaries as dbt vars

### Why BashOperator is used here

Because dbt is an external transformation tool.

Airflow should orchestrate dbt, not reimplement dbt logic.

### What is passed to dbt

    --vars '
    {
      "start": "{{ data_interval_start.isoformat() }}",
      "end": "{{ data_interval_end.isoformat() }}"
    }'

This means dbt models can use:

- `start`
- `end`

for interval-driven filtering.

### Why this is correct

- dbt receives deterministic interval boundaries
- reruns work correctly
- backfills work correctly
- dbt target changes per environment without changing DAG code

--------------------------------------------------

## 10. How parameters flow through the DAG

### Airflow runtime context provides

- `data_interval_start`
- `data_interval_end`

### Spark task receives

- `--start`
- `--end`
- deterministic output path

### dbt task receives

- dbt target from environment
- profiles dir from environment
- start/end via dbt vars

### Validation tasks receive

- same Airflow interval context
- same env config
- same YAML-driven rules

This is the correct pattern because every task is aligned to the same logical interval.

--------------------------------------------------

## 11. Why this DAG is more production-safe

### Reason 1. Parse-safe structure

Top-level code is minimal.

### Reason 2. Runtime config loading

Configuration is loaded only when needed.

### Reason 3. Clear boundaries

- Spark computes
- dbt transforms
- Airflow orchestrates
- validation tasks validate

### Reason 4. Deterministic interval logic

Everything is tied to Airflow interval boundaries.

### Reason 5. Better failure isolation

If config load fails, it fails inside the task, not in the scheduler parse loop.

--------------------------------------------------

## 12. Good vs bad configuration pattern

### Good pattern

- DAG structure at top-level
- runtime config inside task functions
- secrets in environment / connections
- small local config file
- interval-driven task execution

### Bad pattern

- read config from S3 at top-level
- read config from DB at top-level
- hardcode env-specific values in DAG
- mix secrets into YAML committed to Git
- use `datetime.now()` in tasks

### Why bad is bad

This leads to:

- scheduler slowdown
- unsafe environment promotion
- security risk
- broken reruns
- fragile pipelines

--------------------------------------------------

## 13. Production notes

### Note 1. Small local YAML can be top-level in some teams

That is sometimes acceptable if the file is:

- tiny
- local
- deterministic
- static

But runtime loading is still the safer pattern.

### Note 2. Environment variables should stay environment-specific

The same DAG code should work across:

- dev
- stage
- prod

Only environment-specific values should change.

### Note 3. Validation should become real over time

This example prints success, but mature production systems should validate:

- file existence
- row counts
- schema
- warehouse partition presence
- freshness
- business constraints

--------------------------------------------------

## 14. Common mistakes

### Mistake 1. Reading config at parse time

    CONFIG = load_config()

Not always catastrophic, but risky when scaled.

### Mistake 2. Using Airflow for compute

    df = pandas.read_parquet(...)
    df = transform(df)

Wrong layer.

### Mistake 3. Using current time instead of interval

    datetime.now()

Breaks reruns and backfills.

### Mistake 4. Hardcoding dbt target

    --target prod

Prevents clean promotion across environments.

--------------------------------------------------

## 15. Final principles

- top-level code should be cheap
- runtime logic should do real work
- Airflow should orchestrate, not compute
- Spark should handle heavy processing
- dbt should handle SQL transformation
- all tasks should be interval-driven
- config should be externalized and environment-aware

--------------------------------------------------