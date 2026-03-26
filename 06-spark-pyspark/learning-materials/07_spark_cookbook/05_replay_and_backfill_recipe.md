# Replay And Backfill Recipe

## Why This Recipe Exists

Spark is often used to rebuild or backfill curated datasets from raw history.

This recipe is about how to think through replay and backfill work before runtime, cost, and output correctness become a surprise.

## Use This Recipe When

- rebuilding a curated table from raw layers
- rerunning a date window after logic fixes
- onboarding a new downstream output from historical data
- recovering from a bad incremental publish that corrupted consumer-facing partitions
- validating whether a replay path should reuse the live job or run through a safer isolated workflow

## Decision Questions

1. What is the authoritative raw or bronze input for the rebuild?
2. Does the output layout support efficient backfills?
3. Will historical schema versions still parse correctly?
4. Is the backfill path materially heavier than the daily path?
5. How will downstream consumers know when rebuilt outputs are ready?
6. Will the rebuilt output replace in place, publish beside the old output, or require a cutover step?
7. What validations prove that the replay corrected the problem rather than reproducing it?

## Practical Replay Sequence

1. define the exact affected business window
2. verify that authoritative historical input still exists and is trustworthy
3. inspect whether schema or layout changed across that historical period
4. estimate whether the replay path is broader or more shuffle-heavy than normal daily operation
5. rebuild into an isolated destination when risk is non-trivial
6. compare key metrics before consumer cutover

This matters because replay work is often treated as an oversized normal run.

That is a dangerous simplification.

## Real Example

Scenario:

- a revenue categorization bug affected three weeks of curated output
- the raw landed history is still available
- the Spark job must recompute only the impacted window

Healthy reasoning:

- identify the exact window
- verify input schema compatibility
- rebuild into isolated output first if risk is non-trivial
- cut over only after validation

Another realistic example:

- a silver customer-history model used a wrong deduplication rule for ten days
- a gold customer-value mart downstream inherited the mistake

Healthy replay thinking is not only about recomputing the silver layer.

It must also answer:

- which downstream layers depend on it
- whether consumer-facing snapshots need republish sequencing
- whether historical semantics changed, not only row counts

## Real PySpark Example

```python
from pyspark.sql import functions as F

silver_orders = (
	spark.read.parquet("/lake/bronze/orders")
	.filter(
		(F.col("event_date") >= F.lit("2026-03-01")) &
		(F.col("event_date") <= F.lit("2026-03-21"))
	)
	.withColumn("net_amount", F.col("gross_amount") - F.col("discount_amount"))
	.select("event_date", "order_id", "customer_id", "net_amount", "order_status")
)

(silver_orders
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/rebuild/silver_orders_2026_03_fix")
)
```

## Why This Code Is Safer Than Writing In Place Immediately

- the replay window is explicit
- the corrected business logic is visible in the code
- the rebuilt output is isolated from the trusted consumer path
- validation can happen before cutover

## Follow-Up Validation Example

```python
rebuilt = spark.read.parquet("/lake/rebuild/silver_orders_2026_03_fix")

validation = (
	rebuilt
	.groupBy("event_date")
	.agg(
		F.countDistinct("order_id").alias("orders_cnt"),
		F.sum("net_amount").alias("net_revenue")
	)
	.orderBy("event_date")
)
```

This validation block matters because many replay failures are semantic, not technical.

## Useful Validation Checks

- row counts by partition or date
- distinct business keys before and after rebuild
- a few domain-specific KPI comparisons
- schema and null-rate checks
- spot checks for the exact bug that triggered the replay

These checks are important because a replay can be technically successful while still producing the wrong business output.

## Common Anti-Patterns

- treating backfill as just a larger normal run
- forgetting that historical file layout and schemas may differ
- rebuilding directly into consumer-facing outputs without validation
- forgetting that downstream marts may require their own replay or refresh order
- declaring replay complete after technical success without business verification

## When Replay Should Not Reuse The Live Path Blindly

Be cautious when:

- the replay window is much larger than normal daily processing
- the input schemas evolved several times historically
- live traffic and replay traffic would compete for the same resources
- the output is trusted by finance, compliance, or externally visible reporting

In these cases, a separate backfill path is often healthier than pretending the steady-state job is sufficient for recovery.

## Architectural Takeaway

Backfill design is where storage layout, execution cost, and output-governance discipline all meet.