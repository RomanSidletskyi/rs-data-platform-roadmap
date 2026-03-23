# Solution - Docker Compose Basics

This topic moves from one container to a declarative local system.

## Task 1 — Define A Single Service In Compose

Example:

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
```

What is what:

- `web` is the service identity
- `image` defines the runtime artifact
- `ports` defines host-to-container access

Run it:

```bash
docker compose up -d
docker compose ps
```

## Task 2 — Add Environment Variables

Example:

```yaml
services:
  app:
    image: python:3.12-slim
    command: python -c "import os; print(os.getenv('APP_ENV'))"
    env_file:
      - .env
```

Example `.env`:

```text
APP_ENV=dev
```

Runtime configuration should stay outside code when possible because it changes across environments.

If you have several values, `.env` or `env_file` is usually cleaner than putting everything inline.

## Task 3 — Add Persistent Storage

Example:

```yaml
services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: demo_pass
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

Why a named volume is a better default than a bind mount here:

- database state is clearly treated as service-managed persistent data
- the stack is less coupled to one host folder layout
- the Compose file stays cleaner for learning setups

## Task 4 — Run App And Postgres Together

Example:

```yaml
services:
  app:
    image: python:3.12-slim
    command: python -c "print('connect to db host named db')"
    environment:
      DB_HOST: db
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: demo_pass
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 20
```

Inside the app container, the database hostname is `db`, not `localhost`.

The healthcheck matters because startup order alone does not prove database readiness.

## Task 5 — Inspect Compose Logs

```bash
docker compose ps
docker compose logs
docker compose logs app
docker compose logs db
```

Logs help verify:

- whether both services started
- whether the app used the correct database host
- whether the database was actually ready
- whether inter-service behavior matches the Compose design

## Common Mistakes

- assuming service startup means readiness
- forgetting named volumes for databases
- using localhost inside containers for peer services
- publishing host ports for every service even when only one needs external access
- burying too much configuration directly in the Compose file instead of using env files

## Optional Hard Mode - Extend The Stack

Example `api + worker + postgres` shape:

```yaml
services:
  api:
    build: .
    environment:
      POSTGRES_HOST: postgres
    ports:
      - "8000:8000"

  worker:
    build: .
    environment:
      POSTGRES_HOST: postgres

  postgres:
    image: postgres:16-alpine
```

In this extended stack:

- `api` and `worker` are application services
- `postgres` is a platform service
- usually only `api` needs a host port

## Definition Of Done

This topic is complete if you can:

- write a small compose file
- configure services with env vars or `.env`
- attach persistent storage to a stateful service
- model app-to-db communication with service names
- explain a credible readiness strategy
- read logs across services and verify inter-service behavior