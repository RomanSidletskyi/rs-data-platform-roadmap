# SCD Patterns And History Design

## Why This Topic Matters

Many curated data platforms need history-aware dimensions.

Product categories change.

Customer attributes change.

Organizational mappings change.

Spark is often used to build and maintain that historical structure at scale.

## What SCD Thinking Solves

Slowly changing dimension thinking helps answer questions like:

- should analytics reflect the latest attribute value or the value at the time of the event?
- do we need full historical traceability?
- can downstream consumers rely on one current record per business key?

These are business semantics questions expressed through data-model design.

## Practical Pattern Types

At a simplified level:

- current-state pattern keeps only the latest value
- history-preserving pattern keeps multiple versions over time

Different organizations may use more detailed SCD naming, but the main architecture decision is simpler:

- do we need current truth, historical truth, or both?

That question is more important than memorizing a label for the pattern.

## Real Example

Suppose a product belonged to category `A` last month and category `B` now.

If a finance report for last month should still show category `A`, then a current-state-only dimension may be insufficient.

If a support dashboard only needs the latest category, then full historical complexity may be unnecessary.

Spark does not answer that for you.

The model owner must.

Another realistic example:

- a customer's risk segment changes this week
- a support dashboard wants the latest segment now
- a retrospective performance model wants the segment that was valid when each event happened

Those are two valid consumer needs, but they are not the same need.

## Real PySpark Example

```python
from pyspark.sql import Window, functions as F

customer_history = spark.read.parquet("/lake/silver/customer_segments_history")

latest_window = Window.partitionBy("customer_id").orderBy(F.col("valid_from").desc())

current_customer_segment = (
	customer_history
	.withColumn("row_num", F.row_number().over(latest_window))
	.filter(F.col("row_num") == 1)
	.select("customer_id", "segment", "valid_from")
)
```

This produces a current-state view from a history-preserving source.

That is often healthier than forcing one dataset to act as both current truth and full history without clear rules.

## Why This Matters In Spark

History design affects:

- join logic
- output size
- incremental update behavior
- downstream semantic interpretation

If a team adds history without clear consumer need, models become more complex than necessary.

If a team ignores history when it matters, analytics become misleading.

## Design Questions Before Choosing A History Pattern

1. Which consumers need latest truth versus event-time truth?
2. Does the dimension change often enough to justify extra complexity?
3. Will a current-only model silently distort retrospective metrics?
4. Should the platform publish both a current-state and a history-preserving version?

These questions help keep SCD design grounded in business semantics instead of technical habit.

## Common Mistakes

### Mistake 1: Adding Historical Logic By Habit

Not every dimension requires versioned history.

### Mistake 2: Keeping Only Current State When Historical Truth Matters

This creates silent metric distortion in retrospective analysis.

### Mistake 3: Failing To Separate Current And Historical Consumer Needs

Some consumers want simplicity. Others need traceability. One model may not serve both equally well.

### Mistake 4: Turning History Design Into Purely Technical Debate

The main issue is not merge syntax. The main issue is what truth consumers expect over time.

## Good Strategy

- decide explicitly whether the dimension is current-state, historical, or dual-purpose
- align history rules with actual analytical and operational use cases
- treat SCD design as a semantics decision before it becomes an implementation pattern
- be willing to publish different layers when current-state and historical needs genuinely diverge

## Key Architectural Takeaway

History design in Spark is not primarily about mastering one merge pattern. It is about deciding what truth over time the platform must preserve.