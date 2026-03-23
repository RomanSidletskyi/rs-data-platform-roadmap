# Debugging And Best Practices

## Why This Topic Matters

Many Docker problems are not caused by Docker itself. They come from unclear assumptions about ports, files, configuration, commands, readiness, or persistence. Debugging skill is what turns command knowledge into engineering capability.

## Core Concepts

- logs show what the main process is doing
- exec lets you inspect a running container
- inspect shows container metadata and runtime configuration
- cleanup matters because stale resources hide the real state of the system

## Practical Commands

Logs:

```bash
docker logs my-container
docker logs -f my-container
```

Inspect runtime details:

```bash
docker inspect my-container
```

Open a shell in a running container:

```bash
docker exec -it my-container sh
```

Compose logs:

```bash
docker compose ps
docker compose logs
docker compose logs app
```

Cleanup:

```bash
docker stop my-container
docker rm my-container
docker compose down
```

## Cookbook Example - Crashing Batch Container

Scenario:

- you built an image successfully
- the container exits immediately

Investigation flow:

```bash
docker ps -a
docker logs batch-job
docker inspect batch-job
docker run --rm --entrypoint sh image-name
```

Questions to ask:

- did the main command fail
- does the expected file exist in the image
- does the app require env vars that were never provided
- was the wrong build context used

Typical root causes:

- wrong `CMD`
- missing file copied during build
- config path expected at runtime but not mounted

## Cookbook Example - App Cannot Reach Postgres In Compose

Scenario:

- `app` container is up
- `postgres` container is up
- app still cannot connect to the database

Investigation flow:

```bash
docker compose ps
docker compose logs app
docker compose logs postgres
docker compose exec app env | sort
docker compose exec app sh
docker compose exec postgres psql -U app -d app -c 'select 1'
```

Check these assumptions:

- is the app using `postgres` as host instead of `localhost`
- is the database actually ready or just started
- are credentials aligned between the app and Postgres service
- does the app expect a table, schema, or file that does not exist yet

## Cookbook Example - Port Mapping Confusion

Scenario:

- the service is healthy inside the container
- the host still cannot reach it

Investigation flow:

```bash
docker ps
docker inspect web-app
curl http://localhost:8080
docker exec -it web-app sh
```

Questions to ask:

- what port is the app actually listening on inside the container
- what host port is published
- is this a host access issue or an internal service-to-service issue

Common example:

- app listens on `8000`
- compose or run command maps `8080:80`

Correct fix:

- map `8080:8000`

## Common Failure Patterns

- the process exits immediately because the command is wrong
- the service starts, but the published port is wrong
- the container runs, but the app cannot find expected files
- env vars are missing or incorrect
- one service starts before its dependency is ready
- the build succeeded, but the runtime command points to the wrong file
- the stack is using localhost where a service name is required

## Common Mistakes

- jumping straight to rebuilds without reading logs
- assuming a running container means a healthy service
- debugging from the host only and never inspecting inside the container
- mixing old containers and new containers during troubleshooting
- checking only published ports and forgetting internal service connectivity
- treating every issue as a Docker problem instead of identifying config, storage, or app-level causes

## Best Practices

- give containers and services clear names
- pin important image versions
- keep `.dockerignore` clean
- keep runtime configuration outside the image when possible
- use volumes intentionally, especially for stateful services
- remove test containers when you finish with them
- classify failures before trying fixes: config, readiness, storage, networking, or app logic
- prefer explicit service names and explicit healthchecks in multi-service stacks

## Debug Workflow Cookbook

When a stack fails, use this order:

1. confirm what is running
2. read logs before changing anything
3. inspect env vars and runtime files inside the container
4. separate host-access problems from service-to-service problems
5. only then rebuild or rewrite configuration

Practical command flow:

```bash
docker compose ps
docker compose logs
docker compose logs app
docker compose exec app env | sort
docker compose exec app sh
docker compose exec db psql -U app -d app -c 'select 1'
```

This sequence is more valuable than guessing because it narrows the problem space quickly.

## Architectural View

Debugging is not only a support activity. It is part of system design quality. If a stack is hard to inspect locally, it usually means its boundaries or configuration model are unclear.

Operator-style thinking improves architecture because it forces you to ask:

- where are logs emitted
- where does state live
- how does a service prove readiness
- which settings are runtime-specific
- which ports should be internal only
- which failures should be detectable quickly from the outside

## Trade-Offs

- convenience shortcuts speed up learning early
- but weak naming, hidden config, and poor cleanup make later debugging harder

## How It Connects To Data Engineering

When local Airflow, Postgres, MinIO, or Python jobs fail, the first useful response is almost always:

- inspect logs
- inspect environment
- inspect mounts
- inspect service connectivity

Cookbook-level patterns in this repo include:

- ETL app cannot reach Postgres because `DB_HOST=localhost`
- MinIO works in browser but the app uses the wrong endpoint internally
- Airflow or another service starts before its dependency is actually ready
- a local batch image expects files that were never mounted

That discipline transfers directly into larger platform work.

## What To Practice Next

After this topic, practice:

- diagnosing a crashed container
- checking env vars inside the runtime
- fixing a port mapping issue
- tracing a multi-service failure in Compose

Optional hard mode:

- write a troubleshooting checklist for `etl + postgres`
- write another one for `app + postgres + minio`
- compare which failures are configuration problems and which are architecture problems