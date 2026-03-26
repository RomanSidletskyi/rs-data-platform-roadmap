# Airflow Vs Cron

## Decision

Choose between workflow orchestration and simple scheduled execution.

## Context

This decision appears whenever a team needs scheduled data jobs.

The mistake is often to treat all scheduled work as equally complex.

## Decision Criteria

- dependency complexity
- retries and observability
- workflow branching and state
- team operating overhead

## Option A

### Benefits

- explicit DAGs and dependencies
- stronger retry, scheduling, and monitoring support
- good fit for multi-step data workflows

### Drawbacks

- more platform overhead
- can be too heavy for a few simple independent jobs

## Option B

### Benefits

- extremely simple for small independent tasks
- low operational overhead
- good enough for narrow, stable schedules

### Drawbacks

- weak dependency visibility
- weak workflow observability and recovery at scale
- harder to manage many interdependent tasks safely

## Recommendation

Choose Airflow when the workload is a real workflow with dependencies, retries, visibility needs, and shared operational ownership.

Choose cron when the task is simple, isolated, and does not justify orchestration infrastructure.

## Revisit Trigger

Revisit when a simple scheduled job becomes a multi-step workflow or when incident visibility becomes inadequate.