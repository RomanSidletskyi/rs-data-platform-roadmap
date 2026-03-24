# Architecture - 01 Batch Pipeline Orchestration

## Components

- Airflow DAG
- one or more lightweight task helpers
- source input contract
- validation step
- publish or success-marker step

## Target Project Shape

The intended implementation should include:

- one DAG with clear batch stages
- one validation boundary before publish
- one final output or completion signal

## Data Flow

1. identify the interval to process
2. extract or locate source input
3. validate the source input
4. run a small transformation or processing step
5. publish output or success marker

## Configuration Model

- runtime settings should come from config or Airflow variables/connections where appropriate
- time-based logic should use interval values, not wall-clock assumptions

## Operational Model

- failures before publish should stop the workflow
- retries should not produce unsafe duplicates
- logs should make stage boundaries clear

## Trade-Offs

- one simple DAG is easy to reason about
- too many tiny tasks create noise
- too much logic in one task weakens failure isolation

## What Would Change In Production

- real storage systems instead of placeholders
- stronger alerting
- environment separation
- more explicit data contracts