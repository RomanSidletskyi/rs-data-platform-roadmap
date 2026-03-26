# Airflow DAGs Versus Pipeline Logic

## Scenario

An Airflow project starts simple, but more and more transformation and validation logic is moved directly into DAG tasks.

## Core Tension

Should DAG files contain the business logic, or should they orchestrate reusable pipeline modules with clear interfaces?

## Trade-Offs

- putting logic in DAGs can feel faster early on
- reusable modules improve testing, reuse, and portability
- keeping DAGs thin makes orchestration behavior clearer and business logic easier to reason about

## Failure Modes

- retry behavior hiding transformation bugs
- local tests becoming painful because logic depends on orchestration context
- the DAG becoming the only place where the real pipeline behavior is understandable

## Code-Backed Discussion Point

```python
@task
def build_customer_snapshot(run_date: str):
    rows = extract_orders(run_date)
    valid_rows = [row for row in rows if is_valid(row)]
    return aggregate_snapshot(valid_rows)
```

This can run.

The architecture question is whether the validation and aggregation logic can be tested and reused outside the DAG without carrying orchestration assumptions everywhere.

## Decision Signal

Use DAGs as control planes and reusable modules as the home of domain logic.

## Review Questions

- what logic is only about scheduling and dependencies
- what logic needs local tests outside orchestration context
- how would portability change if the orchestrator changed later
- where are retries masking domain issues

## AI Prompt Pack

```text
Compare a DAG-heavy implementation style against a thin-DAG plus reusable-module style for Airflow-based pipelines. Focus on testability, portability, retry semantics, and maintainability.
```

```text
Review this Airflow architecture and identify where orchestration concerns and business logic are leaking into each other.
```