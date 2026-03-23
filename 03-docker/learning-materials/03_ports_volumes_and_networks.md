# Ports, Volumes, And Networks

## Why This Topic Matters

Containers are easy to start, but real systems need communication and data persistence. This is where ports, storage, and networking become central.

## Core Concepts

- published port: exposes a container service to the host machine
- bind mount: maps a host path into a container
- named volume: Docker-managed persistent storage
- bridge network: default isolated Docker network model for local communication

## How It Works

Ports solve host-to-container access. Volumes solve persistence. Networks solve service-to-service communication.

Without understanding these three boundaries, it is difficult to reason about where data lives and how services talk to each other.

## Practical Commands

Publish a web server port:

```bash
docker run -d --name web-demo -p 8080:80 nginx:alpine
curl http://localhost:8080
```

Use a bind mount:

```bash
mkdir -p demo-site
printf '%s\n' 'hello from bind mount' > demo-site/index.html
docker run -d --name mounted-web -p 8081:80 -v "$PWD/demo-site:/usr/share/nginx/html:ro" nginx:alpine
curl http://localhost:8081
```

Use a named volume:

```bash
docker volume create pgdata-demo
docker run -d --name postgres-demo \
  -e POSTGRES_PASSWORD=localpass \
  -v pgdata-demo:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16-alpine
```

## Compose Networking Example

```yaml
services:
  app:
    image: python:3.12-slim
    command: sleep infinity
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: localpass
```

In Compose, `app` can reach `db` using the hostname `db`.

## Common Mistakes

- confusing container port with published host port
- expecting local files to exist inside a container without a mount
- using bind mounts when a named volume is a better persistence choice
- assuming `localhost` inside one container points to another container

## Architectural View

These three features define system boundaries:

- ports define external access
- volumes define data ownership and durability
- networks define communication topology

Architecturally, this is where container usage becomes system modeling instead of isolated command execution.

## Trade-Offs

- bind mounts are flexible but host-dependent
- named volumes are cleaner for service data but less transparent at first glance
- broad port exposure is convenient but may hide poor service boundaries

## How It Connects To Data Engineering

Most local data stacks require all three:

- Postgres needs persistent storage
- MinIO needs data mounts or volumes
- API and worker services need network communication
- local UIs often need published ports

## What To Practice Next

After this topic, practice:

- publishing ports for a service
- mounting files into a container
- using named volumes for databases
- making one service connect to another by service name