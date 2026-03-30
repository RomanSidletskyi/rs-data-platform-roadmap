# 05 Snowflake Storage And Ingestion Solution

## Task 1 — Design A Safe External Stage

```sql
CREATE OR REPLACE STORAGE INTEGRATION raw_orders_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://company-raw/orders/');

CREATE OR REPLACE STAGE raw_orders_stage
  URL = 's3://company-raw/orders/'
  STORAGE_INTEGRATION = raw_orders_int;
```

Key point: storage integration turns bucket access into a governed platform object instead of scattering secrets through SQL definitions.

## Task 2 — Create File Formats For JSON And Parquet

```sql
CREATE OR REPLACE FILE FORMAT ff_orders_json
  TYPE = JSON;

CREATE OR REPLACE FILE FORMAT ff_orders_parquet
  TYPE = PARQUET;
```

Key point: JSON is stronger for schema drift and nested landing, while Parquet is stronger for efficient structured analytical reads.

## Task 3 — Load Raw Orders With Metadata Columns

```sql
COPY INTO raw.orders_raw
  (order_id, customer_id, order_ts, amount, src_filename, src_row_number, src_last_modified, load_ts)
FROM (
  SELECT
    $1:order_id::STRING,
    $1:customer_id::STRING,
    $1:order_ts::TIMESTAMP_NTZ,
    $1:amount::NUMBER(18,2),
    METADATA$FILENAME,
    METADATA$FILE_ROW_NUMBER,
    METADATA$FILE_LAST_MODIFIED,
    CURRENT_TIMESTAMP()
  FROM @raw_orders_stage
)
FILE_FORMAT = (FORMAT_NAME = ff_orders_json)
ON_ERROR = CONTINUE;
```

Key point: metadata columns make file lineage, duplicate investigation, and replay analysis much easier than relying only on business fields.

## Task 4 — Choose Between External Table And Native Raw Table

Recommended answer: start with an external table.

- schema is still unstable
- analysts need visibility quickly
- external tables let you inspect the feed without locking a weak schema into a native raw table
- file layout and null behavior can be profiled before formal ingestion
- once the feed stabilizes, move to `COPY INTO` and a governed raw table contract

Switch when:

- field naming stabilizes
- data quality rules are known
- downstream joins and transformations need predictable native-table behavior

## Task 5 — Query A Raw External Table By File And Date

```sql
SELECT
  order_date,
  COUNT(*) AS rows_cnt,
  COUNT(DISTINCT METADATA$FILENAME) AS files_cnt,
  COUNT_IF(order_id IS NULL) AS null_order_id_cnt,
  SUM(amount) AS gross_amount
FROM ext_raw.orders_json
GROUP BY order_date
ORDER BY order_date;
```

```sql
SELECT
  METADATA$FILENAME AS src_file,
  COUNT(*) AS rows_cnt,
  MIN(order_id) AS sample_min_order_id,
  MAX(order_id) AS sample_max_order_id
FROM ext_raw.orders_json
GROUP BY METADATA$FILENAME
ORDER BY src_file;
```

Key point: one query protects the daily business view, the other protects the operator view.

## Task 6 — Design A Raw Ingestion Table Contract

```sql
CREATE OR REPLACE TABLE raw.orders_raw (
  order_id STRING,
  customer_id STRING,
  order_ts TIMESTAMP_NTZ,
  status STRING,
  amount NUMBER(18,2),
  payload VARIANT,
  src_filename STRING,
  src_last_modified TIMESTAMP_NTZ,
  load_ts TIMESTAMP_NTZ,
  ingestion_batch_id STRING
);
```

Key point: raw tables should preserve truth and observability. Heavy business cleanup belongs later, where it can be changed without destroying replay fidelity.