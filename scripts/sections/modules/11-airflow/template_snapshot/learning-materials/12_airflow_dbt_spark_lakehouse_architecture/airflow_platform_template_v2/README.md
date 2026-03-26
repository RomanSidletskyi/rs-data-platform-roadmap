# Airflow Platform Template v2

This repository is a practical starter template for a modern Airflow-based data platform.

It demonstrates:

- Apache Airflow orchestration
- production-style Docker Compose with Celery + Redis + PostgreSQL
- environment separation
- Postgres source extraction
- HTTP API enrichment
- S3-style raw storage pattern
- Spark-style batch processing
- dbt transformation
- basic CI/CD
- runtime-safe configuration loading

--------------------------------------------------

## What this template is for

Use this project when you want to learn or bootstrap a platform that follows good Airflow patterns:

- Airflow orchestrates
- external systems compute
- config is externalized
- environments are separated
- scheduler-safe DAG structure is respected
- CI checks catch import problems before deploy

--------------------------------------------------

## What the final system includes

When you run this template, you get:

- Airflow Webserver
- Airflow Scheduler
- Airflow Celery Worker
- PostgreSQL metadata database
- Redis broker
- a production-style example DAG
- a minimal dbt project
- a pseudo Spark-style job script
- test scaffolding
- GitHub Actions CI example

--------------------------------------------------

## High-level flow

    Postgres source ----\
                         \
                          -> Airflow DAG -> raw artifacts
                         /
    HTTP API source -----/

    Airflow DAG -> Spark-style processing -> curated artifacts
    Airflow DAG -> dbt run -> transformed models
    Airflow DAG -> validation tasks

--------------------------------------------------

## Why it is structured this way

The template is intentionally built to teach good habits:

- the DAG file is parse-safe
- config is loaded at runtime, not parse time
- Spark-style processing is isolated from orchestration
- dbt is run as an external transformation tool
- CeleryExecutor demonstrates scheduler/worker separation
- PostgreSQL is used because SQLite is not suitable for serious environments
- CI checks DAG import health before deployment

--------------------------------------------------

## Repository structure

    dags/
      Airflow DAG definitions

    config/
      Runtime-safe pipeline YAML config

    env/
      Example environment files for dev / stage / prod

    dbt/
      Minimal dbt project and models

    spark_jobs/
      Example Spark-style batch job script

    tests/
      Basic DAG import tests

    .github/workflows/
      CI pipeline example

    docker-compose.yml
      Local production-style stack

    .env.example
      Example environment variables

    Makefile
      Convenience commands

    requirements.txt
      Local dependency list for tests/linting

--------------------------------------------------

## What each main folder does

### dags/

Contains Airflow DAGs.

The included DAG:

- reads config safely at runtime
- extracts from Postgres
- fetches enrichment from API
- prepares S3-style output paths
- runs a Spark-style processing task
- runs dbt
- validates outputs

### config/

Contains pipeline configuration that is safe to keep in source control.

Examples:

- Spark script path
- validation settings
- storage prefixes
- connection ID references

### env/

Contains environment examples for:

- dev
- stage
- prod

These demonstrate how configuration changes between environments.

### dbt/

Contains a minimal dbt project to show how Airflow triggers dbt.

### spark_jobs/

Contains a pseudo Spark-style job script.
It is intentionally lightweight so the project stays runnable without a real Spark cluster.

### tests/

Contains DAG import tests, which are one of the most important first checks in Airflow CI.

--------------------------------------------------

## What each top-level file does

### docker-compose.yml

Starts:

- Postgres
- Redis
- Airflow init container
- Airflow webserver
- Airflow scheduler
- Airflow worker

This gives you a local setup closer to real production than a single-process Airflow.

### .env.example

Example environment variables for:

- Airflow platform config
- dbt target
- bucket names
- API base URL

### Makefile

Provides short commands for setup and lifecycle management.

### requirements.txt

Used for local validation and CI testing.

--------------------------------------------------

## What you need to do

### Step 1. Copy environment file

Copy:

    .env.example

to:

    .env

### Step 2. Generate a Fernet key

Run:

    python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"

Paste the value into:

    AIRFLOW__CORE__FERNET_KEY

in `.env`.

### Step 3. Start the platform

Initialize Airflow:

    make init

Start the services:

    make up

### Step 4. Open Airflow UI

    http://localhost:8080

Login:

- username: admin
- password: admin

### Step 5. Create Connections in Airflow UI

Expected connections:

- `postgres_source`
- `customer_api`
- `aws_default`

Path in UI:

- Admin -> Connections

### Step 6. Trigger the DAG

Look for:

- `orders_platform_pipeline`

Trigger it manually and inspect logs.

--------------------------------------------------

## Recommended Connections

### postgres_source

Use for source extraction.

Suggested example values:

- Conn Type: Postgres
- Host: host.docker.internal
- Schema: source_db
- Login: source_user
- Password: source_password
- Port: 5432

### customer_api

Use for HTTP enrichment.

Suggested example values:

- Conn Type: HTTP
- Host: https://example-api.local

### aws_default

Use for S3-compatible storage pattern.

Suggested example values depend on your provider.

--------------------------------------------------

## Required environment variables

Examples included in `.env.example`:

- `AIRFLOW__CORE__EXECUTOR`
- `AIRFLOW__DATABASE__SQL_ALCHEMY_CONN`
- `AIRFLOW__CELERY__BROKER_URL`
- `AIRFLOW__CELERY__RESULT_BACKEND`
- `AIRFLOW__CORE__FERNET_KEY`
- `S3_RAW_BUCKET`
- `S3_CURATED_BUCKET`
- `DBT_TARGET`
- `DBT_PROJECT_DIR`
- `DBT_PROFILES_DIR`
- `API_BASE_URL`
- `ALERT_SLACK_CHANNEL`

--------------------------------------------------

## What this template demonstrates well

- runtime-safe DAG design
- CeleryExecutor local stack
- environment-aware configuration
- Postgres/API integration pattern
- Spark/dbt orchestration pattern
- CI-friendly structure

--------------------------------------------------

## What you would usually add next in real production

- real object storage integration
- warehouse loading logic
- stronger validation
- secrets backend
- remote logging
- monitoring and alerting
- staged promotion pipeline
- infrastructure-as-code

--------------------------------------------------

## Final reminder

The most important idea in this repository is simple:

- Airflow orchestrates
- external systems compute
- config should be external
- top-level DAG code should stay cheap
- retries and reruns should be safe

