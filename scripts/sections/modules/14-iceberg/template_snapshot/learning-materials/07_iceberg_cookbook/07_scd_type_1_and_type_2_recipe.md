# SCD Type 1 And Type 2 Recipe

## Goal

Show how to implement Slowly Changing Dimension patterns on Iceberg with Spark without reducing the topic to buzzwords.

This recipe covers:

- when SCD Type 1 is enough
- when SCD Type 2 is required
- how Spark staging and `MERGE` patterns differ
- why Iceberg helps operationally but does not replace dimensional modeling decisions

## 1. First Decision: Do You Need Current Truth Or Full History

Before choosing table design, ask:

1. Do consumers only need the latest known dimension state?
2. Do consumers need to answer historical questions like “what was true at that date”?
3. Is history a business requirement or only a technical convenience?

If only the latest state matters, Type 1 is usually enough.

If historical validity matters, Type 2 is usually required.

## 2. SCD Type 1 Mental Model

Type 1 means:

- one current row per business key
- old values are overwritten logically
- the table represents latest truth, not history

Typical use cases:

- customer profile serving
- current product attributes
- current merchant settings

## 3. Representative Type 1 Table

```sql
CREATE TABLE IF NOT EXISTS glue_prod.analytics.dim_customer_current (
  customer_id BIGINT,
  customer_name STRING,
  customer_tier STRING,
  country_code STRING,
  updated_at TIMESTAMP,
  source_event_ts TIMESTAMP
)
USING iceberg
TBLPROPERTIES (
  'format-version'='2'
);
```

Why this shape is simple:

- one row per business key
- no validity range columns
- consumers read current state directly

## 4. Type 1 Staging Pattern

Never `MERGE` noisy CDC directly if the source can emit duplicates for the same key in one batch.

Deduplicate the staging feed first.

Representative Spark step:

```python
from pyspark.sql import Window
from pyspark.sql import functions as F


window_spec = Window.partitionBy("customer_id").orderBy(F.col("event_ts").desc())

latest_customer_updates = (
    spark.read.table("glue_prod.stage.customer_cdc")
    .filter("op IN ('I', 'U')")
    .withColumn("row_rank", F.row_number().over(window_spec))
    .filter("row_rank = 1")
    .drop("row_rank")
)

latest_customer_updates.createOrReplaceTempView("latest_customer_updates")
```

## 5. Type 1 Merge Pattern

```sql
MERGE INTO glue_prod.analytics.dim_customer_current AS target
USING latest_customer_updates AS source
ON target.customer_id = source.customer_id
WHEN MATCHED THEN UPDATE SET
  target.customer_name = source.customer_name,
  target.customer_tier = source.customer_tier,
  target.country_code = source.country_code,
  target.updated_at = current_timestamp(),
  target.source_event_ts = source.event_ts
WHEN NOT MATCHED THEN INSERT (
  customer_id,
  customer_name,
  customer_tier,
  country_code,
  updated_at,
  source_event_ts
) VALUES (
  source.customer_id,
  source.customer_name,
  source.customer_tier,
  source.country_code,
  current_timestamp(),
  source.event_ts
);
```

What this means semantically:

- current row is replaced with newer truth
- old value history is not preserved in the table itself

## 6. When Type 1 Is The Right Choice

Use Type 1 when:

- downstream queries care about now
- historical attribute history is not a contractual requirement
- simplicity and serving speed matter more than audit reconstruction inside the dimension table

Architect warning:

Time travel in Iceberg is not the same thing as a proper Type 2 business history model.

Time travel helps with technical rollback and investigation.

Type 2 models business-valid history intentionally.

## 7. SCD Type 2 Mental Model

Type 2 means:

- multiple rows can exist for the same business key
- each row covers a validity interval
- current row is marked explicitly
- old rows remain queryable as historical truth

Typical use cases:

- customer segmentation history
- account ownership history
- product pricing or category history
- compliance and audit-oriented dimensional models

## 8. Representative Type 2 Table

```sql
CREATE TABLE IF NOT EXISTS glue_prod.analytics.dim_customer_history (
  customer_sk BIGINT,
  customer_id BIGINT,
  customer_name STRING,
  customer_tier STRING,
  country_code STRING,
  valid_from_ts TIMESTAMP,
  valid_to_ts TIMESTAMP,
  is_current BOOLEAN,
  source_event_ts TIMESTAMP
)
USING iceberg
PARTITIONED BY (days(valid_from_ts))
TBLPROPERTIES (
  'format-version'='2'
);
```

Important design point:

- `customer_id` is the business key
- `customer_sk` is the dimensional surrogate key
- validity columns define the history model

## 9. Type 2 Change Detection Pattern

Before writing history rows, isolate only rows that actually changed.

Representative Spark comparison pattern:

```python
current_dim_df = (
    spark.read.table("glue_prod.analytics.dim_customer_history")
    .filter("is_current = true")
    .select(
        "customer_id",
        "customer_name",
        "customer_tier",
        "country_code"
    )
)

incoming_df = (
    spark.read.table("glue_prod.stage.customer_snapshot")
    .select(
        "customer_id",
        "customer_name",
        "customer_tier",
        "country_code",
        "event_ts"
    )
)

changed_rows_df = (
    incoming_df.alias("source")
    .join(current_dim_df.alias("target"), on="customer_id", how="left")
    .filter(
        "target.customer_id IS NULL OR "
        "source.customer_name <> target.customer_name OR "
        "source.customer_tier <> target.customer_tier OR "
        "source.country_code <> target.country_code"
    )
)

changed_rows_df.createOrReplaceTempView("changed_customer_rows")
```

The purpose is simple:

- do not create new history rows when nothing changed

## 10. Type 2 Operational Flow

The standard Type 2 flow is:

1. detect changed business keys
2. close currently active row for those keys
3. insert new current row version

That usually means two logical write steps.

## 11. Type 2 Step A: Close Old Current Rows

```sql
MERGE INTO glue_prod.analytics.dim_customer_history AS target
USING changed_customer_rows AS source
ON target.customer_id = source.customer_id
AND target.is_current = true
WHEN MATCHED THEN UPDATE SET
  target.valid_to_ts = source.event_ts,
  target.is_current = false;
```

This does not create the new version yet.

It only expires the previously current row.

## 12. Type 2 Step B: Insert New Current Rows

```sql
INSERT INTO glue_prod.analytics.dim_customer_history (
  customer_sk,
  customer_id,
  customer_name,
  customer_tier,
  country_code,
  valid_from_ts,
  valid_to_ts,
  is_current,
  source_event_ts
)
SELECT
  xxhash64(customer_id, event_ts) AS customer_sk,
  customer_id,
  customer_name,
  customer_tier,
  country_code,
  event_ts AS valid_from_ts,
  TIMESTAMP '9999-12-31 00:00:00' AS valid_to_ts,
  true AS is_current,
  event_ts AS source_event_ts
FROM changed_customer_rows;
```

This split pattern is often easier to reason about than forcing all Type 2 logic into one giant `MERGE`.

## 13. Type 2 Query Pattern

Current-state read:

```sql
SELECT *
FROM glue_prod.analytics.dim_customer_history
WHERE is_current = true;
```

As-of business-time read:

```sql
SELECT *
FROM glue_prod.analytics.dim_customer_history
WHERE customer_id = 1001
  AND TIMESTAMP '2026-03-15 12:00:00' >= valid_from_ts
  AND TIMESTAMP '2026-03-15 12:00:00' < valid_to_ts;
```

This is why Type 2 is a modeling pattern, not only a storage feature.

## 14. Type 1 Versus Type 2 In One Table

```text
Question / Need                         Type 1                                 Type 2
------------------------------------    -------------------------------------  ---------------------------------------------
Latest state only                       Strong fit                              Possible but unnecessarily complex
Business-valid history                  No                                      Yes
Simple serving table                    Yes                                     Heavier for consumers
Audit-style dimensional history         Weak fit                                Strong fit
Write complexity                        Lower                                   Higher
Storage footprint                       Lower                                   Higher
```

## 15. Iceberg-Specific Benefits

Iceberg helps SCD pipelines because it gives you:

- snapshot isolation during writes
- atomic commit behavior
- time travel for debugging
- scalable metadata over large file sets
- `MERGE`, `DELETE`, and overwrite-friendly engine integrations where supported

But Iceberg does not decide your history policy for you.

That is still a dimensional-modeling decision.

## 16. Common Mistakes

1. using Type 2 when nobody needs history
2. using Type 1 and pretending time travel replaces business history
3. not deduplicating source changes before mutation
4. not separating business key from surrogate key in Type 2 design
5. letting multiple current rows exist for one business key

## 17. Recommended Architecture Pattern

For many real platforms, the clean layout is:

1. raw CDC or snapshot staging table
2. current-state dimension table with Type 1 semantics when serving needs are simple
3. separate Type 2 history table only where business history is genuinely required

That keeps expensive historical modeling targeted to domains that actually need it.

## 18. Architect Rule

Choose SCD Type 1 or Type 2 based on semantic contract, not on whether the engine happens to support `MERGE`.