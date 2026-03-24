# Raspberry Pi Environment

This environment describes how to use a Raspberry Pi as a remote execution and storage node for this repository.

The Raspberry Pi is not the source of truth for the repository.

The source of truth should remain:

- local git clone on the main machine
- remote git repository

The Raspberry Pi should be used for:

- running Docker workloads that cannot run locally
- keeping local lab files and mounted volumes
- hosting lightweight services for learning projects
- storing generated datasets, logs, and runtime state

--------------------------------------------------

## Recommended role in this repository

Use the Raspberry Pi as a small homelab runtime for:

- Airflow
- PostgreSQL
- MinIO
- Kafka only if the workload is small and ARM-compatible
- lightweight Python services
- dbt only if the adapter and warehouse access are lightweight enough

Avoid using it for heavy local Spark workloads unless they are intentionally small.

--------------------------------------------------

## How it fits into the repository structure

Keep this split:

repository content:
- code
- documentation
- templates
- sample datasets
- compose definitions
- bootstrap scripts

Raspberry Pi runtime content:
- Docker volumes
- generated files
- logs
- runtime configs with secrets
- persistent datasets too large for git

Repository mapping:

- `shared/environments/raspberry-pi/`:
  documentation for the Raspberry Pi host
- `shared/docker/compose/`:
  reusable compose files that can be started on the Raspberry Pi
- `shared/configs/templates/`:
  example config templates copied to the Raspberry Pi
- module folders:
  module-specific code that is deployed or mounted into containers

Related documentation for secret handling:

- `shared/environments/secrets-management.md`

--------------------------------------------------

## Recommended directory layout on the Raspberry Pi

Use a stable base path such as:

    /srv/rs-data-platform/

Suggested layout:

    /srv/rs-data-platform/
    ├── repo/
    │   └── rs-data-platform-roadmap/
    ├── runtime/
    │   ├── airflow/
    │   ├── postgres/
    │   ├── minio/
    │   ├── kafka/
    │   └── shared/
    ├── data/
    │   ├── raw/
    │   ├── bronze/
    │   ├── silver/
    │   ├── gold/
    │   └── generated/
    ├── logs/
    ├── backups/
    └── configs/

Where:

- `repo/` contains a git clone of this repository
- `runtime/` contains mounted Docker volumes and service state
- `data/` contains learning datasets and pipeline outputs
- `logs/` contains service and pipeline logs
- `configs/` contains host-local config files and `.env` files not committed to git

--------------------------------------------------

## Recommended workflow

Preferred workflow:

1. edit code locally
2. commit and push to git
3. pull changes on the Raspberry Pi
4. start or restart containers on the Raspberry Pi
5. inspect logs and outputs on the Raspberry Pi

Good alternatives:

- use `rsync` from the laptop to the Raspberry Pi for fast iteration
- use VS Code Remote SSH to work directly on the Raspberry Pi when needed

Do not make the Raspberry Pi your only copy of code or data.

--------------------------------------------------

## What should stay out of git

Do not commit:

- container volumes
- `.env` files with secrets
- generated warehouse or lake files
- large raw datasets
- Airflow metadata database files
- logs
- local runtime overrides

Commit only:

- compose files
- bootstrap scripts
- sample config templates
- documentation
- small demo datasets if needed

--------------------------------------------------

## Practical implementation path

### Stage 1 - Raspberry Pi as remote Docker host

Goal:

- run one or two local services remotely

Suggested first services:

- PostgreSQL
- MinIO
- Airflow

This is enough for:

- Python ETL practice
- Airflow orchestration tasks
- dbt structure work with remote warehouse concepts

### Stage 2 - Persistent shared lab storage

Goal:

- keep reusable datasets and generated outputs on the Raspberry Pi

Use for:

- raw sample files
- parquet outputs
- logs
- checkpoint files for small streaming exercises

### Stage 3 - Compose stacks per learning track

Examples:

- Airflow + Postgres
- Kafka + Redpanda compatible local stack if ARM images work better
- MinIO + Python ingestion service

Store reusable stack definitions in:

- `shared/docker/compose/`

--------------------------------------------------

## Constraints to account for

Raspberry Pi constraints:

- ARM architecture, so Docker images must support `linux/arm64`
- limited memory compared with a laptop or server
- SD cards are weak for heavy write workloads, prefer SSD if possible
- Spark, Kafka, and multi-service stacks may be slow if oversized

Because of that:

- prefer lightweight services first
- keep datasets small
- run one learning stack at a time
- avoid trying to simulate production scale locally

--------------------------------------------------

## Best fit with current modules

Strong fit:

- `01-python`
- `03-docker`
- `04-github-actions` for deployment automation ideas
- `11-airflow`
- `12-dbt` for project structure and SQL modeling workflow

Conditional fit:

- `05-confluent-kafka`
- `06-spark-pyspark`
- `13-flink`

These are possible, but should be kept intentionally small on Raspberry Pi hardware.

--------------------------------------------------

## Suggested next repository additions

If Raspberry Pi becomes part of the regular workflow, add:

- `shared/docker/compose/raspberry-pi/`
- `shared/configs/templates/raspberry-pi/`
- `shared/scripts/setup/raspberry-pi/`
- one doc in `docs/architecture/` describing laptop + git + Raspberry Pi workflow

This keeps the runtime reusable across modules instead of tying it to one project.

Current starter stack added:

- `shared/docker/compose/raspberry-pi/airflow-minio-postgres/`

This stack is intended as a lightweight first runtime for:

- Airflow practice
- local object storage experiments with MinIO
- PostgreSQL-backed orchestration metadata