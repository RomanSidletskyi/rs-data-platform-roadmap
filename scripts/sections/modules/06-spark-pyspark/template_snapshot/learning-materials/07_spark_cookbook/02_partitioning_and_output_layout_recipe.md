# Partitioning And Output Layout Recipe

## Why This Recipe Exists

Many Spark pipelines are "correct" but still unhealthy because the output layout makes later reads expensive.

This recipe is for choosing output shape with downstream consumers in mind.

It is also for resisting a common beginner instinct: writing output in whatever layout was easiest for the current job without thinking about the next ten jobs.

## Use This Recipe When

- you are writing curated datasets for later Spark jobs
- you are building date-based analytical outputs
- you are seeing too many small files or painful downstream scans

## Start With Downstream Reality

Before choosing layout, ask:

- who reads this dataset next?
- how do they filter it?
- do they usually access recent slices, historical windows, or full scans?
- is this dataset mainly for Spark, warehouse ingestion, or BI-facing serving layers?

If those questions are unclear, output design is probably premature.

## Decision Questions

1. What are the main downstream read patterns?
2. Which columns are actually used for pruning and slicing?
3. Will this layout create too many tiny files?
4. Are you optimizing for one write today at the expense of every read tomorrow?

Also ask:

5. How will backfills behave against this layout?
6. Is the partition key low-cardinality enough to be physically useful?

Two more useful questions:

7. Will this layout help the next three consumers, or only the current writer?
8. If this dataset grows 10x, will the partition strategy still be healthy?

## Real Example

Scenario:

- curated orders dataset is written daily
- most downstream jobs read by `event_date`
- analysts often slice by monthly windows

Healthy pattern:

- design output around date-oriented access patterns
- avoid exploding file counts at tiny partition granularity
- think about future backfills and replay windows

Weak pattern:

- partition by a high-cardinality business key simply because it seemed convenient in one job

Another realistic example:

- a support-facing dataset is mostly queried by event date and region
- the team writes it partitioned by `customer_id`

The write may succeed.

The read pattern becomes structurally mismatched.

Another realistic example:

- a daily fraud-review dataset is mostly read by `review_date`
- the team partitions it by `merchant_id`
- a few large merchants then create both skewed writes and awkward reads

This is the kind of issue that looks harmless at first and becomes obvious only after growth.

## Real PySpark Example

```python
from pyspark.sql import functions as F

curated_orders = (
	spark.read.parquet("/lake/silver/orders_enriched")
	.filter(F.col("event_date") >= F.lit("2026-03-01"))
	.select(
		"event_date",
		"order_id",
		"customer_id",
		"country_code",
		"net_amount",
		"order_status",
	)
)

(curated_orders
	.repartition("event_date")
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/gold/daily_orders")
)
```

## Why This Code Is Healthy

- the dataset is filtered to the actual publish window before writing
- only consumer-relevant columns are retained in the output
- `repartition("event_date")` aligns the write path with the physical layout being produced
- `partitionBy("event_date")` reflects the dominant downstream pruning pattern

## What This Code Does Not Mean

This snippet does not mean `event_date` is always the right partition key.

It is healthy here because:

- downstream readers slice by date
- backfills are date-scoped
- `event_date` is low-cardinality enough to produce useful pruning without exploding file counts

If your readers mostly filter by merchant or region, the right design discussion changes.

## Good Response Versus Weak Response

Good response:

- start from actual consumer filtering behavior
- prefer partition keys that materially improve pruning
- keep file counts and replay windows in the design review

Weak response:

- pick a partition key because it is already present in the source
- optimize only the current write path
- ignore how backfills and monthly scans will behave later

## Common Anti-Patterns

- choosing output layout from implementation convenience instead of access patterns
- ignoring the small-file impact of over-partitioned writes
- designing output shape without considering backfills or replay windows
- partitioning by high-cardinality business keys just because they feel semantically important

## Practical Review Checklist

- what are the main pruning columns?
- is the partition key stable over time?
- will this layout create too many tiny files?
- how will a 30-day replay behave?
- is there a mismatch between writer convenience and reader reality?

## Architectural Takeaway

Output layout is one of the easiest ways to create or remove long-term technical debt in a Spark platform.