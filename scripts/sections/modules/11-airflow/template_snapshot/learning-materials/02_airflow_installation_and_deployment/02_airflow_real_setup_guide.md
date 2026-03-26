# Airflow Real Setup Guide

## Purpose of this file

This file is a practical setup guide for running Apache Airflow in a way that is useful for learning, local development, and as a foundation for a production-like environment.

This guide covers:

- a Docker-based setup that is the recommended default
- a local Python installation for learning and quick experimentation
- a Git-based project structure
- environment variables and configuration
- Airflow Variables, Connections, and Secrets
- a minimal production-like baseline
- common mistakes and how to avoid them

This guide is intentionally practical. The goal is that you can use it directly as a starting point without having to search many other sources.

--------------------------------------------------

## Recommended setup path

If you are learning Airflow seriously, the best path is:

1. start with Docker
2. understand the local Python install only for learning purposes
3. move all code into Git from day one
4. use environment variables and Connections correctly
5. keep secrets out of DAG code
6. treat local setup as preparation for production, not as a toy

### Good strategy

- use Docker as the main local environment
- keep the project in a Git repository
- use `.env` for local configuration
- keep DAGs, logs, plugins, and requirements organized
- use Airflow Connections for external systems

### Bad strategy

- install packages globally on your machine and hope everything works
- edit DAGs directly on a server
- hardcode credentials in DAGs
- use the same setup for learning and production without thinking about differences

### Why bad is bad

- environment drift appears quickly
- dependencies become inconsistent
- secrets leak into code
- deployment becomes manual and error-prone
- debugging gets much harder over time

--------------------------------------------------

## Recommended directory structure

Use a project structure like this from the beginning:

    airflow-starter-pack/
        dags/
            example_dag.py
        plugins/
        logs/
        config/
        .env.example
        docker-compose.yml
        Makefile
        requirements.txt
        05_airflow_real_setup_guide.md

### Explanation

- `dags/` contains workflow definitions
- `plugins/` contains custom operators, hooks, or shared Airflow plugin code if needed later
- `logs/` stores task execution logs in local development
- `config/` can contain custom configuration files if you later need them
- `.env.example` documents required local environment variables
- `docker-compose.yml` defines the local multi-service environment
- `Makefile` makes startup and maintenance commands consistent
- `requirements.txt` lists Python dependencies that should be installed into the Airflow image or local virtual environment

### Good strategy

Treat this structure as the minimum professional baseline.

### Bad strategy

Put everything in one folder, or place shared Python helpers directly inside DAG files.

### Why bad is bad

- code becomes hard to navigate
- reuse is poor
- deployment logic becomes mixed with DAG logic
- refactoring becomes painful

--------------------------------------------------

## Option 1: Docker setup (recommended default)

## Why Docker should be your default

Docker is the best default for serious Airflow learning because it lets you run multiple services in a way that resembles how Airflow actually works.

A realistic Airflow environment usually includes at least:

- webserver
- scheduler
- metadata database
- optionally workers
- optionally a broker such as Redis when using CeleryExecutor

Even if your first setup is simple, it is better to learn Airflow as a multi-component system.

### Good strategy

Use Docker Compose with separate services.

### Bad strategy

Run everything in one Python process and assume that is enough to understand Airflow.

### Why bad is bad

- hides Airflow architecture
- gives a false mental model
- makes production transition harder

--------------------------------------------------

## Docker Compose file

Save this as `docker-compose.yml`.

    version: "3.8"

    x-airflow-common: &airflow-common
      image: apache/airflow:2.9.3
      env_file:
        - .env
      environment:
        AIRFLOW__CORE__EXECUTOR: LocalExecutor
        AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
        AIRFLOW__CORE__LOAD_EXAMPLES: "False"
        AIRFLOW__WEBSERVER__EXPOSE_CONFIG: "False"
        AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: "True"
        AIRFLOW__CORE__FERNET_KEY: ${AIRFLOW__CORE__FERNET_KEY}
        AIRFLOW_UID: ${AIRFLOW_UID:-50000}
        AIRFLOW_GID: ${AIRFLOW_GID:-0}
        _PIP_ADDITIONAL_REQUIREMENTS: ${_PIP_ADDITIONAL_REQUIREMENTS:-}
      volumes:
        - ./dags:/opt/airflow/dags
        - ./logs:/opt/airflow/logs
        - ./plugins:/opt/airflow/plugins
        - ./requirements.txt:/requirements.txt
      user: "${AIRFLOW_UID:-50000}:${AIRFLOW_GID:-0}"
      depends_on:
        postgres:
          condition: service_healthy

    services:
      postgres:
        image: postgres:15
        environment:
          POSTGRES_USER: airflow
          POSTGRES_PASSWORD: airflow
          POSTGRES_DB: airflow
        healthcheck:
          test: ["CMD", "pg_isready", "-U", "airflow"]
          interval: 5s
          retries: 5
        volumes:
          - postgres-db-volume:/var/lib/postgresql/data

      airflow-init:
        <<: *airflow-common
        entrypoint: /bin/bash
        command:
          - -c
          - |
            airflow db migrate && \
            airflow users create \
              --username ${AIRFLOW_ADMIN_USERNAME} \
              --password ${AIRFLOW_ADMIN_PASSWORD} \
              --firstname Airflow \
              --lastname Admin \
              --role Admin \
              --email admin@example.com

      airflow-webserver:
        <<: *airflow-common
        command: webserver
        ports:
          - "8080:8080"
        healthcheck:
          test: ["CMD", "curl", "--fail", "http://localhost:8080/health"]
          interval: 10s
          timeout: 10s
          retries: 5
        restart: unless-stopped

      airflow-scheduler:
        <<: *airflow-common
        command: scheduler
        restart: unless-stopped

    volumes:
      postgres-db-volume:

### Why this setup is useful

This setup gives you:

- PostgreSQL as the metadata database
- LocalExecutor for local parallelism
- a dedicated scheduler process
- a dedicated webserver process
- mounted DAGs, logs, and plugins so changes are visible immediately

### Good strategy

Use this setup as your default local development environment.

### Bad strategy

Keep changing images, versions, or configuration randomly without version control.

### Why bad is bad

- hard to reproduce failures
- onboarding becomes inconsistent
- upgrades become risky

--------------------------------------------------

## `.env` example

Save this as `.env.example`, then copy it to `.env` locally.

    AIRFLOW_ADMIN_USERNAME=admin
    AIRFLOW_ADMIN_PASSWORD=admin
    AIRFLOW__CORE__FERNET_KEY=replace_this_with_a_real_fernet_key
    AIRFLOW_UID=50000
    AIRFLOW_GID=0
    _PIP_ADDITIONAL_REQUIREMENTS=

### How to use it

1. copy `.env.example` to `.env`
2. set a real Fernet key
3. set your local admin credentials
4. do not commit `.env` to Git

### Good strategy

Commit `.env.example`, ignore `.env`.

### Bad strategy

Commit `.env` with real passwords.

### Why bad is bad

- credentials leak into Git history
- developers may accidentally reuse insecure defaults in shared environments

--------------------------------------------------

## How to generate a Fernet key

Airflow uses a Fernet key to encrypt certain values in the metadata database.

You can generate one with Python:

    python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"

### Good strategy

Generate one stable key per environment and keep it secure.

### Bad strategy

Change the Fernet key casually after data already exists.

### Why bad is bad

- previously encrypted values may become unreadable
- environment breaks unexpectedly

--------------------------------------------------

## Docker startup workflow

From the project root:

    cp .env.example .env
    mkdir -p dags logs plugins config
    docker compose up airflow-init
    docker compose up -d

Then open:

    http://localhost:8080

Log in using the values from `.env`.

### First-run checklist

After startup, verify:

- the webserver is reachable
- the scheduler is running
- the example DAG in `dags/` is visible
- task logs are written to `logs/`
- the metadata database is healthy

--------------------------------------------------

## Basic Makefile

Save this as `Makefile`.

    .PHONY: init up down restart logs ps clean

    init:
    	docker compose up airflow-init

    up:
    	docker compose up -d

    down:
    	docker compose down

    restart:
    	docker compose down && docker compose up -d

    logs:
    	docker compose logs -f

    ps:
    	docker compose ps

    clean:
    	docker compose down -v

### Why a Makefile helps

It standardizes commands and reduces human error.

### Good strategy

Use a Makefile or shell scripts so everyone on the project uses the same commands.

### Bad strategy

Rely on memory or personal command history.

### Why bad is bad

- inconsistent workflows
- more mistakes during onboarding
- repeated manual errors

--------------------------------------------------

## Requirements file

Save this as `requirements.txt`.

    apache-airflow==2.9.3
    apache-airflow-providers-postgres
    apache-airflow-providers-http
    apache-airflow-providers-cncf-kubernetes
    apache-airflow-providers-databricks

### Why include providers

Airflow core does not include every provider integration you may need.

If you plan to connect to databases, APIs, or Databricks, provider packages are often required.

### Good strategy

Pin versions explicitly and add only what you actually need.

### Bad strategy

Install random provider packages without version discipline.

### Why bad is bad

- dependency conflicts
- unexpected breaking changes
- harder upgrades

--------------------------------------------------

## Example DAG for validation

Save this as `dags/example_dag.py`.

    from datetime import datetime

    from airflow import DAG
    from airflow.operators.bash import BashOperator
    from airflow.operators.python import PythonOperator


    def print_context(**context):
        print("Logical date:", context["logical_date"])
        print("Data interval start:", context["data_interval_start"])
        print("Data interval end:", context["data_interval_end"])


    with DAG(
        dag_id="example_local_validation_dag",
        start_date=datetime(2024, 1, 1),
        schedule="@daily",
        catchup=False,
        tags=["starter", "validation"],
    ) as dag:
        start = BashOperator(
            task_id="start",
            bash_command="echo 'Airflow is running correctly'",
        )

        show_context = PythonOperator(
            task_id="show_context",
            python_callable=print_context,
        )

        finish = BashOperator(
            task_id="finish",
            bash_command="echo 'Validation complete'",
        )

        start >> show_context >> finish

### Why this DAG is useful

It validates:

- DAG discovery
- scheduler execution
- Python task execution
- log writing
- context values such as logical date and interval boundaries

--------------------------------------------------

## Option 2: Local Python install (for learning only)

## When local install is acceptable

A local install is useful only when:

- you want to understand Airflow commands
- you want to inspect behavior quickly
- you do not need production realism

It is not recommended as your main environment once you move beyond the basics.

### Good strategy

Use local install only for quick learning.

### Bad strategy

Build a serious project on a bare local install.

### Why bad is bad

- environment drift
- hidden dependency conflicts
- poor reproducibility

--------------------------------------------------

## Local install steps

Create and activate a virtual environment:

    python -m venv .venv
    source .venv/bin/activate

Upgrade pip and install Airflow:

    pip install --upgrade pip
    pip install "apache-airflow==2.9.3" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.9.3/constraints-3.10.txt"

Set the Airflow home directory:

    export AIRFLOW_HOME=$(pwd)/.airflow

Initialize the metadata database:

    airflow db migrate

Create an admin user:

    airflow users create \
      --username admin \
      --firstname Airflow \
      --lastname Admin \
      --role Admin \
      --email admin@example.com \
      --password admin

Run the webserver in one shell:

    airflow webserver --port 8080

Run the scheduler in another shell:

    airflow scheduler

### Important limitation

This setup is good for learning command flow but weak for real team development.

--------------------------------------------------

## Docker vs local install

Use Docker when you want:

- repeatable environments
- multi-service architecture
- easier onboarding
- a production-like mindset

Use local install when you want:

- quick command-line experimentation
- minimal setup for learning internals

### Recommendation

Make Docker your default and keep local install as a secondary learning path.

--------------------------------------------------

## Git project setup

## Why Git must be part of the setup

Airflow DAGs are code. Code must be versioned, reviewed, and deployed in a controlled way.

### Good strategy

Store all Airflow-related code in Git:

- DAGs
- requirements
- deployment configuration
- helper modules
- setup docs

### Bad strategy

Edit DAGs directly in the Airflow server filesystem.

### Why bad is bad

- no audit history
- no safe rollback
- no review process
- drift between environments

--------------------------------------------------

## Suggested Git workflow

Basic workflow:

1. create a feature branch
2. change DAGs or config
3. run local validation
4. open a pull request
5. merge after review
6. deploy to shared environment

### Good strategy

Treat DAG changes the same way you treat application code changes.

### Bad strategy

Copy files manually to servers.

### Why bad is bad

- mistakes are easy
- version drift appears quickly
- production changes become untraceable

--------------------------------------------------

## `.gitignore` recommendation

Use a `.gitignore` that excludes local and sensitive files.

Recommended entries:

    .env
    .venv/
    __pycache__/
    logs/
    .airflow/

### Good strategy

Ignore generated files and local secrets.

### Bad strategy

Commit logs, local state, or secret files.

### Why bad is bad

- noisy repository
- leaked secrets
- broken collaboration

--------------------------------------------------

## Environment variables in practice

## What environment variables are for

Environment variables are best for:

- Airflow core configuration
- container runtime configuration
- injecting secrets into local or server environments
- keeping environment-specific settings outside code

### Common categories

- Airflow settings such as executor, DB connection, Fernet key
- Python dependency installation behavior
- admin bootstrap settings
- service-specific credentials

### Good strategy

Use environment variables for environment-specific values and secrets.

### Bad strategy

Hardcode settings inside DAGs.

### Why bad is bad

- breaks portability across environments
- increases security risk
- makes deployment brittle

--------------------------------------------------

## Airflow Variables vs environment variables vs Connections vs secrets backends

These four are not the same thing.

### 1. Environment variables

Best for:

- system configuration
- secret injection into runtime
- per-environment values

Examples:

- executor type
- Fernet key
- admin bootstrap values
- external service keys injected into containers

### 2. Airflow Variables

Best for:

- small runtime configuration values
- feature flags
- business parameters that are not secrets

Examples:

- default country code
- pipeline mode flag
- non-sensitive path prefix

### 3. Airflow Connections

Best for:

- database connection information
- HTTP endpoints and credentials
- cloud service access definitions
- Databricks, Kubernetes, Postgres, and similar integrations

Examples:

- Postgres connection
- HTTP API connection
- Databricks connection

### 4. Secrets backend

Best for:

- production-grade secret storage and rotation
- retrieving connections or variables from secure secret systems

Examples:

- AWS Secrets Manager
- HashiCorp Vault
- GCP Secret Manager

### Good strategy

Use each mechanism for its intended purpose.

### Bad strategy

Store everything everywhere without a model.

### Why bad is bad

- secrets end up in the wrong place
- code becomes confusing
- credential rotation becomes painful
- environments become inconsistent

--------------------------------------------------

## How to think about Connections

Connections are the standard Airflow abstraction for external systems.

A Connection usually contains:

- host
- port
- login
- password or token
- schema
- extra JSON for provider-specific config

Use Connections for systems such as:

- Postgres
- MySQL
- Snowflake
- HTTP APIs
- Databricks
- S3-compatible systems

### Good strategy

Always reference external systems by `conn_id` in DAG code.

### Bad strategy

Write raw credentials directly inside tasks.

### Why bad is bad

- security exposure
- duplication of credentials
- harder credential rotation

--------------------------------------------------

## Example: PostgreSQL connection via environment variable

You can define a connection through an environment variable.

    AIRFLOW_CONN_POSTGRES_DWH=postgresql://analytics_user:strong_password@db.example.com:5432/warehouse

Then in DAG code or operators you use:

    postgres_conn_id="postgres_dwh"

### Why this is useful

It allows Airflow to resolve the connection without hardcoding the URI in DAG code.

--------------------------------------------------

## Example: HTTP API connection

Environment variable style:

    AIRFLOW_CONN_SALES_API=http://api_user:api_password@api.example.com:80

Then you can use `sales_api` as a `conn_id`.

### Good strategy

Store auth information in the connection and business parameters elsewhere.

### Bad strategy

Put endpoint URLs and secrets directly in every task.

### Why bad is bad

- repeated code
- hard to change environments
- credentials leak easily

--------------------------------------------------

## Example: Databricks connection

For Databricks, use a dedicated connection and provider package.

Typical setup uses:

- Databricks host
- token-based authentication

For example in Airflow UI or secret system you define a connection like:

- conn_id: `databricks_default`
- type: Databricks
- host: your workspace URL
- password or token: your token

### Good strategy

Keep Databricks authentication in a connection and pass only job-specific parameters from DAG code.

### Bad strategy

Hardcode the workspace URL and token in the DAG.

### Why bad is bad

- major security risk
- hard to rotate tokens
- difficult to promote between environments

--------------------------------------------------

## Example: Spark job triggering

Airflow usually should not run Spark compute inside the scheduler environment.

Instead, Airflow should:

- submit a Spark job
- monitor it
- react to success or failure

This can happen via:

- Kubernetes jobs
- Databricks jobs
- EMR jobs
- custom submission wrappers

### Good strategy

Airflow submits and observes Spark work.

### Bad strategy

Airflow becomes the Spark processing environment.

### Why bad is bad

- wrong separation of concerns
- weak scaling model
- fragile execution path

--------------------------------------------------

## Example: dbt integration

Airflow and dbt work well together when Airflow orchestrates dbt commands or dbt execution environments.

Typical patterns:

- Airflow triggers `dbt run`
- Airflow triggers `dbt test`
- Airflow orchestrates dbt before or after ingestion tasks

### Good strategy

Airflow schedules and coordinates dbt.

### Bad strategy

Rebuild dbt behavior manually in Python tasks.

### Why bad is bad

- duplicate logic
- lost lineage and model semantics
- unnecessary maintenance cost

--------------------------------------------------

## Variables in practice

Airflow Variables are useful for small pieces of configuration that are not secrets.

Examples:

- enabling or disabling a feature branch of a pipeline
- choosing a non-sensitive default region
- defining a date threshold for a learning environment

### Good strategy

Use Variables sparingly and only for small configuration.

### Bad strategy

Use Variables as a general-purpose storage system.

### Why bad is bad

- configuration becomes scattered
- hard to track changes in Git
- metadata DB becomes overloaded with operational config

--------------------------------------------------

## Secrets in practice

## Local development secrets approach

For local development, a practical approach is:

- `.env.example` is committed
- `.env` is local only
- sensitive values are injected through environment variables

## Production secrets approach

For production, the better model is:

- keep secrets in a secrets manager
- let Airflow fetch Connections and Variables from that secrets backend
- do not keep secrets in DAG code or plain Git-tracked files

### Good strategy

Move toward a secrets backend as environments mature.

### Bad strategy

Keep production credentials in `.env` files on random servers.

### Why bad is bad

- weak security posture
- manual rotation pain
- greater chance of accidental leaks

--------------------------------------------------

## What to change before production

A local Docker setup is a good start, but it is not the final production state.

Before production, review at least these areas:

- metadata database should be external and managed or at least backed up reliably
- LocalExecutor may need to become CeleryExecutor or KubernetesExecutor
- logs may need remote storage
- secrets should move to a secrets manager
- monitoring and alerting must be added
- deployment should become CI/CD-driven

### Good strategy

Treat the local setup as a stepping stone toward a proper platform design.

### Bad strategy

Use the exact local Compose stack as production just because it works once.

### Why bad is bad

- single points of failure remain
- scaling is limited
- security and observability are weak

--------------------------------------------------

## Minimal production-like baseline

A reasonable minimal production-like baseline usually includes:

- external PostgreSQL metadata database
- dedicated scheduler
- dedicated webserver
- worker layer or Kubernetes-based execution
- centralized logs
- Git-based deployment flow
- monitoring and alerting
- secrets management

### Good strategy

Scale each Airflow component according to its role.

### Bad strategy

Treat Airflow as one server process.

### Why bad is bad

- all failures become system failures
- no isolation between services
- poor scalability

--------------------------------------------------

## Infra guidance: component resource thinking

## Scheduler

The scheduler is typically sensitive to:

- CPU
- metadata DB latency
- DAG parsing cost
- number of task instances to evaluate

If DAG files are heavy or there are too many tasks, the scheduler becomes the first bottleneck.

## Webserver

The webserver needs:

- moderate CPU
- enough memory for UI responsiveness
- reliable access to metadata DB and logs

It is usually not the main compute bottleneck, but can become slow with a very large number of DAGs or poor database performance.

## Workers

Workers need:

- enough CPU for task logic
- enough memory for task runtime
- isolation so one bad task does not damage the entire system

Worker sizing depends on task type. Lightweight orchestration tasks need less than Python-heavy tasks.

## Metadata database

This is one of the most critical components.

It stores:

- DAG run state
- task instance state
- XCom metadata
- Variables and Connections metadata
- scheduler and service coordination data

If the metadata DB becomes slow, the whole platform slows down.

### Good strategy

Treat the metadata database as a critical dependency.

### Bad strategy

Assume the DB is just a detail.

### Why bad is bad

- scheduler lag increases
- tasks start late
- UI slows down
- system observability becomes worse

--------------------------------------------------

## Common setup mistakes

### Mistake 1: Using SQLite beyond toy learning

SQLite is fine for a tiny local experiment, but not for serious development or production-like use.

Why this is a mistake:

- weak concurrency model
- not representative of real deployments
- hides production database behavior

### Mistake 2: Hardcoding credentials in DAGs

Why this is a mistake:

- security risk
- impossible rotation strategy
- environment migration becomes messy

### Mistake 3: Treating `.env` as a production secret manager

Why this is a mistake:

- weak secret hygiene
- manual operations at scale
- poor auditability

### Mistake 4: Keeping all helper logic inside DAG files

Why this is a mistake:

- parse-time overhead
- code duplication
- poor maintainability

### Mistake 5: Running everything manually without Git

Why this is a mistake:

- no traceability
- no rollback
- deployment chaos

--------------------------------------------------

## First validation workflow after setup

After the first startup, validate in this order:

1. Docker services are healthy
2. webserver is reachable
3. scheduler is running
4. DAG appears in UI
5. DAG can be unpaused
6. DAG run starts successfully
7. each task completes successfully
8. logs are visible
9. interval values in the Python task look correct

### Good strategy

Always validate end-to-end after setup changes.

### Bad strategy

Assume the system works because containers started.

### Why bad is bad

- hidden broken configuration
- wasted debugging time later

--------------------------------------------------

## Practical recommendation for your learning path

If your goal is to grow from learning Airflow to designing reliable systems, follow this sequence:

1. run the Docker stack from this guide
2. understand the local Python install conceptually, but do not depend on it
3. keep everything in Git from the start
4. learn environment variables, Connections, Variables, and secrets as separate concepts
5. move external systems behind Connections
6. later evolve the same mental model toward CeleryExecutor or KubernetesExecutor

This sequence gives you a strong foundation without forcing you to relearn the basics later.

--------------------------------------------------

## Summary

Use Docker as your main local and development baseline.

Use local Python install only to understand basic Airflow commands and mechanics.

Keep your project in Git from day one.

Use environment variables for runtime configuration, Connections for external systems, Variables for small non-secret settings, and secrets backends for production-grade secret management.

Treat the metadata database as critical.

Keep DAG code clean and avoid hardcoding environment-specific values.

Build your Airflow setup as a platform foundation, not as a one-off script environment.

--------------------------------------------------
