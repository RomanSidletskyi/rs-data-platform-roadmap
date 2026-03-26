# Architecture - 02 API To Lakehouse Orchestration

## Components

- Airflow DAG
- API source
- raw object storage or simulated raw zone
- validation task
- downstream-ready task

## Target Project Shape

The intended implementation should include:

- one interval-driven API fetch step
- one raw landing contract
- one validation step
- one downstream continuation step

## Data Flow

1. Airflow identifies the interval to process
2. API data is fetched for that interval
3. raw payload is stored externally
4. validation confirms raw output exists and is usable
5. downstream processing or signaling is triggered

## Storage Model

- raw output should be external to Airflow metadata
- storage should be interval-scoped when possible

## Configuration Model

- API connection settings should not be hardcoded in DAG logic
- output locations should be configurable

## Trade-Offs

- simple one-DAG design is easier to learn
- large API pagination inside one task can become noisy
- stronger contracts improve safety but increase setup work

## What Would Change In Production

- real secrets backend
- stronger API timeout and retry policies
- real object storage
- downstream warehouse or lakehouse integration