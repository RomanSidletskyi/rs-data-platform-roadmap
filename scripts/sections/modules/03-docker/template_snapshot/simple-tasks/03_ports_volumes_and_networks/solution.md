# Solution - Ports, Volumes, And Networks

This topic explains how services become reachable and where their data lives.

## Task 1 — Publish A Container Port

```bash
docker run -d --name web-ports -p 8080:80 nginx:alpine
curl http://localhost:8080
```

## Task 2 — Mount A Local Folder Into A Container

```bash
mkdir -p demo-site
printf '%s\n' 'docker mount demo' > demo-site/index.html
docker run -d --name mounted-web -p 8081:80 -v "$PWD/demo-site:/usr/share/nginx/html:ro" nginx:alpine
curl http://localhost:8081
```

This is a bind mount. The host folder contents appear inside the container.

## Task 3 — Use A Named Volume

```bash
docker volume create pgdata-demo
docker run -d --name pg-demo \
  -e POSTGRES_PASSWORD=localpass \
  -v pgdata-demo:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16-alpine
docker volume ls
```

Databases usually need persistent storage because the data should survive container replacement.

## Task 4 — Connect Two Containers

Compose example:

```yaml
services:
  app:
    image: python:3.12-slim
    command: python -c "print('app started')"
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: localpass
```

In this setup, `app` reaches `db` by using the hostname `db`.

## Task 5 — Explain Bind Mount Vs Volume

- bind mount: maps a host path directly into the container
- named volume: Docker-managed storage for persistent service data

Good use cases:

- bind mount for local source files or static content
- named volume for databases or persistent service state

## Common Mistakes

- mixing up host port and container port
- using localhost across containers
- storing database state in ephemeral container layers

## Definition Of Done

This topic is complete if you can:

- publish a service port successfully
- mount local files into a container
- run a database with a named volume
- explain how two services communicate in Compose
- explain bind mount vs volume clearly