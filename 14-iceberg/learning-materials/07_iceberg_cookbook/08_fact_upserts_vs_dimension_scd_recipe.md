# Fact Upserts Versus Dimension SCD Recipe

## Goal

Separate two patterns that beginners often collapse into one:

- fact-table upserts
- dimension-table SCD management

Both may use `MERGE`, but they solve different business problems and produce different table designs.

## 1. The Core Difference In One Sentence

Fact upsert answers:

- how do I keep the correct current fact record for a business event or transaction

Dimension SCD answers:

- how do I model changing descriptive attributes over time

If these two are mixed mentally, table design usually becomes confused.

## 2. What A Fact Table Represents

A fact table usually represents:

- events
- transactions
- measurements
- line items

Examples:

- orders
- payments
- shipments
- clickstream events
- invoice lines

The grain is usually tied to a business event.

## 3. What A Dimension Table Represents

A dimension table usually represents:

- descriptive context
- entities and their attributes
- business classification state

Examples:

- customer
- product
- merchant
- store
- account

The grain is usually tied to an entity, not an event.

## 4. Why Both Can Use `MERGE`

Both patterns can use `MERGE`, but for different reasons.

Fact-table upsert uses `MERGE` to:

- reconcile late-arriving or corrected event records
- deduplicate transactional state by event key or business key

Dimension SCD uses `MERGE` to:

- update current entity attributes
- close and open historical versions

Same syntax family.

Different semantic contract.

## 5. Fact Upsert Mental Model

Use fact upsert when:

- source records may be corrected or replayed
- one logical fact may arrive multiple times
- table must hold one accepted version per fact grain

Typical example:

- an order record is re-sent later with a corrected amount or status

## 6. Representative Fact Table

```sql
CREATE TABLE IF NOT EXISTS glue_prod.analytics.fct_orders (
  order_id BIGINT,
  customer_id BIGINT,
  order_ts TIMESTAMP,
  order_date DATE,
  amount DECIMAL(18,2),
  status STRING,
  source_event_ts TIMESTAMP
)
USING iceberg
PARTITIONED BY (days(order_ts))
TBLPROPERTIES (
  'format-version'='2'
);
```

This is still a fact table because each row represents an order fact, not a customer attribute version.

## 7. Representative Fact Upsert Pattern

First deduplicate the incoming feed to one latest row per fact key.

```python
from pyspark.sql import Window
from pyspark.sql import functions as F


window_spec = Window.partitionBy("order_id").orderBy(F.col("event_ts").desc())

latest_order_changes = (
    spark.read.table("glue_prod.stage.orders_cdc")
    .withColumn("row_rank", F.row_number().over(window_spec))
    .filter("row_rank = 1")
    .drop("row_rank")
)

latest_order_changes.createOrReplaceTempView("latest_order_changes")
```

Then merge into the fact table:

```sql
MERGE INTO glue_prod.analytics.fct_orders AS target
USING latest_order_changes AS source
ON target.order_id = source.order_id
WHEN MATCHED AND source.op IN ('U', 'C') THEN UPDATE SET
  target.customer_id = source.customer_id,
  target.order_ts = source.order_ts,
  target.order_date = source.order_date,
  target.amount = source.amount,
  target.status = source.status,
  target.source_event_ts = source.event_ts
WHEN MATCHED AND source.op = 'D' THEN DELETE
WHEN NOT MATCHED AND source.op IN ('I', 'U', 'C') THEN INSERT (
  order_id,
  customer_id,
  order_ts,
  order_date,
  amount,
  status,
  source_event_ts
) VALUES (
  source.order_id,
  source.customer_id,
  source.order_ts,
  source.order_date,
  source.amount,
  source.status,
  source.event_ts
);
```

Semantically, this says:

- keep the right current fact row for each order

## 8. What Makes This Different From SCD

The fact table above is not trying to preserve a timeline of order attribute versions for analytical dimension use.

It is trying to preserve the correct current state of the fact record at the chosen grain.

That is a different contract from Type 2 history.

## 9. Dimension SCD Mental Model

Dimension SCD is about evolving attributes of an entity.

Typical questions are:

- what tier did this customer have on March 15
- what category did this product belong to last quarter

That is why SCD introduces:

- validity intervals
- current flags
- potentially surrogate keys

## 10. Representative Dimension Type 2 Table

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

This is not a fact upsert table.

It is a historical entity-state table.

## 11. Fact Upsert Versus SCD In One Table

```text
Question / Need                         Fact Upsert Table                        Dimension SCD Table
------------------------------------    ---------------------------------------  ----------------------------------------------
What is the grain                       Event or transaction                     Entity attribute state
Main business question                  What is the correct fact row             What attributes were true and when
Need for validity intervals             Usually no                               Yes for Type 2
Need for surrogate key                  Usually no                               Often yes
Typical merge key                       Order ID, payment ID, shipment ID        Customer ID, product ID, account ID
History model                           Usually not Type 2-style                 Explicit Type 2 when needed
```

## 12. When To Use Fact Upserts

Use fact upserts when:

- transactional records can be replayed or corrected
- late changes must update the accepted fact record
- downstream measures should not double-count duplicate event versions

Examples:

- order amount corrected after payment reconciliation
- shipment state updated after delivery confirmation
- invoice line canceled after ingestion

## 13. When To Use Dimension SCD

Use SCD when:

- descriptive attributes change over time
- consumers need historical truth by business time
- entity state history is part of the analytical contract

Examples:

- customer moved from bronze to gold
- product moved to a new category
- merchant changed country or ownership segment

## 14. Common Anti-Patterns

1. building Type 2 logic into a fact table that only needs current transactional truth
2. storing current customer profile directly inside fact rows and expecting clean historical interpretation later
3. treating raw CDC replay as a dimensional history model
4. using one table to serve immutable event history, current state, and Type 2 history simultaneously

## 15. Recommended Architecture Pattern

In many real platforms, the clean model is:

1. append-only raw event or CDC landing table
2. curated fact table with upsert logic where needed
3. separate dimension current table or Type 2 history table depending on semantics

That separation keeps business grain explicit.

## 16. Where Iceberg Helps

Iceberg helps both patterns because it gives:

- atomic commit behavior
- mutation-aware table semantics in `v2`
- time travel for debugging and rollback
- scalable metadata for large file sets

But Iceberg does not answer the modeling question for you.

You still need to decide whether the table is a fact table or a dimension table.

## 17. Architect Rule

If the business grain is an event, think fact upsert.

If the business grain is an entity attribute state over time, think SCD.