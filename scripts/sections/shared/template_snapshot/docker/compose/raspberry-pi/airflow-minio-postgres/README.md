# Airflow MinIO Postgres Stack For Raspberry Pi

This stack is a lightweight starter environment for Raspberry Pi.

It is intended for learning, not for production use.

## Services

- PostgreSQL for Airflow metadata
- MinIO for object-storage style experiments
- Airflow webserver
- Airflow scheduler
- one Airflow init job

## Why This Stack Exists

This stack is a practical first homelab runtime for this repository because it supports:

- module 11 Airflow learning
- lightweight orchestration experiments
- local object storage practice
- future Python ETL exercises writing to MinIO

## Host Requirements

Recommended minimum:

- Raspberry Pi 4 or 5
- 4 GB RAM minimum
- Docker installed
- stable network access
- SSD preferred if possible

## Host Directories

Create these directories on Raspberry Pi before starting:

```bash
mkdir -p /srv/rs-data-platform/runtime/airflow/{dags,logs,plugins}
mkdir -p /srv/rs-data-platform/runtime/postgres/data
mkdir -p /srv/rs-data-platform/runtime/minio/data
```

## First Start

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/airflow-minio-postgres
cp .env.example .env
mkdir -p /srv/rs-data-platform/configs/shared
cp /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/configs/templates/raspberry-pi/airflow-minio-postgres.env.example /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
docker compose up -d
```

## Ports

- Airflow UI: `8088`
- MinIO API: `9000`
- MinIO Console: `9001`
- PostgreSQL: `5432`

## Runtime Secrets

This stack now expects real service secrets in a host-local file outside git:

- `/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env`

The repository keeps only templates:

- `.env.example` for non-secret path settings
- `shared/configs/templates/raspberry-pi/airflow-minio-postgres.env.example` for runtime variable shape

Change the copied host-local file before using the stack beyond first local testing.

## Useful Commands

Start:

```bash
docker compose up -d
```

Status:

```bash
docker compose ps
```

Logs:

```bash
docker compose logs airflow-init
docker compose logs airflow-webserver
docker compose logs airflow-scheduler
docker compose logs minio
docker compose logs postgres
```

Stop:

```bash
docker compose down
```

View the active non-secret compose variables:

```bash
cat .env
```

Edit the host-local runtime secret file:

```bash
nano /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

## Notes For Raspberry Pi

- keep only one learning stack running at a time if memory is tight
- prefer SSD over SD card for long-lived Docker volumes
- do not treat this as a production-grade Airflow deployment
- keep DAGs small and simple at first