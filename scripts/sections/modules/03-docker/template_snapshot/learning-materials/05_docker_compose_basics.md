# Docker Compose Basics

## Why This Topic Matters

Single-container practice is necessary, but most realistic systems include multiple services. Docker Compose lets you define that system declaratively.

## Core Concepts

- service: one runtime component in the stack
- compose file: declarative definition of a local multi-service system
- named volume: persistent data storage shared with a service definition
- environment variables: configuration passed to services
- dependency modeling: which services need others to exist

## How It Works

Compose creates a local environment in which services share a project network and can reference each other by service name.

This makes local system modeling much clearer than starting each container manually.

## Practical Example

```yaml
services:
  app:
    build: .
    environment:
      APP_ENV: dev
      DB_HOST: db
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: demo
      POSTGRES_USER: demo
      POSTGRES_PASSWORD: demo_pass
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

Run it:

```bash
docker compose up -d
docker compose ps
docker compose logs app
docker compose down
```

## Cookbook Example - App Plus Postgres

Example compose file:

```yaml
services:
  app:
    build: .
    env_file:
      - .env
    environment:
      DB_HOST: postgres
      DB_PORT: 5432
    depends_on:
      postgres:
        condition: service_healthy

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: app
      POSTGRES_PASSWORD: app_pass
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app -d app"]
      interval: 5s
      timeout: 3s
      retries: 20
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Useful commands:

```bash
docker compose up -d --build
docker compose ps
docker compose logs postgres
docker compose logs app
docker compose exec postgres psql -U app -d app -c '\dt'
docker compose down
```

## Cookbook Example - API And Worker In One Stack

```yaml
services:
  api:
    build: .
    command: python /app/src/api_app.py
    ports:
      - "8000:8000"
    env_file:
      - .env
    environment:
      POSTGRES_HOST: postgres
    depends_on:
      postgres:
        condition: service_healthy

  worker:
    build: .
    command: python /app/src/worker.py
    env_file:
      - .env
    environment:
      POSTGRES_HOST: postgres
    depends_on:
      postgres:
        condition: service_healthy

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: jobs_lab
      POSTGRES_USER: jobs_user
      POSTGRES_PASSWORD: jobs_pass
    volumes:
      - jobs_data:/var/lib/postgresql/data

volumes:
  jobs_data:
```

This pattern matters because Compose is not only for `app + db`. It is also a clean way to model different application responsibilities in one local system.

## Cookbook Example - Postgres Plus MinIO Plus App

```yaml
services:
  app:
    build: .
    env_file:
      - .env
    environment:
      POSTGRES_HOST: postgres
      MINIO_ENDPOINT: http://minio:9000
    depends_on:
      postgres:
        condition: service_healthy
      minio:
        condition: service_started

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: platform_lab
      POSTGRES_USER: platform_user
      POSTGRES_PASSWORD: platform_pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

  minio:
    image: quay.io/minio/minio:latest
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minio
      MINIO_ROOT_PASSWORD: minio123
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio_data:/data

volumes:
  postgres_data:
  minio_data:
```

This is already a useful local platform-style shape for data engineering learning.

## Readiness Note

`depends_on` helps with startup order, but it does not guarantee that a service is actually ready to accept connections. This distinction matters for databases and data services.

That is why healthchecks are often worth adding even in local learning stacks.

Without healthchecks:

- Compose may start containers in order
- but your application can still fail because the database is not ready yet

With healthchecks and `condition: service_healthy`:

- the dependency model becomes closer to actual runtime behavior

## Common Mistakes

- assuming `depends_on` means the dependency is ready
- hardcoding localhost instead of using service names
- mixing runtime config into source code instead of Compose env definitions
- forgetting volumes for stateful services
- publishing too many ports without knowing which services actually need host access
- putting secrets directly into the compose file instead of using env files for local work

## Compose Debug Cookbook

Useful commands when a stack behaves incorrectly:

```bash
docker compose ps
docker compose logs
docker compose logs app
docker compose logs postgres
docker compose exec app env | sort
docker compose exec app sh
docker compose exec postgres psql -U app -d app -c 'select 1'
```

If a service cannot connect to another service, check:

- service name
- published port versus internal port confusion
- readiness timing
- missing env vars
- missing volumes or files

## Architectural View

Compose is a good local design tool because it forces you to define:

- components
- boundaries
- configuration
- storage
- network relationships

This is system thinking in a lightweight form.

## Trade-Offs

- Compose is simple and productive for local and learning setups
- it is not the same as production orchestration
- overusing one large compose file can make stacks harder to reason about

## How It Connects To Data Engineering

Compose is commonly used to run:

- ETL app plus database
- Airflow plus Postgres
- MinIO plus processing app
- dbt support stack
- learning versions of platform services

Realistic Compose shapes for this roadmap include:

- ETL job plus Postgres
- API plus worker plus Postgres
- processing app plus Postgres plus MinIO
- Airflow plus Postgres for orchestration learning

## What To Practice Next

After this topic, practice:

- building one Compose service
- adding a database service
- attaching a volume
- debugging logs across multiple services

Optional hard mode:

- add a healthcheck to every stateful service you define
- split one stack into clearly named application services and platform services