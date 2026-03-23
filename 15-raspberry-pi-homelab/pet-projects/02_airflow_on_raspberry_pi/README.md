# Pet Project 02 - Airflow On Raspberry Pi

## Goal

Run a lightweight Airflow setup on Raspberry Pi for orchestration practice.

## Why This Project Comes Second

This project builds on everything before it:

- SSH and remote workflow
- storage layout
- host-level service understanding
- Docker basics

## Scope

- Airflow with persistent metadata database
- DAG folder mounted from the repository
- MinIO for object storage experiments
- host-local logs and config files
- documented start, stop, and troubleshooting flow

## Expected Outcome

You can use Raspberry Pi as a persistent orchestration lab for module 11.

## Real Working Target

This project is already validated on the real Raspberry Pi host used in this repository work:

- host alias: `pi5`
- hostname: `pi5.local`
- repository path on Pi: `/srv/rs-data-platform/repo/rs-data-platform-roadmap`
- runtime root: `/srv/rs-data-platform/runtime`
- host-local shared env file: `/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env`

## What You Will Run

This project uses the compose stack from:

`/srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/airflow-minio-postgres`

Services:

- PostgreSQL for Airflow metadata
- MinIO for S3-style storage practice
- Airflow webserver
- Airflow scheduler
- Airflow init job

## Prerequisites

Before starting, the Raspberry Pi should already have:

- SSH access working
- Docker installed and working
- Docker Compose installed and working
- repository cloned to `/srv/rs-data-platform/repo/rs-data-platform-roadmap`

Quick checks:

```bash
ssh pi5
docker --version
docker compose version
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap
git status
```

## Directory Preparation

Create the runtime directories once:

```bash
mkdir -p /srv/rs-data-platform/runtime/airflow/{dags,logs,plugins}
mkdir -p /srv/rs-data-platform/runtime/postgres/data
mkdir -p /srv/rs-data-platform/runtime/minio/data
mkdir -p /srv/rs-data-platform/configs/shared
```

## First Successful Runbook

### 1. Open the stack directory

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/airflow-minio-postgres
```

### 2. Create compose-level `.env`

If it does not exist yet:

```bash
cp .env.example .env
```

Expected contents:

```dotenv
AIRFLOW_UID=50000
RPI_RUNTIME_ROOT=/srv/rs-data-platform/runtime
STACK_ENV_FILE=/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

### 3. Create the host-local runtime env file

```bash
cp /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/configs/templates/raspberry-pi/airflow-minio-postgres.env.example \
	/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

Then edit it:

```bash
nano /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

Use real values, one variable per line:

```dotenv
POSTGRES_DB=airflow
POSTGRES_USER=airflow
POSTGRES_PASSWORD=change_me_to_a_strong_password

MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=change_me_to_a_long_password

AIRFLOW_USER=admin
AIRFLOW_PASSWORD=change_me_to_a_strong_password
AIRFLOW__CORE__FERNET_KEY=replace_with_real_fernet_key
AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:change_me_to_a_strong_password@postgres:5432/airflow
```

Important rules:

- every variable must be on its own line
- do not write `POSTGRES_PASSWORD=POSTGRES_PASSWORD=...`
- MinIO password must be at least 8 characters
- the password inside `AIRFLOW__DATABASE__SQL_ALCHEMY_CONN` must match `POSTGRES_PASSWORD`

### 4. Generate a real Fernet key

On Raspberry Pi Bookworm, `pip install --user` may fail because the Python environment is externally managed. The reliable path is to use the system package first:

```bash
sudo apt update
sudo apt install -y python3-cryptography
python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```

Copy the generated value into:

```dotenv
AIRFLOW__CORE__FERNET_KEY=...
```

### 5. Validate the merged compose config

```bash
docker compose config
```

Do not continue until this command renders a valid config without broken env interpolation.

### 6. Start the stack

```bash
docker compose up -d
```

### 7. Check status

```bash
docker compose ps
```

Healthy target state:

- `postgres` is `healthy`
- `airflow-webserver` is `Up`
- `airflow-scheduler` is `Up`
- `minio` is `Up`

## Access URLs

From your Mac or another machine on the same network:

- Airflow UI: `http://pi5.local:8088`
- Airflow UI by IP: `http://192.168.1.110:8088`
- MinIO Console: `http://pi5.local:9001`
- MinIO Console by IP: `http://192.168.1.110:9001`
- MinIO API health: `http://pi5.local:9000/minio/health/live`

## Verification Commands

Check Airflow UI response:

```bash
curl http://192.168.1.110:8088
```

Expected result: HTML or redirect response from Airflow.

Check MinIO API health:

```bash
curl http://localhost:9000/minio/health/live
```

Expected result:

```text
OK
```

Check MinIO Console:

```bash
curl http://localhost:9001
```

Expected result: HTML page for MinIO Console.

## Useful Operations

Start stack:

```bash
docker compose up -d
```

Restart one service:

```bash
docker compose up -d minio
docker compose up -d airflow-webserver
```

Show status:

```bash
docker compose ps
```

Show logs:

```bash
docker compose logs postgres
docker compose logs minio
docker compose logs airflow-init
docker compose logs airflow-webserver
docker compose logs airflow-scheduler
```

Stop stack but keep data:

```bash
docker compose down
```

Stop stack and remove volumes only if you intentionally want a reset:

```bash
docker compose down -v
```

## Real Issues We Hit And How To Fix Them

### Problem: `docker compose config` says variables are not set

Cause:

- `.env` was missing in the compose directory

Fix:

```bash
cp .env.example .env
docker compose config
```

### Problem: env values get merged into one broken line

Example symptom:

```text
AIRFLOW__CORE__FERNET_KEYMINIO_ROOT_USER
```

Cause:

- malformed host-local env file
- missing newline between variables

Fix:

- open `/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env`
- ensure one variable per line
- rerun `docker compose config`

### Problem: `pip install --user cryptography` fails on Raspberry Pi OS

Cause:

- Bookworm uses an externally managed Python environment

Fix:

```bash
sudo apt install -y python3-cryptography
python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```

### Problem: MinIO does not start and logs mention invalid credentials

Cause:

- `MINIO_ROOT_PASSWORD` is too short

Fix:

- set a password with at least 8 characters
- restart MinIO

```bash
nano /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
docker compose up -d minio
docker compose logs minio
```

### Problem: Airflow UI opens but login fails

Possible causes:

- wrong `AIRFLOW_USER` or `AIRFLOW_PASSWORD`
- you changed env values after initial bootstrap and need to recreate the init flow

Pragmatic fix path:

- verify values in `/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env`
- inspect `docker compose logs airflow-init`
- if necessary, reset the stack intentionally and bootstrap again

## What Makes This Project Useful

After this stack is running, you can use it as the base runtime for:

- Airflow DAG practice from module 11
- Python ETL jobs that write files or objects to MinIO
- later experiments with dbt, Spark outputs, or ingestion workflows

## Related Practical Guide

Use this guide when you want to work with MinIO directly:

- `minio-console-and-python-quickstart.md`

Use this example when you want Airflow itself to upload a file into MinIO:

- `examples/airflow_dags/minio_roundtrip_demo_dag.py`

## First Airflow DAG With MinIO

This project now includes a minimal DAG that:

- creates a local text file inside the Airflow container
- uploads it to MinIO bucket `raw-zone`
- downloads the same object again
- verifies that the content matches

Repository example path:

`15-raspberry-pi-homelab/pet-projects/02_airflow_on_raspberry_pi/examples/airflow_dags/minio_roundtrip_demo_dag.py`

### How To Enable It On Raspberry Pi

The stack reads DAG files from:

`/srv/rs-data-platform/runtime/airflow/dags`

If direct copy fails with `Permission denied`, fix ownership first and then copy the DAG:

```bash
sudo chown -R rsidletskyi:rsidletskyi /srv/rs-data-platform/runtime/airflow
cp \
	/srv/rs-data-platform/repo/rs-data-platform-roadmap/15-raspberry-pi-homelab/pet-projects/02_airflow_on_raspberry_pi/examples/airflow_dags/minio_roundtrip_demo_dag.py \
	/srv/rs-data-platform/runtime/airflow/dags/
ls -lah /srv/rs-data-platform/runtime/airflow/dags
```

If you prefer not to change ownership, use a one-time privileged copy instead:

```bash
sudo install -m 644 \
	/srv/rs-data-platform/repo/rs-data-platform-roadmap/15-raspberry-pi-homelab/pet-projects/02_airflow_on_raspberry_pi/examples/airflow_dags/minio_roundtrip_demo_dag.py \
	/srv/rs-data-platform/runtime/airflow/dags/minio_roundtrip_demo_dag.py
```

### Important Dependency Note

The Airflow containers need the Python package `minio`.

This repository now adds it through compose via `_PIP_ADDITIONAL_REQUIREMENTS`.

After pulling these changes on Raspberry Pi, recreate the Airflow services:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/airflow-minio-postgres
docker compose up -d --force-recreate airflow-init airflow-webserver airflow-scheduler
```

### How To Run The DAG

1. Open Airflow UI at `http://pi5.local:8088`.
2. Find DAG `minio_roundtrip_demo`.
3. Unpause it.
4. Trigger it manually.
5. Open MinIO Console and verify that an object appears under bucket `raw-zone`.

### Expected Object Layout

The DAG writes objects like:

- `airflow/demo/<run_id>/hello.txt`

### If The DAG Does Not Appear

Check:

```bash
ls -lah /srv/rs-data-platform/runtime/airflow/dags
docker compose logs airflow-webserver
docker compose logs airflow-scheduler
docker compose restart airflow-webserver airflow-scheduler
```

### If The DAG Fails On MinIO Access

Check the credentials in:

```bash
nano /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

The DAG reads:

- `MINIO_ROOT_USER`
- `MINIO_ROOT_PASSWORD`

It connects to MinIO at `http://minio:9000` from inside the Airflow container.

## Suggested Next Step

After the stack is healthy, the next practical move is to add one tiny DAG and verify that:

- Airflow can see the DAG
- task logs persist on disk
- you can move a test file into MinIO