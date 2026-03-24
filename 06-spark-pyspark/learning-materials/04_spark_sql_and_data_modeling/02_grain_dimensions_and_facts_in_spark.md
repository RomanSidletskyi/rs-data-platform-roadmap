# Grain, Dimensions, And Facts In Spark

## Why This Topic Matters

Spark can process massive data volumes, but scale does not remove the need for sound modeling.

If a team does not understand grain, dimensions, and facts, they can build fast pipelines that still produce confusing, duplicate-heavy, or misleading outputs.

This topic matters because Spark is often used to create analytical layers, and analytical layers live or die by model clarity.

## Start With Grain

Grain means the semantic unit of one row.

Examples:

- one row per order
- one row per order line
- one row per customer per day
- one row per device event

If the grain is unclear, everything downstream becomes risky:

- joins
- aggregations
- duplicate handling
- KPI definitions

## Facts And Dimensions

At a useful practical level:

- facts capture measurable business activity
- dimensions provide descriptive context

Examples:

- `fact_orders`
- `fact_payments`
- `dim_product`
- `dim_country`
- `dim_customer`

This language still matters in Spark because the modeling problem remains the same even if the compute engine is different.

## Real Example

Suppose a team builds a curated sales dataset in Spark.

They read:

- raw orders
- raw order lines
- product reference data
- country mapping data

If they accidentally mix order-level and order-line-level metrics in one output without defining grain clearly, they may produce:

- duplicated revenue
- inconsistent counts
- unclear consumer semantics

Spark did not cause that problem.

Weak modeling did.

## Real PySpark Example

```python
from pyspark.sql import functions as F

fact_order_lines = spark.read.parquet("/lake/silver/order_lines")
dim_product = spark.read.parquet("/lake/silver/products").select("product_id", "category_name")

sales_by_category = (
	fact_order_lines
	.join(dim_product, on="product_id", how="left")
	.groupBy("event_date", "category_name")
	.agg(F.sum("line_net_amount").alias("revenue"))
)
```

Why this example helps:

- the fact grain is one row per order line
- the dimension adds descriptive context without changing the intended grain of the fact before aggregation
- the final output grain becomes one row per `event_date` and `category_name`

## Why This Matters Architecturally

Grain affects much more than query correctness.

It also affects:

- output size
- join cost
- consumer usability
- replay complexity
- alignment with downstream semantic models

For example, if a support dashboard needs order-level status but the Spark layer only publishes line-level outputs, every consumer may need expensive and inconsistent regrouping.

That is a platform design failure, not just a modeling inconvenience.

## Common Mistakes

### Mistake 1: Building Wide Curated Tables Without Defining Grain First

This creates outputs that look rich but behave unpredictably.

### Mistake 2: Joining Dimensions Without Verifying Key Semantics

If dimension keys are duplicated or stale, enrichment can silently distort facts.

### Mistake 3: Designing Models Only Around Source Systems

Source structure matters, but curated models should be shaped by business consumption needs as well.

## Good Strategy

- declare grain explicitly in every important model
- separate fact-like and dimension-like responsibilities clearly
- design curated outputs around stable business questions, not only source-system tables
- review join semantics as part of data-model design

## Key Architectural Takeaway

Spark scales execution, but it does not replace data modeling. Grain clarity remains one of the main controls for correctness, performance, and usability.