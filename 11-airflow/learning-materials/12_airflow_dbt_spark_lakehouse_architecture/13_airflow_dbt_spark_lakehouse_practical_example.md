# Airflow + dbt + Spark + Lakehouse — Full Practical DAG Example

## 1. Purpose

This is a **complete production-style DAG** that:

- reads config from file + env
- runs Spark job
- runs dbt
- validates output
- uses Airflow execution context correctly

---

## 2. Project structure

    project/
      dags/
        orders_pipeline.py
      config/
        pipeline_config.yaml
      env/
        dev.env
      spark_jobs/
        orders_job.py

---

## 3. Config file (YAML)

    pipeline:
      name: orders_pipeline

    spark:
      script_path: /opt/airflow/spark_jobs/orders_job.py
      executor_memory: 2g

    dbt:
      project_dir: ${DBT_PROJECT_DIR}
      profiles_dir: ${DBT_PROFILES_DIR}

---

## 4. Full DAG (DETAILED)

    import os
    import yaml
    from datetime import datetime

    from airflow import DAG
    from airflow.operators.python import PythonOperator
    from airflow.operators.bash import BashOperator
    from airflow.operators.empty import EmptyOperator

    # -------------------------
    # LOAD CONFIG (PARSE SAFE)
    # -------------------------

    CONFIG_PATH = "/opt/airflow/config/pipeline_config.yaml"

    def load_config():
        with open(CONFIG_PATH) as f:
            return yaml.safe_load(f)

    CONFIG = load_config()

    # -------------------------
    # ENV VARIABLES
    # -------------------------

    RAW_BUCKET = os.environ.get("S3_RAW_BUCKET")
    DBT_PROJECT_DIR = os.environ.get("DBT_PROJECT_DIR")
    DBT_PROFILES_DIR = os.environ.get("DBT_PROFILES_DIR")
    DBT_TARGET = os.environ.get("DBT_TARGET")

    # -------------------------
    # TASK FUNCTIONS
    # -------------------------

    def run_spark_job(**context):
        start = context["data_interval_start"]
        end = context["data_interval_end"]

        spark_script = CONFIG["spark"]["script_path"]
        memory = CONFIG["spark"]["executor_memory"]

        output_path = f"s3://{RAW_BUCKET}/orders/{start.strftime('%Y-%m-%d')}"

        command = f"""
        spark-submit \
          --name orders_job \
          --conf spark.executor.memory={memory} \
          {spark_script} \
          --start {start} \
          --end {end} \
          --output {output_path}
        """

        print("Running Spark command:")
        print(command)

        os.system(command)

    # -------------------------
    # VALIDATION TASK
    # -------------------------

    def validate_data(**context):
        start = context["data_interval_start"]

        print(f"Validating data for interval {start}")

        # Example validation
        # In real case:
        # - check S3 file exists
        # - check row counts
        # - query warehouse

        print("Validation OK")

    # -------------------------
    # DAG DEFINITION
    # -------------------------

    with DAG(
        dag_id="orders_pipeline",
        start_date=datetime(2024, 1, 1),
        schedule="@daily",
        catchup=False,
        max_active_runs=1,
        tags=["lakehouse", "spark", "dbt"]
    ) as dag:

        # -------------------------
        # START
        # -------------------------

        start = EmptyOperator(task_id="start")

        # -------------------------
        # SPARK TASK
        # -------------------------

        spark_task = PythonOperator(
            task_id="run_spark",
            python_callable=run_spark_job,
        )

        # -------------------------
        # DBT TASK (ВАЖЛИВО)
        # -------------------------

        dbt_task = BashOperator(
            task_id="run_dbt",
            bash_command=f"""
            cd {DBT_PROJECT_DIR} && \
            dbt run \
              --profiles-dir {DBT_PROFILES_DIR} \
              --target {DBT_TARGET} \
              --vars '
              {{
                "start": "{{{{ data_interval_start.isoformat() }}}}",
                "end": "{{{{ data_interval_end.isoformat() }}}}"
              }}'
            """
        )

        # -------------------------
        # VALIDATION
        # -------------------------

        validation_task = PythonOperator(
            task_id="validate",
            python_callable=validate_data,
        )

        # -------------------------
        # END
        # -------------------------

        end = EmptyOperator(task_id="end")

        # -------------------------
        # DEPENDENCIES (FLOW)
        # -------------------------

        start >> spark_task >> dbt_task >> validation_task >> end

---

## 5. How dbt task works (important)

### What happens

- Airflow запускає BashOperator
- переходить в dbt project
- виконує:

    dbt run

### What is passed

    --vars:
      start = Airflow interval start
      end = Airflow interval end

---

## 6. Parameter flow

### Airflow context

    data_interval_start
    data_interval_end

↓

### Passed to Spark

    --start
    --end

↓

### Passed to dbt

    --vars start/end

---

## 7. Execution flow

    start
      ↓
    Spark job (heavy compute)
      ↓
    dbt run (SQL transformations)
      ↓
    validation
      ↓
    end

---

## 8. Good vs bad design

### Good

- Spark handles compute
- dbt handles transformation
- Airflow orchestrates
- config externalized

---

### Bad

- pandas inside Airflow
- SQL inside PythonOperator
- hardcoded paths

---

## 9. Production notes

### Important

- dbt must NOT be inside Python logic
- Spark must NOT run inside worker memory-heavy loops
- all paths must be deterministic

---

## 10. Common mistake

### Bad

    datetime.now()

### Good

    context["data_interval_start"]

---

## 11. Final principles

- Airflow = orchestration  
- Spark = compute  
- dbt = transformation  
- config = external  
- interval = everything  

--------------------------------------------------