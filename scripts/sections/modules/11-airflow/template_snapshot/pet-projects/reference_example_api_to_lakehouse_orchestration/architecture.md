# Architecture - Reference Example API To Lakehouse Orchestration

## Components

- Airflow DAG
- HTTP API source
- local raw zone on filesystem
- validation task
- downstream-ready marker task

## Data Flow

1. Airflow identifies the interval
2. an API request is made for that interval
3. response payload is landed under an interval-scoped raw path
4. raw file is validated for existence and minimum record quality
5. a downstream-ready marker is created

## Storage Model

- raw payload stays outside Airflow metadata
- output path includes interval information for deterministic reruns
- readiness marker is separate from the payload itself

## Configuration Model

- API connection is resolved through Airflow connection ID
- output base path and minimum record threshold come from config and env

## Trade-Offs

- local filesystem output is simpler than real object storage for a learning example
- one DAG is easier to reason about than a multi-DAG coordination setup
- storing interval metadata in file paths improves rerun safety but adds path logic

## What Would Change In Production

- object storage instead of local filesystem
- stricter schema validation
- richer API retry and backoff policy
- downstream warehouse or dbt orchestration after validation