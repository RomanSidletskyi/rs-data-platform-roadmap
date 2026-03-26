# Read/Write Patterns And Output Layout

## Why This Topic Matters

Spark jobs do not end when the transformation logic is correct.

They end when outputs are written in a form that downstream systems can actually use efficiently.

This is where execution thinking and storage thinking meet.

## Reading Patterns

When reading data, strong engineers think about:

- input format
- schema handling
- partition pruning opportunities
- file counts and file sizes

The goal is not only to read data successfully.

The goal is to read it in a way that supports efficient processing.

That means reading logic should already reflect:

- expected data quality
- schema stability needs
- which subset of data is actually required for the current job

## Writing Patterns

When writing data, strong engineers think about:

- output partitioning
- overwrite versus append semantics
- small-file risk
- downstream consumer expectations

These are not minor details.

They determine whether later jobs and analytical queries remain healthy.

They also determine whether replay and backfill remain practical after the dataset grows.

## Example

Imagine a daily curated orders output.

Healthy output reasoning may include:

- partition by `event_date` because downstream jobs read by date
- avoid generating thousands of tiny files
- write in a format consistent with later consumption layers

Weak output reasoning might simply call write and ignore everything else.

That often creates technical debt for later jobs.

Another realistic example:

- a support analytics dataset is queried mostly by date and region
- the pipeline writes using a shape inherited from source-system keys
- downstream readers then pay the cost of a write-centric layout that never matched their access pattern

This is why write logic should be treated as platform design, not just final syntax.

## Real PySpark Example

```python
from pyspark.sql import functions as F

orders = (
	spark.read.parquet("/lake/silver/orders")
	.filter(F.col("event_date") >= F.lit("2026-03-01"))
	.select("event_date", "order_id", "customer_id", "country_code", "net_amount")
)

(orders
	.repartition("event_date")
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/gold/orders_daily")
)
```

## Why This Code Is Healthy

- the read path is bounded to the required window
- unused columns are dropped before the write path
- repartitioning aligns execution with the chosen physical layout
- output is written in a way that helps later date-based reads prune efficiently

## Longer Publish Pattern Example

```python
from pyspark.sql import functions as F

silver_orders = (
	spark.read.parquet("/lake/silver/orders")
	.filter(F.col("event_date").between("2026-03-01", "2026-03-07"))
	.select(
		"event_date",
		"order_id",
		"customer_id",
		"country_code",
		"net_amount",
		"order_status",
	)
)

publish_ready = (
	silver_orders
	.filter(F.col("order_status") != F.lit("cancelled"))
	.groupBy("event_date", "country_code")
	.agg(
		F.countDistinct("order_id").alias("orders_cnt"),
		F.sum("net_amount").alias("net_revenue")
	)
)

(publish_ready
	.repartition("event_date")
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/rebuild/daily_country_revenue_2026_03_07")
)
```

## Why This Pattern Is Stronger

- it separates the read window from the publish destination
- it aggregates before publication so consumers read a dataset aligned to their questions, not raw operational detail
- it writes to an isolated rebuild location, which is safer for validation and cutover than blind replacement of trusted output

## Questions This Example Forces You To Answer

1. Is overwrite safe because this is a rebuild target rather than the always-live consumer path?
2. Does `event_date` reflect the main consumer pruning column or only writer convenience?
3. Should the final publish path keep the same partitioning as the rebuild path?

## Weak Version Of The Same Idea

```python
spark.read.parquet("/lake/silver/orders").write.parquet("/lake/gold/orders_daily")
```

This may technically work.

It says almost nothing about correctness boundaries, read scope, file layout, or consumer needs.

## Output Layout As Architecture

Output layout affects:

- downstream Spark reads
- warehouse loading behavior
- cost of future backfills
- operational simplicity

So output layout is not only job-level tuning.

It is part of system design.

## Read Path Versus Write Path Trade-Off

One of the most important Spark design tensions is this:

- what is convenient for the current writer may be expensive for every later reader

Good engineers make that trade-off explicit.

They ask whether the pipeline is optimizing for:

- raw write throughput
- downstream query efficiency
- bounded replay behavior
- stable warehouse or BI ingestion

These goals do not always point to the same physical layout.

## Common Mistakes

### Mistake 1: Writing Huge Numbers Of Tiny Files

This hurts downstream reads and metadata overhead.

### Mistake 2: Partitioning Output By The Wrong Key

This can make common consumer access patterns expensive.

### Mistake 3: Treating Write Mode As A Minor Parameter

Append, overwrite, and incremental patterns have different correctness implications.

### Mistake 4: Reading More Than The Job Needs

Many expensive pipelines begin with a careless read shape that brings in more history, more columns, or more small files than necessary.

## Practical Review Questions

1. Are we reading only the needed time window and columns?
2. Is schema being stabilized before important joins and writes?
3. Does write mode match the intended correctness behavior?
4. Will this output shape be healthy for the next major consumer?
5. How will a replay of 30 days behave against this layout?

## Good Strategy

- design reads and writes around real access patterns
- treat file and partition layout as a platform concern
- write outputs for downstream efficiency, not only for immediate job success
- review read and write behavior together, because one job's output becomes the next job's input

## Key Architectural Takeaway

In Spark, how data is written is part of the architecture, because today's output layout becomes tomorrow's input cost.