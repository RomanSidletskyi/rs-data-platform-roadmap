# Architecture - 03 Multi-Step Data Workflow

## Components

- Airflow DAG
- multiple task stages
- at least one branch, fan-out, or fan-in point
- validation and publish boundaries

## Target Project Shape

The intended implementation should include:

- one readable DAG with several stages
- one non-trivial dependency pattern
- one validation gate before final downstream completion

## Dependency Model

Good candidate shape:

1. extract
2. validate raw
3. fan out into two processing paths
4. reconverge into a validation or publish step

## Operational Model

- failed upstream validation should stop downstream stages
- retries should only repeat the necessary unit of work
- the graph should be explainable from the UI

## Trade-Offs

- richer DAGs teach more workflow design
- overly complex DAGs become harder to reason about
- too many small tasks increase scheduler noise

## What Would Change In Production

- stronger alerts
- real external systems
- queues, pools, or executor-level controls
- environment-specific config separation