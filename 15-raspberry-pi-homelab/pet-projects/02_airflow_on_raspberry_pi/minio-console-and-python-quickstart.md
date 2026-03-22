# MinIO Console And Python Quickstart

## Goal

Use the MinIO service from this Raspberry Pi stack in four practical ways:

- open the MinIO Console
- create the first bucket
- upload a file from Python
- download a file from Python

## What MinIO Is In This Project

In this stack, MinIO is a local S3-compatible object storage service.

You use it to store files such as:

- raw JSON extracts
- CSV files
- Parquet datasets
- logs or exported artifacts

This makes the Raspberry Pi lab closer to a real cloud-style data platform workflow.

## Service Endpoints

For this project, the useful endpoints are:

- MinIO API: `http://pi5.local:9000`
- MinIO Console: `http://pi5.local:9001`
- MinIO API by IP: `http://192.168.1.110:9000`
- MinIO Console by IP: `http://192.168.1.110:9001`

If you are running code inside another container in the same compose stack, the endpoint is usually:

- `http://minio:9000`

## Credentials

The credentials are taken from the host-local runtime file on Raspberry Pi:

```bash
nano /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

The variables you need are:

```dotenv
MINIO_ROOT_USER=...
MINIO_ROOT_PASSWORD=...
```

Do not store real secrets in repository files.

## 1. Open MinIO Console

### From your Mac browser

Open:

- `http://pi5.local:9001`

If hostname resolution does not work, use:

- `http://192.168.1.110:9001`

### Login

Use:

- username: value from `MINIO_ROOT_USER`
- password: value from `MINIO_ROOT_PASSWORD`

### Quick health check from terminal

From Raspberry Pi:

```bash
curl http://localhost:9000/minio/health/live
curl http://localhost:9001
```

Expected result:

- the health endpoint returns `OK`
- the console endpoint returns HTML

## 2. Create The First Bucket

### Recommended bucket name

For a first test, use something simple and meaningful, for example:

- `raw-zone`

Other good practice examples:

- `bronze`
- `airflow-artifacts`
- `demo-datasets`

### In MinIO Console

1. Open the Console.
2. Log in.
3. Open `Buckets`.
4. Click `Create Bucket`.
5. Enter `raw-zone`.
6. Confirm creation.

### Naming advice

- use lowercase letters
- use hyphens instead of spaces
- avoid overly generic names like `test`

## 3. Upload A File From Python

## Approach

Use the official Python MinIO client.

This is the simplest practical path for local ETL exercises.

There is also a ready-to-use script in this project:

- `examples/upload_to_minio.py`
- `examples/download_from_minio.py`

## Prepare A Small Working Folder

On Raspberry Pi:

```bash
mkdir -p /srv/rs-data-platform/runtime/minio-python-demo
cd /srv/rs-data-platform/runtime/minio-python-demo
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install minio
```

Create a sample file:

```bash
printf 'hello from raspberry pi minio demo\n' > demo.txt
```

## Fastest Path: Use The Ready Script From This Repository

If the repository is already cloned on Raspberry Pi, go to:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/15-raspberry-pi-homelab/pet-projects/02_airflow_on_raspberry_pi/examples
```

Install the client in your virtual environment if needed:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install minio
```

Export the credentials for the current shell:

```bash
export MINIO_ENDPOINT=pi5.local:9000
export MINIO_ACCESS_KEY='your_minio_root_user'
export MINIO_SECRET_KEY='your_minio_root_password'
```

Create a sample file in the same folder:

```bash
printf 'hello from raspberry pi minio demo\n' > demo.txt
```

Run the script:

```bash
python upload_to_minio.py --file demo.txt --bucket raw-zone --object demo/demo.txt
```

Expected result:

```text
Uploaded demo.txt to raw-zone/demo/demo.txt
```

## 4. Download A File From Python

Use the ready script from this repository:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/15-raspberry-pi-homelab/pet-projects/02_airflow_on_raspberry_pi/examples
source .venv/bin/activate
```

Run the download:

```bash
python download_from_minio.py --bucket raw-zone --object demo/demo.txt --file downloaded-demo.txt
```

Expected result:

```text
Downloaded raw-zone/demo/demo.txt to downloaded-demo.txt
```

Check the file:

```bash
cat downloaded-demo.txt
```

Expected content:

```text
hello from raspberry pi minio demo
```

## Example Python Script

Create `upload_to_minio.py`:

```python
from minio import Minio


client = Minio(
    "pi5.local:9000",
    access_key="YOUR_MINIO_ROOT_USER",
    secret_key="YOUR_MINIO_ROOT_PASSWORD",
    secure=False,
)

bucket_name = "raw-zone"
object_name = "demo/demo.txt"
file_path = "demo.txt"

if not client.bucket_exists(bucket_name):
    client.make_bucket(bucket_name)

client.fput_object(bucket_name, object_name, file_path)

print(f"Uploaded {file_path} to {bucket_name}/{object_name}")
```

Run it:

```bash
python upload_to_minio.py
```

Expected result:

```text
Uploaded demo.txt to raw-zone/demo/demo.txt
```

Then refresh the MinIO Console and check that the object exists.

## Better Version: Read Credentials From Environment Variables

This is safer than hardcoding credentials in the script.

Export variables in the current shell:

```bash
export MINIO_ENDPOINT=pi5.local:9000
export MINIO_ACCESS_KEY='your_minio_root_user'
export MINIO_SECRET_KEY='your_minio_root_password'
```

The ready script in this repository follows this approach.

If you want the minimal inline version, use this script:

```python
import os

from minio import Minio


client = Minio(
    os.environ["MINIO_ENDPOINT"],
    access_key=os.environ["MINIO_ACCESS_KEY"],
    secret_key=os.environ["MINIO_SECRET_KEY"],
    secure=False,
)

bucket_name = "raw-zone"
object_name = "demo/demo.txt"
file_path = "demo.txt"

if not client.bucket_exists(bucket_name):
    client.make_bucket(bucket_name)

client.fput_object(bucket_name, object_name, file_path)

print(f"Uploaded {file_path} to {bucket_name}/{object_name}")
```

## Recommended Object Layout

Even in a small homelab, start with a predictable object key structure.

Examples:

- `raw/api/orders/2026-03-22/orders.json`
- `raw/csv/customers/2026-03-22/customers.csv`
- `processed/orders/orders.parquet`
- `artifacts/airflow/run_001/output.json`

This helps later when you connect Airflow tasks or ETL jobs.

## Minimal Test Flow

Use this exact sequence the first time:

1. Open MinIO Console at `http://pi5.local:9001`.
2. Log in with `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD`.
3. Create bucket `raw-zone`.
4. Export `MINIO_ENDPOINT`, `MINIO_ACCESS_KEY`, and `MINIO_SECRET_KEY`.
5. Create local file `demo.txt`.
6. Run `examples/upload_to_minio.py`.
7. Refresh Console and verify `demo/demo.txt` exists.
8. Run `examples/download_from_minio.py`.
9. Check that `downloaded-demo.txt` contains the same text.

## Common Problems

### Console does not open

Check the service:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/airflow-minio-postgres
docker compose ps
docker compose logs minio
```

### Health endpoint works but browser still fails

Possible causes:

- wrong hostname resolution on your Mac
- local network issue
- service is up only on Pi but not reachable from another machine

Try:

- `http://192.168.1.110:9001`

### Login fails

Check values in:

```bash
nano /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

Then restart MinIO if you changed credentials:

```bash
docker compose up -d minio
```

### Python script fails with connection error

Check:

- endpoint is correct
- port `9000` is used for API, not `9001`
- `secure=False` is set for local HTTP usage

### Python script fails with access denied

Check:

- access key and secret key are correct
- you are using the same values as MinIO runtime env

### Download script fails because the object does not exist

Check:

- bucket name is correct
- object key matches exactly, for example `demo/demo.txt`
- the upload step really completed successfully

## How This Fits Into Airflow

Once this works, the next useful step is to let an Airflow DAG:

- create or fetch a local file
- upload it to MinIO
- log the uploaded object key

That gives you a full first orchestration scenario instead of only a UI setup.