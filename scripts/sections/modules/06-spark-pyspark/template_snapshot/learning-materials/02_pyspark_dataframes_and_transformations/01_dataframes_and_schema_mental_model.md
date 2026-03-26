# DataFrames And Schema Mental Model

## Why This Topic Matters

PySpark DataFrames are the main working abstraction for most Spark data engineering.

But they should not be understood as just table-shaped data in Python.

A DataFrame represents structured data plus a computation plan that Spark can optimize and execute across a distributed system.

That means a DataFrame is not only a coding object.

It is also one of the main modeling units in a Spark pipeline.

## What A DataFrame Gives You

A DataFrame gives you:

- named columns
- schema awareness
- transformation APIs
- SQL interoperability
- optimizer-friendly structure

This is why DataFrames are usually preferred over lower-level manual processing styles for most modern Spark pipelines.

They give the platform a more stable, reviewable way to express transformations than ad hoc row-by-row logic.

## Why Schema Matters

Schema is not only metadata.

It affects:

- how Spark interprets data types
- which operations are valid
- how joins and aggregations behave
- how downstream storage will represent the data

If schema is weak or inconsistent, pipelines become more fragile and harder to reason about.

It also becomes harder to trust downstream outputs because the input meaning is still unstable.

## Example

Suppose an input dataset contains:

- `order_id`
- `customer_id`
- `amount`
- `event_time`

If `amount` is parsed as string instead of numeric type, aggregations become unreliable.

If `event_time` stays as free text, time-oriented logic becomes harder and more error-prone.

So schema quality affects both correctness and architecture.

## Real PySpark Example

```python
from pyspark.sql.types import StructField, StructType, StringType, DecimalType, TimestampType

orders_schema = StructType([
	StructField("order_id", StringType(), False),
	StructField("customer_id", StringType(), True),
	StructField("amount", DecimalType(12, 2), True),
	StructField("event_time", TimestampType(), True),
])

orders = spark.read.schema(orders_schema).json("/lake/bronze/orders")
```

This code is important because it turns a vague raw input into a stable dataset contract.

- `order_id` is declared non-nullable in the intended model
- `amount` becomes numeric before downstream aggregates depend on it
- `event_time` becomes a real timestamp instead of text that every later layer must reinterpret

That is the practical meaning of schema-first thinking.

## Practical Questions To Ask Of Every Important DataFrame

1. What is one row in this dataset?
2. Which columns are business keys?
3. Which columns are source-near noise that should not leak downstream?
4. Is the schema explicit enough for stable reuse?
5. Is this DataFrame source-near, conformed, or consumer-facing?

## DataFrame Thinking Versus Row Thinking

Weak Spark learning often stays row-oriented:

- read one row
- transform one row
- think in imperative loops

Healthy Spark learning is DataFrame-oriented:

- describe column transformations
- describe filtering and grouping logic
- let Spark plan distributed execution

This shift matters because it helps the learner write pipelines that are more optimizable and easier to scale.

It also helps the learner think in terms of dataset meaning rather than only per-record manipulation.

## Another Real Example

Suppose customer-country data arrives from several systems.

If one source uses lowercase country codes, another uses nulls, and a third uses free-text labels, a DataFrame with an unstable schema is not yet a trustworthy analytical dataset.

A stronger approach is to build a conformed DataFrame that makes country semantics explicit before downstream joins and aggregations depend on it.

```python
from pyspark.sql import functions as F

conformed_customers = (
	spark.read.parquet("/lake/bronze/customers")
	.withColumn("country_code", F.upper(F.trim(F.col("country_code"))))
	.withColumn(
		"country_code",
		F.when(F.col("country_code").isin("UA", "PL", "DE"), F.col("country_code"))
		 .otherwise(F.lit("UNKNOWN"))
	)
)
```

Here the DataFrame is no longer just loaded data.

It is becoming a reusable conformed layer with clearer semantics.

## More Job-Like Example

```python
from pyspark.sql import functions as F
from pyspark.sql.types import StructField, StructType, StringType, DecimalType, TimestampType

orders_schema = StructType([
	StructField("order_id", StringType(), False),
	StructField("customer_id", StringType(), True),
	StructField("country_code", StringType(), True),
	StructField("net_amount", DecimalType(12, 2), True),
	StructField("event_time", TimestampType(), True),
])

bronze_orders = spark.read.schema(orders_schema).json("/lake/bronze/orders")

silver_orders = (
	bronze_orders
	.withColumn("country_code", F.upper(F.trim(F.col("country_code"))))
	.withColumn("event_date", F.to_date("event_time"))
	.filter(F.col("order_id").isNotNull())
	.select("event_date", "order_id", "customer_id", "country_code", "net_amount")
)

daily_country_revenue = (
	silver_orders
	.groupBy("event_date", "country_code")
	.agg(F.sum("net_amount").alias("revenue"))
)
```

## What This Example Shows

- `bronze_orders` is a source-near DataFrame with an explicit schema contract
- `silver_orders` is a conformed DataFrame with semantic cleanup and publish-oriented columns
- `daily_country_revenue` is not just another variable; it is a consumer-facing modeling unit produced from a better-defined intermediate layer

This is the practical mindset shift: a DataFrame is often a named stage in the platform, not just a temporary Python object in one script.

## Good Strategy

- think of DataFrames as structured distributed datasets, not just local Python objects
- treat schema as part of data quality and pipeline design
- prefer explicit, stable column logic over vague inferred behavior
- review DataFrames by grain and schema meaning, not only by whether the code executes

## Key Architectural Takeaway

In Spark, DataFrames are valuable because they connect structured data modeling with optimizer-aware distributed execution.