# Partition Pruning, File Sizes, And Storage Layout

## Why This Topic Matters

Spark performance is never only about code.

It is also about how data is stored before Spark reads it and how Spark writes it afterward.

This is one of the clearest examples of data-platform architecture affecting compute cost. The same Spark code can behave very differently depending on the physical layout of the data it reads.

## Partition Pruning

Partition pruning matters because it lets Spark avoid reading irrelevant data.

Example:

- if a dataset is partitioned by `event_date`, a job reading only one day should avoid scanning the full history

This reduces:

- I/O
- runtime
- cluster cost

In practical terms, good pruning turns a broad historical dataset into a smaller targeted read without changing the transformation code dramatically.

That is why pruning is one of the cleanest examples of physical data design making logical business queries cheaper.

## File Sizes

File sizes matter because too many tiny files create metadata and scheduling overhead, while very large files may reduce healthy parallelism.

This is why output layout from one job affects the next one.

This is also why "the job finished successfully" is not enough as a quality bar. A job can succeed while still producing a harmful layout for everything downstream.

Another practical issue:

- a job may produce thousands of tiny files for one date partition
- the next job then spends large effort listing metadata and scheduling tasks instead of doing useful business work

That is not a minor tuning footnote. It is design debt.

## Storage Layout As System Design

Storage layout connects:

- upstream write behavior
- downstream read efficiency
- cost of rebuilds and backfills

So file layout is not merely a job-local optimization. It is part of platform architecture.

## Real Example

Suppose raw events are written daily and most downstream Spark jobs read by `event_date`.

Healthy architecture:

- date-oriented layout supports pruning
- file counts remain manageable
- rebuilds of a single date range stay practical

Weak architecture:

- output is fragmented into huge numbers of tiny files
- pruning is weak because layout does not match access patterns
- later jobs spend significant effort scanning metadata and irrelevant files

Another weak architecture pattern:

- the team partitions by a field with too many possible values
- writes look nicely segmented for one producer
- downstream reads and backfills become fragmented and expensive

## Real PySpark Example

```python
from pyspark.sql import functions as F

recent_orders = (
	spark.read.parquet("/lake/gold/orders_daily")
	.filter(F.col("event_date").between("2026-03-01", "2026-03-07"))
	.select("event_date", "country_code", "net_amount")
)
```

If the dataset is physically partitioned by `event_date`, this code can avoid scanning the full history.

That is the practical value of pruning-aware storage design.

## Write Layout Example

```python
(recent_orders
	.repartition("event_date")
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/gold/orders_daily_rebuilt")
)
```

This makes the link explicit: write layout from one job becomes the read cost of the next job.

## Architectural Questions To Ask

1. What are the main downstream read patterns?
2. Which columns deserve physical partition alignment?
3. Are we optimizing writes while making reads worse?
4. How will backfills behave against this layout?

These questions connect storage design to operational cost.

Two more valuable questions:

5. Are we choosing partitioning for the producer, the consumer, or the replay path?
6. Will the file layout still be healthy when data volume grows several times over?

## Good Response Versus Weak Response

Good response:

- align physical layout with real access patterns
- treat file count as part of job quality
- think about replay windows before finalizing output design

Weak response:

- accept whatever file shape the current write produced
- focus only on current runtime and ignore downstream cost
- assume storage layout can be fixed later without architectural consequences

## Good Strategy

- design storage layout around real downstream access patterns
- treat file counts and partition shape as first-class data-platform concerns
- evaluate output layout as part of the job review, not as an afterthought

## Key Architectural Takeaway

In Spark, storage layout decisions are effectively compute decisions deferred into the future.