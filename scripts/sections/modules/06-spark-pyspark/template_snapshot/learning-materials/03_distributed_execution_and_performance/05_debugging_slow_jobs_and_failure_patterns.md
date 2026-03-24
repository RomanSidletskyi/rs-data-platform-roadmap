# Debugging Slow Jobs And Failure Patterns

## Why This Topic Matters

Architectural thinking includes incident thinking.

When a Spark job becomes slow or unstable, teams need a framework for deciding whether the problem is caused by:

- data skew
- bad join shape
- too much shuffle
- broken schema assumptions
- output layout problems
- infrastructure pressure

Without a framework, debugging becomes random tuning. Teams try bigger clusters, new configs, or code rewrites without first understanding what the job is actually telling them.

## A Practical Debugging Sequence

1. identify which stage is slow or unstable
2. inspect whether shuffles or skew dominate that stage
3. check input size, key distribution, and join shape
4. review output layout and downstream pressure
5. ask whether the job design or the cluster sizing is the real bottleneck

This sequence matters because it forces the investigation to start from execution evidence rather than intuition.

It also helps split the problem into categories instead of treating all slowness as one thing.

## Useful Failure Categories

### Scan-heavy failures

- too much input is being read
- pruning is weak
- storage layout no longer matches access patterns

### Shuffle-heavy failures

- wide joins or aggregations dominate runtime
- a recent logic change introduced more data movement

### Skew-heavy failures

- one or a few tasks dominate the stage
- a business key distribution changed in a way the pipeline did not respect

### Write-heavy failures

- output layout creates too many small files
- late-stage writes become slower than the transformation work itself

This classification is simple, but it keeps debugging grounded.

## Common Failure Patterns

- one or two tasks run much longer than the rest
- the driver struggles because too much data is collected
- a join becomes unexpectedly massive
- output writing creates too many tiny files

Additional patterns worth recognizing:

- the job runtime grows after a new data source changes key distribution
- replay or backfill windows become much slower than daily runs
- one downstream output is cheap while another output from the same cleaned layer becomes extremely expensive

These patterns usually mean the issue is not generic "Spark slowness." It is a specific execution-shape problem.

## Real Example

Suppose a daily payments enrichment job used to finish in 18 minutes and now takes 45.

A weak response is:

- increase cluster size immediately

A stronger response is:

- identify the newly slow stage
- check whether one partner or key now dominates the data
- inspect whether the join or aggregation shape changed
- ask whether input pruning or output layout regressed

This is slower intellectually, but faster operationally.

Another example:

- the transformation logic still looks stable
- but the write phase suddenly dominates the job
- review shows a layout change created an explosion of tiny files

That means the job is not only a compute problem. It is also a storage-publication problem.

## Real PySpark Example

```python
from pyspark.sql import functions as F

orders = spark.read.parquet("/lake/bronze/orders")
payments = spark.read.parquet("/lake/bronze/payments")

job_output = (
	orders
	.filter(F.col("event_date") >= F.lit("2026-03-01"))
	.join(payments.select("order_id", "payment_status"), on="order_id", how="left")
	.groupBy("event_date", "payment_status")
	.agg(F.countDistinct("order_id").alias("orders_cnt"))
)
```

When this job slows down, do not read it as one large black box.

Break it into possible expensive points:

- scan volume on `orders`
- join width and key distribution
- aggregation shuffle
- final write path

That is the practical debugging habit this topic is trying to teach.

## Good Strategy

- debug Spark jobs as execution systems, not just as Python code
- connect symptoms back to stage shape, partitioning, and data design
- treat recurring failure patterns as architecture feedback, not as isolated job annoyances
- prefer root-cause analysis over generic resource escalation

## Evidence Worth Gathering

- which stage regressed
- whether tasks are balanced or dominated by stragglers
- whether input size or key distribution changed
- whether the bottleneck is before or during output publication
- whether the issue affects only backfills or also the daily path

## Key Architectural Takeaway

Many slow Spark jobs are telling you something true about data movement, skew, or output layout. The fix should usually address that root cause rather than only adding more hardware.