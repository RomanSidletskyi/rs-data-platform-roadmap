# Task Set 10: Snowflake Performance Diagnosis and Design

These account-free exercises train performance reasoning. Use the supplied evidence; do not jump directly to warehouse resizing or a feature recommendation. Record the assumptions you need.

For every task, include:

1. The likely bottleneck and evidence supporting it.
2. One additional check that could disprove your diagnosis.
3. A recommended action and one alternative.
4. Correctness, cost, freshness, and operating trade-offs.

## Task 1: Decompose End-to-End Latency

A report takes 95 seconds. Query History shows: `TOTAL_ELAPSED_TIME = 95,000 ms`, `COMPILATION_TIME = 2,000 ms`, `EXECUTION_TIME = 21,000 ms`, `QUEUED_PROVISIONING_TIME = 66,000 ms`, and negligible overload queue.

Name the dominant delay, one likely user-facing consequence, and two checks before changing warehouse size or auto-suspend.

## Task 2: Interpret Spill

A join-heavy query has 0 bytes local spill, 4 GB remote spill, high output rows at a Join operator, and high execution time. Give the investigation order and compare a SQL/data-shape change with resizing the warehouse.

## Task 3: Broad Scan Or Expected Scan?

A daily report returns 0.3% of a fact table, but its TableScan shows `PARTITIONS_SCANNED = 9,200` and `PARTITIONS_TOTAL = 10,000`. The predicate is `DATE(order_ts) = '2026-01-15'`. Assume `order_ts` is `TIMESTAMP_NTZ` and the business day is defined in UTC.

Propose a semantically equivalent test query, list the evidence to compare, and explain why “9,200 partitions is always bad” is not a sound conclusion for every workload.

## Task 4: Join Fan-Out

A customer join takes 100,000 input rows and emits 50,000,000 rows. The target report expects one row per order. Identify at least three possible causes and give a safe validation/fix sequence.

## Task 5: Cache-Aware Benchmark

A query runs in 3 seconds on its second run but 40 seconds after an overnight warehouse suspension. Explain the difference between persisted result reuse and local warehouse data cache. Design a small benchmark that distinguishes them.

## Task 6: Choose The Serving Table Pattern

A daily Parquet feed needs immediate schema profiling; after validation it powers high-use Snowflake BI. A Spark team may consume the curated output later, but there is no approved shared-table contract today.

Recommend a phased design among external tables, native tables, and Iceberg. State what future requirement would change your choice.

## Task 7: Select An Optimization Feature

A 6 TB customer fact table has three query groups:

- a daily date-range report that scans 35% of the table and meets SLA;
- an hourly point lookup by customer ID that scans many partitions and misses SLA;
- a repeated dashboard aggregation whose query cost is significant, but freshness can be 30 minutes.

For each group, recommend whether to leave it alone, test clustering, evaluate Search Optimization, use a maintained aggregate/materialized view/dynamic table, or change warehouse configuration. Name the evidence and hidden cost you would compare.

## Task 8: Performance Architecture Decision

A finance mart serves interactive BI and nightly transformations. BI queues during the nightly run; the nightly query also spills remotely. Propose a design that addresses both symptoms without treating them as one problem. Include warehouse boundaries/scaling, SQL/data-shape work, cache considerations, cost attribution, and success metrics.

## Self-Review

Before consulting `solution.md`, check that your answer distinguishes:

- queue time from execution time
- persisted result reuse from local data cache
- pruning evidence from a blanket scan threshold
- intended join cardinality from accidental fan-out
- single-query acceleration from concurrency scaling
- query latency improvements from total platform cost

When finished, compare your reasoning with the [worked solutions](solution.md).
