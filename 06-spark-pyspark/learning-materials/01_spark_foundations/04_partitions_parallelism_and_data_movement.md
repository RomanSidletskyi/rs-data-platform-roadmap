# Partitions, Parallelism, And Data Movement

## Why This Topic Matters

Partitions are one of the deepest practical ideas in Spark.

They affect:

- parallelism
- task scheduling
- shuffle cost
- skew risk
- file output layout

If you ignore partitions, Spark jobs become harder to scale and harder to debug.

## What A Partition Is

A partition is a chunk of data that Spark can process as a unit of parallel work.

Tasks typically operate on partitions.

More partitions can create more parallelism, but only when the work is balanced and the overhead stays reasonable.

## Why Partitions Matter So Much

Partitioning influences:

- how many tasks Spark can schedule
- whether some tasks finish much slower than others
- how much data must move across the network
- how evenly work is distributed across executors

This is why partitioning is not a low-level tuning trick. It is core distributed-systems design.

## Example

Suppose you read a raw orders dataset and then aggregate by `customer_id`.

If customer activity is evenly distributed, partitions may behave acceptably.

If one customer or region dominates the data, one or a few partitions may become very heavy.

That leads to skew:

- most tasks finish quickly
- a few tasks run much longer
- the whole stage waits for stragglers

## Real PySpark Example

```python
from pyspark.sql import functions as F

orders = spark.read.parquet("/lake/bronze/orders")

print("input_partitions=", orders.rdd.getNumPartitions())

daily_country_revenue = (
	orders
	.filter(F.col("event_date") >= F.lit("2026-03-01"))
	.groupBy("event_date", "country_code")
	.agg(F.sum("net_amount").alias("revenue"))
)
```

What this code helps you see:

- the input already has some physical partition count
- the `groupBy(...)` is a wide transformation and may trigger data movement
- if one country dominates records, task balance can still be poor after the filter

The code itself is short.

The important part is learning to ask where Spark will preserve partition-local work and where it will reshuffle data.

## Parallelism Is Not Infinite Free Speed

Beginners often think:

- more partitions means more speed

Reality is more subtle.

Too few partitions can underuse the cluster.

Too many partitions can create overhead in:

- task scheduling
- shuffle metadata
- small output files
- execution coordination

So the goal is not maximum partition count.

The goal is healthy partition shape for the workload.

## Data Movement Is Often The Real Cost

Local transformations that stay inside partitions are usually cheaper.

Operations that require records to move across partitions are often more expensive.

Examples:

- `groupBy`
- large joins
- repartitioning
- distinct-like global reshaping

These operations may cause shuffles.

In production, shuffle-heavy jobs are often where cost and runtime problems show up first.

## Repartition Example

```python
rebalanced = orders.repartition("event_date")
```

This may be useful if later work is strongly date-oriented.

It may also be wasteful if the job was already well-partitioned for the next step.

That is why `repartition(...)` should be treated as a deliberate redistribution step, not a default line you paste into every job.

## Partition Design Questions

When reasoning about Spark jobs, ask:

1. How many partitions will the input likely have?
2. Are they balanced or skewed?
3. Which transformations preserve partition-local work?
4. Which steps force redistribution?
5. What output file layout will be created afterward?

Those questions link execution behavior directly to architecture decisions.

## Example: Raw To Curated Pipeline

Imagine this flow:

- raw event files land in object storage
- Spark reads them
- Spark filters by date
- Spark joins with product metadata
- Spark writes curated daily outputs

If partitioning is sensible:

- filtering prunes data early
- joins remain manageable
- output files are not absurdly tiny or huge

If partitioning is poor:

- skew slows stages
- shuffles dominate runtime
- output layout hurts downstream jobs too

So partition thinking is not only about this one job. It affects later jobs and consumers as well.

## Common Mistakes

### Mistake 1: Never Thinking About Partitions

Reality:

- Spark still uses partitions whether you think about them or not
- ignoring them only means you discover the consequences later

### Mistake 2: Repartitioning Blindly

Reality:

- repartition can help when you need redistribution
- but unnecessary repartitioning adds shuffle cost

### Mistake 3: Optimizing For One Stage Only

Reality:

- output partitioning and file shape affect downstream pipelines too

## Good Strategy

- treat partitions as the unit of distributed work
- ask where data movement is happening
- balance parallelism against overhead
- think about partitioning both for execution and for downstream storage layout

## Key Architectural Takeaway

In Spark, performance is often less about raw compute power and more about how intelligently data is partitioned and moved.