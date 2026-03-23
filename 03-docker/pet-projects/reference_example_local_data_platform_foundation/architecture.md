# Architecture - 04 Local Data Platform Foundation

## Components

- processing application service
- Postgres for structured storage
- MinIO for object storage simulation
- optional initialization or helper scripts

## Current Example

The implemented reference uses:

- one Python processing application
- one Postgres database with raw and summary tables
- one MinIO bucket for summary artifact storage

## Target Project Shape

The intended implementation should include:

- one application service
- two platform services with different storage roles
- one input dataset
- one verifiable output path through the stack

## Data Flow

1. source data enters through local files or generated test inputs
2. processing service reads and transforms the data
3. artifacts are written to object storage or database targets
4. validation checks confirm expected results

## Service Boundaries

- platform services provide storage capabilities
- application services implement business or data logic
- configuration should define how these parts connect

## Configuration Model

- runtime settings should be externalized through env vars or config files
- service connection details should come from Compose or runtime configuration
- storage locations and output behavior should be explicit

Current runtime variables:

- `APP_ENV`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `MINIO_ROOT_USER`
- `MINIO_ROOT_PASSWORD`
- `MINIO_ENDPOINT`
- `CONFIG_PATH`
- `INPUT_PATH`

## Storage Model

- Postgres data should be persistent
- MinIO data should be persistent
- transient application state should not be confused with durable service state

## Target Outputs

Your implementation should produce at least:

- one application-generated output artifact
- one verified write into Postgres or MinIO
- one runtime validation showing the stack worked end-to-end

In this reference example, the app writes:

- raw events into `raw_events`
- summary counts into `event_counts_by_type`
- `event_summary.json` into the configured MinIO bucket

## Trade-Offs

- local stacks accelerate learning but can drift from cloud reality
- adding too many services increases complexity without increasing understanding
- a focused platform foundation is better than a bloated “mini production” clone

## What Would Change In Production

- managed services instead of local containers
- stronger secrets handling
- formal scheduling and orchestration
- richer observability and access controls