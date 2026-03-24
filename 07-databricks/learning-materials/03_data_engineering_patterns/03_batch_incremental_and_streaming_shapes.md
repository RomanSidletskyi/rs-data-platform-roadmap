# Batch, Incremental, And Streaming Shapes

## Why This Topic Matters

Databricks supports several workload styles.

The platform is not only for one giant nightly batch, and it is not only for streaming.

The job is to choose the right shape for the data product.

## Batch

Batch fits when:

- data arrives in windows
- full or bounded rebuilds are acceptable
- operational simplicity matters more than lowest latency

## Incremental

Incremental fits when:

- data volumes are large enough that full rebuilds are expensive
- bounded refresh windows are needed
- the platform needs faster updates without full streaming complexity

## Streaming

Streaming fits when:

- freshness requirements are tight
- event arrival is continuous
- the platform is ready to operate state, checkpoints, and replay boundaries responsibly

## Databricks-Specific Lesson

The presence of notebooks, jobs, and managed compute does not remove the need to choose the right processing shape.

Weak teams sometimes force streaming because it sounds advanced.

Strong teams choose the cheapest and safest shape that still meets the SLA.

## Good Strategy

- start with workload and SLA, not with fashionable platform features
- use batch, incremental, or streaming according to the real delivery need
- connect the chosen shape to backfill and repair strategy early

## Key Architectural Takeaway

Databricks supports several processing shapes, but the right one still depends on delivery requirements, cost, and operational readiness.