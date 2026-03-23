# Data Engineering Local Stacks

## Task 1 — Run Postgres In Compose

### Goal

Start a local database using Docker Compose.

### Input

Use `postgres:16-alpine`.

### Requirements

- define a Compose service for Postgres
- add required environment variables
- add persistent storage

### Expected Output

A local Postgres service running through Compose.

### Extra Challenge

Add a quick validation command or SQL client check.

## Task 2 — Run MinIO In Compose

### Goal

Start local object storage for learning workflows.

### Input

Use a MinIO image.

### Requirements

- define the service in Compose
- expose both API and console ports
- persist data with a volume

### Expected Output

A local MinIO service usable for testing.

### Extra Challenge

Explain why object storage matters in data platforms.

## Task 3 — Connect A Python App To A Service

### Goal

Make an application service consume runtime service configuration.

### Input

A small Python app plus one support service.

### Requirements

- pass connection settings through environment variables
- use the Compose service name as the host
- explain why this is more portable than hardcoded localhost assumptions

### Expected Output

A small but realistic service connectivity setup.

### Extra Challenge

Show how the same code could run locally outside Docker with different env values.

## Task 4 — Build A Small ETL Runtime Stack

### Goal

Combine multiple Docker concepts into a realistic local workflow.

### Input

A Python ETL app, one storage service, and one database or output target.

### Requirements

- describe the stack components
- define them in Compose
- explain what each service is responsible for

### Expected Output

A small local data engineering stack design.

### Extra Challenge

Add one note about persistence, observability, or configuration management.

## Task 5 — Explain Docker In A Data Platform Workflow

### Goal

Move from command usage to system-level understanding.

### Input

Your own explanation based on this module.

### Requirements

- explain where Docker helps in data engineering
- explain what Docker does not solve by itself
- mention reproducibility, runtime isolation, and local service stacks

### Expected Output

A concise architectural explanation.

### Extra Challenge

Add a note about when a stack should later move to another runtime target.