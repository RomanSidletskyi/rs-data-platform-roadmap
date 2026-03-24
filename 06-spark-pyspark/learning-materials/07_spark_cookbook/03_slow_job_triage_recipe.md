# Slow Job Triage Recipe

## Why This Recipe Exists

When a Spark job becomes slow, teams often react too quickly with hardware or random code changes.

This recipe gives a better triage sequence.

The goal is to turn "Spark feels slow" into a smaller set of concrete execution and architecture questions.

## Triage Sequence

1. identify the slow stage
2. ask whether the stage is wide and shuffle-heavy
3. inspect key distribution for skew
4. inspect input pruning and join order
5. inspect output layout if writing dominates late stages
6. only then decide whether resource sizing is the real issue

This order matters because it prevents the most common failure mode in Spark debugging: treating symptoms as if they were root causes.

It also gives the team a shared incident language.

Without that, every slow-job investigation becomes an improvisation.

## Real Example

Scenario:

- daily payment enrichment job suddenly doubles in runtime
- the cluster size did not change
- data volume increased because one payment partner now generates most of the traffic

Root-cause-oriented reasoning:

- this is likely not just a generic "Spark is slower"
- the pipeline may now have key skew or broader shuffles
- more executors alone may not fix the imbalance

Another useful scenario:

- a backfill job is dramatically slower than the normal daily run

This often means:

- broader historical scans
- more partitions involved
- less effective pruning
- heavier wide stages than the steady-state daily pipeline

That is not surprising. It is a clue about the architectural shape of replay workloads.

Another realistic scenario:

- a pipeline still reads the same date range as last week
- but a new enrichment join was inserted before an aggregation
- overall row count changed only slightly, yet runtime regressed sharply

This tells you the regression may be caused less by input size and more by transformation shape.

## Real PySpark Example To Investigate

```python
from pyspark.sql import functions as F

orders = spark.read.parquet("/lake/bronze/orders")
payments = spark.read.parquet("/lake/bronze/payments")

result = (
	orders
	.filter(F.col("event_date") >= F.lit("2026-03-01"))
	.join(payments, on="order_id", how="left")
	.groupBy("event_date", "payment_status")
	.agg(F.countDistinct("order_id").alias("orders_cnt"))
)
```

## How To Read This Code During Triage

- first ask whether `payments` should also be filtered before the join
- then ask whether the join introduced a wider shuffle than the previous job version
- then check whether `payment_status` created a broader aggregation stage than expected
- finally ask whether the bottleneck is the join, the aggregation, or the final write

This is the practical point: triage is not staring at code randomly. It is converting the code into a shortlist of likely expensive stages.

## Better Investigation Rewrite

```python
filtered_orders = (
	orders
	.filter(F.col("event_date") >= F.lit("2026-03-01"))
	.select("order_id", "event_date")
)

filtered_payments = (
	payments
	.filter(F.col("payment_date") >= F.lit("2026-03-01"))
	.select("order_id", "payment_status")
)

result = (
	filtered_orders
	.join(filtered_payments, on="order_id", how="left")
	.groupBy("event_date", "payment_status")
	.agg(F.countDistinct("order_id").alias("orders_cnt"))
)
```

This rewrite does not guarantee the issue is solved.

It does make the cost model easier to reason about because filtering and projection are no longer hidden inside one large expression.

## Longer Triage Scenario

Imagine this regression:

- yesterday the job took 18 minutes
- today it takes 42 minutes
- the slow stage is after a new enrichment was added
- storage and cluster size are unchanged

Stronger investigative rewrite:

```python
from pyspark.sql import functions as F

orders = (
	spark.read.parquet("/lake/bronze/orders")
	.filter(F.col("event_date").between("2026-03-01", "2026-03-07"))
	.select("order_id", "customer_id", "event_date", "net_amount")
)

payments = (
	spark.read.parquet("/lake/bronze/payments")
	.filter(F.col("payment_date").between("2026-03-01", "2026-03-07"))
	.select("order_id", "payment_status")
)

customers = (
	spark.read.parquet("/lake/silver/customers")
	.select("customer_id", "segment")
	.dropDuplicates(["customer_id"])
)

enriched = (
	orders
	.join(payments, on="order_id", how="left")
	.join(F.broadcast(customers), on="customer_id", how="left")
)

result = (
	enriched
	.groupBy("event_date", "segment", "payment_status")
	.agg(
		F.countDistinct("order_id").alias("orders_cnt"),
		F.sum("net_amount").alias("net_revenue")
	)
)
```

## How To Investigate This Version

- confirm that the new customer enrichment is truly small enough to broadcast
- check whether the payments join widened the shuffle because of duplicates or poor pruning
- inspect whether `countDistinct(order_id)` became the dominant expensive operation after the new grouping shape
- verify that the regression is in the grouped stage, not in reading or writing

This is how triage becomes specific: translate runtime pain into hypotheses tied to exact parts of the pipeline.

## Common Wrong Responses

- increase cluster size before identifying the slow stage
- rewrite code blindly without confirming the actual bottleneck
- blame Spark when the real problem is storage layout or key distribution

## Useful Investigation Questions

1. Did the runtime change because data volume changed, or because execution shape changed?
2. Is the bottleneck concentrated in one stage or spread through the job?
3. Did a new business key, partner, or data source shift the distribution?
4. Is this problem specific to backfills, or does it affect the steady-state daily path too?
5. Has output layout regressed and made late stages expensive?

Two more useful questions:

6. Did a recent schema or business-logic change alter join or aggregation shape indirectly?
7. Is the job slower because it is doing more useful work, or because it is doing the same work less efficiently?

## What Good Teams Record After Triage

- the exact regressed stage
- the class of bottleneck: scan, shuffle, skew, state, or write
- whether the issue came from data shape, model shape, or infrastructure shape
- what design change will reduce future recurrence

They should also record:

- whether the issue belongs to the steady-state design or only to replay paths
- whether consumers were affected by delay, semantics, or both

That turns triage into platform learning, not just incident closure.

## Good Response Versus Weak Response

Good response:

- identify the actual regressed stage
- classify the bottleneck type
- connect the symptom to a data, model, or storage decision
- propose a design correction, not only a bigger cluster

Weak response:

- change several configs at once
- declare the problem solved when runtime drops once
- skip documenting why the regression happened

## Architectural Takeaway

Slow-job debugging in Spark is strongest when you interpret runtime symptoms as signals about data shape, movement, and system design rather than as isolated code complaints.