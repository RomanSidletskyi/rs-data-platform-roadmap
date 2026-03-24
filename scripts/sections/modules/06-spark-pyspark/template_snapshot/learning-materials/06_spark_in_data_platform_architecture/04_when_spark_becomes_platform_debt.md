# When Spark Becomes Platform Debt

## Why This Topic Matters

Spark is powerful, but any powerful layer can become technical debt when used without discipline.

Architects need to recognize when Spark is still solving real problems and when it has become an expensive default.

## Warning Signs

Spark may be becoming platform debt when:

- small workloads are forced through it without justification
- core business logic is duplicated across Spark and other tools
- jobs exist mainly because earlier design decisions were never cleaned up
- the team cannot explain why a dataset is computed in Spark rather than elsewhere
- operational ownership is vague and incident response depends on a few individuals
- consumer-facing semantics are duplicated across Spark and warehouse layers

## Real Example

Suppose a platform has:

- one warehouse that already models most curated data
- a Spark layer that rebuilds similar transformations daily
- several outputs that no longer need distributed computation

Spark may still function technically.

But architecturally it may now be a redundant layer adding cost and operational burden.

Another realistic pattern:

- a team first used Spark for large raw JSON normalization
- later they also used Spark for tiny curated marts, CSV exports, and warehouse-adjacent SQL-style transforms
- after a year, Spark owns work of wildly different shapes with no clear boundary

At that point the problem is not Spark itself.

The problem is that the platform stopped asking what Spark should own.

## Practical Contrast Example

Weak Spark-by-default path:

```python
tiny_export = (
	spark.read.parquet("/warehouse_exports/customer_daily_value")
	.select("customer_id", "net_value")
)
```

If the dataset is already small and warehouse-curated, this may be unnecessary Spark usage.

Spark-justified path:

```python
large_clickstream = spark.read.json("/lake/bronze/clickstream/2026-03-24/*")

session_metrics = large_clickstream.groupBy("session_id").count()
```

This second example is much easier to justify because the workload is file-oriented, large, and naturally distributed.

## Another Common Debt Pattern

A team introduces Spark for a large ingestion need.

Later, every new transformation is added there by default, including tiny jobs that would be simpler in warehouse SQL or a small Python service.

The result is tool sprawl disguised as standardization.

## Practical Consequences Of Spark Debt

When Spark becomes debt, teams often experience:

- duplicated modeling logic across layers
- expensive incident handling because ownership is ambiguous
- difficulty deciding where to fix bugs because too many systems transform the same entity
- slow onboarding because new engineers cannot tell where platform truth is produced

These are architecture problems wearing operational clothes.

## Common Mistakes

### Mistake 1: Treating Existing Spark Usage As Its Own Justification

Legacy presence is not a design argument.

### Mistake 2: Avoiding Boundary Reassessment

Platforms evolve. The right place for a transformation may change over time.

### Mistake 3: Measuring Success Only By Job Completion

Architectural health also includes complexity, ownership, cost, and consumer clarity.

### Mistake 4: Assuming Centralization Always Means Simplification

Sometimes pushing more work into Spark creates one large ambiguous layer instead of one clear platform standard.

## Questions To Reassess Boundary Health

- which workloads genuinely need distributed compute?
- which outputs could move cleanly to warehouse-native modeling?
- are there consumer-facing tables whose semantics are defined in multiple layers?
- is Spark still the best place for this class of transformation today, not two years ago?

These questions should appear in platform review, not only in incident retrospectives.

## Good Strategy

- reassess whether Spark still earns its place for each major workload class
- remove or avoid duplicate transformation layers where possible
- use Spark intentionally, not ceremonially
- define workload classes that clearly belong in Spark versus elsewhere
- treat de-scoping unnecessary Spark jobs as architecture improvement, not as regression

## Key Architectural Takeaway

Spark becomes debt when it is kept by inertia instead of by clear architectural need.