# Docker Compose Basics

## Task 1 — Define A Single Service In Compose

### Goal

Describe one container declaratively.

### Input

A simple service such as nginx.

### Requirements

- create a compose file with one service
- start the service with Compose
- verify the service status
- explain which parts of the file are runtime configuration and which are service identity

### Expected Output

A working single-service Compose setup.

### Extra Challenge

Compare the Compose file with the equivalent `docker run` command.

## Task 2 — Add Environment Variables

### Goal

Move runtime settings into configuration.

### Input

A compose service that uses environment variables.

### Requirements

- add environment variables in Compose
- explain why runtime config should not be hardcoded in source code
- verify the service receives the variables
- prefer using a `.env` file or `env_file` if several values are involved

### Expected Output

A service configured through environment values.

### Extra Challenge

Use a `.env` file.

## Task 3 — Add Persistent Storage

### Goal

Model persistent state in Compose.

### Input

A stateful service such as Postgres.

### Requirements

- define a named volume
- attach it to the service
- explain why this matters for databases
- explain why a bind mount is not always the best default for stateful services

### Expected Output

A stateful service with persistent storage.

### Extra Challenge

Explain what is lost if the container is recreated without a volume.

## Task 4 — Run App And Postgres Together

### Goal

Model a small two-service system.

### Input

An application service and a database service.

### Requirements

- define both services in one Compose file
- configure the app to use the database service name
- explain why localhost is not the correct database host inside the app container
- add a readiness strategy such as a healthcheck or a clear note explaining why startup order is insufficient

### Expected Output

A working two-service local system design with a credible readiness strategy.

### Extra Challenge

Add a note about readiness vs startup order.

## Task 5 — Inspect Compose Logs

### Goal

Read logs across a multi-service setup.

### Input

A running Compose stack.

### Requirements

- inspect service status
- read logs for one service
- explain what logs help you verify
- verify at least one thing about inter-service behavior, not only one isolated container

### Expected Output

A short diagnosis or verification note based on Compose logs.

### Extra Challenge

Read logs for the whole stack and summarize component behavior.

## Optional Hard Mode

Extend the stack from `app + postgres` to one of these shapes:

- `api + worker + postgres`
- `app + postgres + minio`

Then explain:

- which services are application services
- which services are platform services
- which services should expose host ports and which should stay internal