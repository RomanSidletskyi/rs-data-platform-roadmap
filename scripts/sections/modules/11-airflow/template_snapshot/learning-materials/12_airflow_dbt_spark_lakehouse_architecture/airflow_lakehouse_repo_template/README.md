# Airflow + dbt + Spark + Lakehouse Repo Template

This starter project shows a production-oriented structure for:

- Airflow orchestration
- Spark batch processing
- dbt transformation
- lakehouse-style raw and curated storage
- environment separation
- Docker-based local development

## Project structure

    dags/              Airflow DAGs
    config/            Pipeline YAML config
    env/               Example environment files
    dbt/               Minimal dbt project
    spark_jobs/        Example Spark jobs
    tests/             Basic Airflow import tests

## Quick start

1. Copy `.env.example` to `.env`
2. Replace the Fernet key placeholder
3. Run:

    make init
    make up

4. Open Airflow UI:

    http://localhost:8080

5. Check the DAG:

    orders_pipeline_runtime_safe

## Notes

- This template is intentionally minimal but follows good production habits.
- Secrets should not be committed.
- The DAG loads YAML config at runtime, not at parse time.
