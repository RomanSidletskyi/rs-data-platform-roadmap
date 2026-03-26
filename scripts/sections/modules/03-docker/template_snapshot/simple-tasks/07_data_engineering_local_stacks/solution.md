# Solution - Data Engineering Local Stacks

This topic connects Docker fundamentals to realistic data engineering workflows.

The most useful mental model in this topic is the boundary between application services and platform services:

- application services contain your ingestion, transformation, API, or validation logic
- platform services provide capabilities your code depends on, such as Postgres or MinIO

That distinction keeps the stack understandable and makes later architecture discussions much easier.

## Task 1 — Run Postgres In Compose

```yaml
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: app
      POSTGRES_PASSWORD: app_pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
```

## Task 2 — Run MinIO In Compose

```yaml
services:
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
  minio_data:
```

## Task 3 — Connect A Python App To A Service

Python example:

```python
import os

db_host = os.getenv("DB_HOST", "localhost")
print(f"db_host={db_host}")
```

Compose example:

```yaml
services:
  app:
    build: .
    environment:
      DB_HOST: postgres
    depends_on:
      - postgres

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: app_pass
```

## Task 4 — Build A Small ETL Runtime Stack

A reasonable local stack could include:

- `etl-app` for transformation logic
- `postgres` for structured storage
- `minio` for object storage simulation

Responsibilities:

- `etl-app` is the application service
- `postgres` and `minio` are platform services
- the application service reads config, executes logic, and coordinates writes
- Postgres stores tabular results, metadata, or workflow state
- MinIO stores files, exports, raw inputs, or object-style artifacts

Architecturally, this is useful because it models a small but credible local system shape:

- one service owns processing logic
- supporting services own state and storage concerns
- Compose documents how those pieces communicate and persist data

If you want a deeper explanation of those boundaries, review:

- [../../learning-materials/05_docker_compose_basics.md](../../learning-materials/05_docker_compose_basics.md)
- [../../learning-materials/06_docker_for_data_engineering.md](../../learning-materials/06_docker_for_data_engineering.md)

## Task 5 — Explain Docker In A Data Platform Workflow

One strong answer:

Docker helps package application services, isolate dependencies, and run platform services consistently in local environments. It is useful for local databases, ETL jobs, object storage, and small multi-service learning stacks because it gives you repeatable runtime behavior and clearer service boundaries.

Docker alone does not solve orchestration, production operations, secrets management, or long-term platform design by itself. In other words, Docker is a strong local packaging and runtime tool, but it is not the whole platform architecture.

## Common Mistakes

- hardcoding localhost in app config inside containers
- treating local Compose as production-ready architecture
- forgetting persistence for stateful services
- mixing application-service responsibilities with platform-service responsibilities

## Definition Of Done

This topic is complete if you can:

- run local Postgres and MinIO in Compose
- connect an app to a service by service name
- describe a small ETL runtime stack clearly
- explain Docker's role and limits in a data platform
- distinguish application services from platform services in a local stack