# 06 Snowflake Open Table And Refresh Solution

## Task 1 — Choose Native Table vs Snowflake-managed Iceberg

Recommended answer: Snowflake-managed Iceberg.

- the dataset is a durable curated contract
- a second engine really needs the same table
- Snowflake can stay the main publish control plane
- open-table semantics reduce the need for duplicate publish pipelines
- the use case is shared serving, not only warehouse-internal transformation

Answer would change if:

- Snowflake were the only real consumer
- or the table were a temporary internal mart with no external contract value

## Task 2 — Design A Snowflake-managed Iceberg Table

```sql
CREATE OR REPLACE ICEBERG TABLE publish.finance_orders_daily (
  order_id NUMBER,
  customer_id NUMBER,
  order_date DATE,
  net_amount NUMBER(18,2),
  gross_amount NUMBER(18,2),
  currency STRING,
  load_ts TIMESTAMP_NTZ
)
  EXTERNAL_VOLUME = 'lakehouse_ext_vol'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'publish/finance_orders_daily';
```

Key point: this table is a consumer contract. Schema changes here should be treated as publish changes, not casual model edits.

## Task 3 — Choose Dynamic Tables vs Tasks

Scenario A: dynamic table.

Scenario B: tasks.

Reasoning: dynamic tables are strongest when the output is another table with a freshness target. Tasks are stronger when the workflow is procedural, branching, or has side effects beyond maintaining a table result.

## Task 4 — Create A Dynamic Table For Daily Revenue

```sql
CREATE OR REPLACE DYNAMIC TABLE mart_revenue_hourly
  TARGET_LAG = '15 minutes'
  WAREHOUSE = serving_wh
AS
SELECT
  DATE_TRUNC('hour', order_ts) AS revenue_hour,
  SUM(amount) AS revenue
FROM stg_orders_clean
GROUP BY DATE_TRUNC('hour', order_ts);
```

Key point: the transformation is table-shaped, aggregation logic is clear, and the business need can plausibly map to a 15-minute freshness promise.

## Task 5 — Separate Exploration Layer From Publish Layer

One strong flow:

1. partner files land in S3
2. Snowflake external table exposes them for immediate profiling
3. `COPY INTO` loads validated rows into `raw.orders_raw`
4. staging logic standardizes types and deduplicates orders
5. intermediate logic computes stable business facts
6. publish layer writes curated contract tables for consumers

Layer meaning:

- external table = exploratory boundary
- native raw table = operational warehouse ingestion boundary
- curated publish table = contract boundary

Anti-pattern avoided:

- using unstable raw files as the long-term business serving layer

## Task 6 — Set Freshness By Business Need

One strong answer:

- `stg_orders_clean` -> 5 minutes
- `int_customer_daily_metrics` -> 15 minutes
- `mart_finance_monthly_rollup` -> 24 hours

Reasoning: closer-to-source quality and dedup layers often need tighter freshness, while heavy aggregates should only be as fresh as real consumer need justifies.