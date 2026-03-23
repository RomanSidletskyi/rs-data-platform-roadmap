# Ports, Volumes, And Networks

## Task 1 — Publish A Container Port

### Goal

Expose a service from a container to the host machine.

### Input

Use `nginx:alpine`.

### Requirements

- run a web service container
- publish a host port to container port 80
- verify the service from the host

### Expected Output

A web page or response reachable through the published host port.

### Extra Challenge

Publish the same container image on a different host port.

## Task 2 — Mount A Local Folder Into A Container

### Goal

Understand host-to-container file mapping.

### Input

A local folder with a simple `index.html` file.

### Requirements

- create a local folder
- mount it into the nginx web root
- confirm the mounted file is served by the container

### Expected Output

A container serving content from a host-mounted directory.

### Extra Challenge

Explain why bind mounts can reduce portability.

## Task 3 — Use A Named Volume

### Goal

Practice persistent storage in a Docker-managed volume.

### Input

Use `postgres:16-alpine`.

### Requirements

- create a named volume
- start Postgres using that volume
- explain why a database usually needs persistent storage

### Expected Output

A running database container using a named volume.

### Extra Challenge

List local volumes and identify the one you created.

## Task 4 — Connect Two Containers

### Goal

Practice service-to-service communication basics.

### Input

Two services in Docker Compose or on a custom network.

### Requirements

- run two services in the same Docker network context
- explain how one service reaches the other
- avoid using host localhost assumptions incorrectly

### Expected Output

A short explanation or demonstration of container-to-container connectivity.

### Extra Challenge

Explain why `localhost` inside one container usually does not mean another container.

## Task 5 — Explain Bind Mount Vs Volume

### Goal

Understand storage trade-offs.

### Input

Your own comparison.

### Requirements

- compare bind mounts and named volumes
- explain a good use case for each
- mention at least one trade-off

### Expected Output

A short structured comparison.

### Extra Challenge

Add a note about persistence for local data engineering stacks.