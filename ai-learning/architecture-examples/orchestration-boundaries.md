# Orchestration Boundaries

## Scenario

A project uses Airflow or another orchestrator to run ingestion, validation, and publish stages.

The team starts pushing more and more business logic into orchestration tasks.

## Core Tension

What should live in the orchestrator versus in reusable pipeline code?

## Trade-Offs

- orchestrators are good at scheduling, dependencies, retries, and observability
- they are weak as the primary home for transformation or domain logic
- moving too much logic into DAG files creates brittle maintenance and poor reuse

## Failure Modes

- orchestration code becoming the hidden transformation layer
- retry semantics differing from domain logic expectations
- local testing becoming harder because logic is trapped inside scheduling code

## Code-Backed Discussion Point

```python
@task
def transform_orders(raw_path, curated_path):
    records = load_records(raw_path)
    valid = [record for record in records if is_valid(record)]
    write_records(curated_path, valid)
```

The code can work.

The architecture issue is whether the transformation logic now depends on orchestration context too tightly to be reused or tested cleanly elsewhere.

## Decision Signal

Keep orchestrators as control planes.

Keep business and transformation logic in testable modules with clear interfaces.

## Review Questions

- which responsibilities belong to orchestration versus reusable code
- how would local testing change under each design
- what retry behavior is orchestration providing versus hiding
- what logic becomes harder to reuse if kept inside the orchestrator

## AI Prompt Pack

```text
Compare an orchestration-heavy design against a thin-control-plane design for a data pipeline. Focus on testability, retry semantics, code reuse, and long-term maintenance.
```

```text
Act as a skeptical reviewer. What signs suggest that orchestration code is becoming the hidden business-logic layer?
```