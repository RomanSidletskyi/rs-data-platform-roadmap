# Spark Vs Pandas

## Decision

Choose between local dataframe processing and distributed dataframe processing.

## Context

This decision appears in data preparation, transformation jobs, and early-stage platform design.

## Decision Criteria

- data size
- memory and compute limits
- complexity of the pipeline
- team operating cost

## Option A

### Benefits

- simple developer workflow
- fast iteration for small or medium data
- low operational overhead

### Drawbacks

- limited by local machine resources
- weaker for large-scale distributed workloads

## Option B

### Benefits

- strong fit for large datasets and distributed transformations
- integrates well with lakehouse-scale processing
- useful when compute must scale horizontally

### Drawbacks

- higher setup and tuning complexity
- easy to overuse for small workloads

## Recommendation

Choose pandas when the workload fits comfortably on a single machine and the main goal is speed of iteration.

Choose Spark when data scale, distributed joins, or platform integration truly justify the operational cost.

## Revisit Trigger

Revisit when job runtime, memory pressure, or data volume grows beyond what local processing handles safely.