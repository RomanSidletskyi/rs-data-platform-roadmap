# Docker For Data Engineering

## Why This Topic Matters

Docker becomes especially valuable in data engineering because many workflows depend on supporting services. Learning is slower when every service has to be installed manually on the host.

## Core Concepts

- local platform service: a service that supports development or testing, such as Postgres or MinIO
- application container: your own ETL, API, or validation code running in a container
- reproducible sandbox: a local environment that can be rebuilt consistently

## Common Local Patterns

Docker is often used to run:

- Postgres for SQL practice and ETL targets
- MinIO for object storage simulation
- Redis for caching or queue experiments
- Airflow for orchestration practice
- small Python jobs with mounted data and config

## Practical Compose Example

```yaml
services:
  etl:
    build: .
    environment:
      TARGET_DB_HOST: postgres
      STORAGE_ENDPOINT: http://minio:9000
    depends_on:
      - postgres
      - minio

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: app
      POSTGRES_PASSWORD: app_pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

  minio:
    image: quay.io/minio/minio:latest
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minio
      MINIO_ROOT_PASSWORD: minio123
    volumes:
      - minio_data:/data
    ports:
      - "9000:9000"
      - "9001:9001"

volumes:
  postgres_data:
  minio_data:
```

## Practical Python Pattern

```python
import os

db_host = os.getenv("TARGET_DB_HOST", "localhost")
storage_endpoint = os.getenv("STORAGE_ENDPOINT", "http://localhost:9000")

print(f"db_host={db_host}")
print(f"storage_endpoint={storage_endpoint}")
```

This keeps the application portable across local host execution and container-based execution.

## Common Mistakes

- containerizing everything without thinking about purpose
- baking environment-specific values directly into images
- treating local development stacks as if they were already production architecture
- ignoring persistence for local databases and object stores

## Architectural View

Docker helps you create a local replica of selected platform behavior, not a full production platform. That distinction matters.

Architecturally, the goal is to model boundaries clearly:

- application code
- supporting services
- configuration
- persistent state
- service communication

## Trade-Offs

- local stacks improve speed and understanding
- they can still diverge from cloud-managed systems
- too many services in one local stack can increase noise and reduce learning focus

## What Should Usually Be Containerized

- small applications
- jobs
- APIs
- local support services used during learning or testing

## What Should Be Considered Carefully

- secrets management
- very heavy stacks that reduce iteration speed
- pretending local Compose equals production operations

## What To Practice Next

After this topic, practice:

- starting a local database with Compose
- attaching a small Python app to that database
- running MinIO locally
- modeling a mini ETL workflow across services