# Solution - Debugging And Inspection

This topic builds debugging discipline instead of guesswork.

## Task 1 — Diagnose A Crashing Container

Useful commands:

```bash
docker ps -a
docker logs failing-container
```

If the main process exits, the container stops. Logs usually reveal whether the issue is:

- bad command
- missing file
- missing env var
- wrong working directory

The point is to diagnose before rebuilding.

## Task 2 — Inspect Environment Variables Inside A Container

```bash
docker exec -it running-container sh
env | sort
```

Or use:

```bash
docker inspect running-container
```

This confirms whether runtime config actually reached the container.

Why this matters:

- the Compose file may look correct
- but the actual running container may still have different values because of stale rebuilds, wrong env files, or a different startup path

## Task 3 — Check Files Inside A Running Container

```bash
docker exec -it running-container sh
ls -la /app
ls -la /data
```

This helps verify both copied files and mounted paths.

You should also ask:

- should this file exist because of `COPY` during build
- or should it exist only because of a runtime mount

That distinction often reveals whether the failure belongs to build logic or runtime wiring.

## Task 4 — Fix A Port Mapping Problem

Inspect the running configuration:

```bash
docker ps
docker inspect running-container
```

Example issue:

- app listens on container port `8000`
- host mapping incorrectly uses `8080:80`

Correct idea:

- publish `8080:8000` if the app actually listens on `8000`

Also classify the problem correctly:

- host access issue if the browser or curl cannot reach the service from the host
- internal service issue if one container cannot reach another by service name
- sometimes both if the stack mixes up internal and external ports

## Task 5 — Debug A Broken Compose Setup

Useful commands:

```bash
docker compose ps
docker compose logs
docker compose logs app
docker compose logs db
```

Common issues:

- wrong service hostname
- missing env var
- dependency not ready yet
- missing volume or expected file

Useful diagnostic categories:

- configuration
- readiness
- storage
- networking

That classification matters because it tells you where to look next.

## Common Mistakes

- rebuilding before checking logs
- assuming running means healthy
- not checking inside the container
- confusing host networking with container networking

## Optional Hard Mode - Troubleshooting Checklist

For a realistic stack such as `api + worker + postgres`, a good troubleshooting checklist is:

- check service status with `docker compose ps`
- inspect logs for each service
- confirm env vars inside the app container
- confirm service names used in connection strings
- confirm volumes exist for stateful services
- confirm readiness strategy for databases or object stores

## Definition Of Done

This topic is complete if you can:

- diagnose a stopped container with logs
- inspect runtime env vars
- verify files inside a running container
- reason about port mapping errors precisely
- classify a multi-service failure as config, readiness, storage, or networking
- investigate a Compose failure without jumping straight to rebuilds