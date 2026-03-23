# Solution - Run Containers

This topic introduces the base Docker lifecycle: run, inspect, stop, remove, and read logs.

## Task 1 — Run Your First Container

```bash
docker run --rm hello-world
```

Explanation:

- Docker checks the local image store
- if the image is missing, it pulls it from the registry
- it starts the container process
- the process prints a message and exits
- `--rm` removes the container after completion

## Task 2 — Start A Web Service In Background

```bash
docker run -d --name demo-nginx -p 8080:80 nginx:alpine
curl http://localhost:8080
```

The host port is `8080`. The container port is `80`.

## Task 3 — Inspect Running Containers

```bash
docker ps
```

You should see:

- container name
- image name
- running status
- port mapping

The main nginx process keeps the container alive.

## Task 4 — Stop And Remove Containers

```bash
docker stop demo-nginx
docker rm demo-nginx
docker ps
```

Removing a container does not remove the image artifact. Images and containers have separate lifecycles.

## Task 5 — Read Container Logs

```bash
docker logs demo-nginx
```

For a running service:

```bash
docker logs -f demo-nginx
```

Logs help confirm:

- whether the main process started
- whether requests reached the service
- whether the application emitted errors

## Definition Of Done

This topic is complete if you can:

- run a short-lived test container
- run a detached web service
- inspect current containers
- stop and remove a test container
- read and interpret basic logs