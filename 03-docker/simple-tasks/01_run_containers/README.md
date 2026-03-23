# Run Containers

## Task 1 — Run Your First Container

### Goal

Understand the minimum Docker workflow for starting a container.

### Input

Use the `hello-world` image.

### Requirements

- run the container
- explain what Docker does if the image is not present locally
- explain why the container exits immediately

### Expected Output

A successful `hello-world` run and a short explanation of the lifecycle.

### Extra Challenge

Explain why a short-lived batch-style container is still useful.

## Task 2 — Start A Web Service In Background

### Goal

Practice detached container execution.

### Input

Use `nginx:alpine`.

### Requirements

- run nginx in detached mode
- publish the service on a host port
- verify that the service is reachable

### Expected Output

A running web container reachable from the host machine.

### Extra Challenge

Change the published host port and explain the difference between host port and container port.

## Task 3 — Inspect Running Containers

### Goal

Learn to inspect the current runtime state.

### Input

A running nginx container.

### Requirements

- list running containers
- identify the container name, image, and port mapping
- explain what the container main process is doing

### Expected Output

A short inspection note based on `docker ps` or equivalent commands.

### Extra Challenge

Run a second nginx container on another host port.

## Task 4 — Stop And Remove Containers

### Goal

Practice lifecycle cleanup.

### Input

One or more running test containers.

### Requirements

- stop the container
- remove the container
- confirm it is no longer listed in running containers

### Expected Output

A clean runtime state after container removal.

### Extra Challenge

Explain why removing a container does not necessarily remove the image.

## Task 5 — Read Container Logs

### Goal

Use logs as the first debugging tool.

### Input

A running or recently stopped container.

### Requirements

- view container logs
- describe what useful information logs provide
- explain when logs are more useful than rebuilding the image immediately

### Expected Output

A short explanation of what the logs show.

### Extra Challenge

Use log following mode on a running container.