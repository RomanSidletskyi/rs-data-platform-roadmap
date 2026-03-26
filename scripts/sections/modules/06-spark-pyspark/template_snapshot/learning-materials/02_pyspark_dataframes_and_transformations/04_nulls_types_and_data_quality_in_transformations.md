# Nulls, Types, And Data Quality In Transformations

## Why This Topic Matters

Many Spark failures are not infrastructure failures.

They are data-shape failures:

- unexpected nulls
- wrong types
- inconsistent categorical values
- malformed timestamps

If these problems are ignored, the pipeline may technically run while still producing misleading outputs.

## Null Handling

Nulls are normal in real data.

What matters is whether they are expected and handled intentionally.

Examples:

- missing shipment date before dispatch is normal
- missing order ID in an order fact is usually not normal

This means null handling is not only a technical concern. It is part of domain interpretation.

That is why strong pipelines do not ask only "is this value null?"

They ask:

- is this null acceptable for the business state?
- should it be preserved, defaulted, quarantined, or treated as a broken record?

## Type Discipline

Type issues create subtle problems.

Examples:

- numeric values stored as strings
- timestamps left as raw text
- booleans encoded as free-form strings

These issues affect:

- aggregations
- filters
- joins
- downstream storage consistency

They also affect whether downstream consumers are even talking about the same business meaning.

## Data Quality Inside Transformation Layers

A healthy Spark transformation layer should do more than move data.

It should also:

- normalize key fields
- surface broken records
- distinguish recoverable bad data from fatal pipeline errors
- produce trustworthy outputs for downstream systems

In a mature platform, this often means transformation layers are part validation layer and part modeling layer.

## Example

Suppose a payments dataset has:

- `amount` as string in some files
- `currency` missing in 3% of records
- timestamps in mixed formats

A weak pipeline may still write output.

A strong pipeline will explicitly standardize types, decide how to handle bad rows, and document the trade-offs.

Another realistic example:

- `refund_flag` is encoded as `Y`, `N`, `true`, `false`, and blank across different sources
- a naive transformation may still run
- but downstream metrics become inconsistent because one layer interpreted the field differently from another

This is why type discipline is also semantics discipline.

## Real PySpark Example

```python
from pyspark.sql import functions as F

payments = (
	spark.read.json("/lake/bronze/payments")
	.withColumn("amount", F.col("amount").cast("decimal(12,2)"))
	.withColumn("payment_time", F.to_timestamp("payment_time"))
	.withColumn("refund_flag", F.upper(F.trim(F.col("refund_flag"))))
	.withColumn(
		"refund_flag_normalized",
		F.when(F.col("refund_flag").isin("Y", "TRUE"), F.lit(True))
		 .when(F.col("refund_flag").isin("N", "FALSE"), F.lit(False))
		 .otherwise(F.lit(None).cast("boolean"))
	)
)
```

## What This Code Is Doing

- casting `amount` before aggregates depend on it
- converting time text into timestamp semantics once, centrally
- normalizing a messy source flag into a consistent boolean-like field
- making bad or ambiguous values visible instead of silently inventing a fake answer

That is what data quality inside a transformation layer should look like in practice.

## Practical Quality Questions

1. Which nulls are valid business states and which are quality failures?
2. Which fields must be strongly typed before any join or aggregation?
3. Should bad records be quarantined, defaulted, or fail the pipeline?
4. Which data-quality rules belong in bronze, silver, or gold layers?
5. What do downstream consumers need to know about imperfect but accepted data?

These questions help connect low-level cleanup to platform trust.

## Common Mistakes

### Mistake 1: Treating All Nulls As The Same

Some nulls are acceptable business states. Others signal broken records.

### Mistake 2: Letting Type Inference Decide Everything

Inconsistent raw inputs can make inference unstable.

### Mistake 3: Hiding Bad Records Instead Of Surfacing Them

This creates silent downstream mistrust.

### Mistake 4: Applying Defaults Without Explaining Business Meaning

Replacing a null with a default may be correct, misleading, or dangerous depending on the domain.

## Good Strategy

- make null and type handling explicit
- connect validation rules to domain meaning
- treat transformation quality as part of architecture, not as cleanup afterthought
- surface imperfect data intentionally instead of letting ambiguity spread silently

## Key Architectural Takeaway

Reliable Spark pipelines depend not only on distributed execution, but also on disciplined handling of nulls, types, and data-quality edge cases.