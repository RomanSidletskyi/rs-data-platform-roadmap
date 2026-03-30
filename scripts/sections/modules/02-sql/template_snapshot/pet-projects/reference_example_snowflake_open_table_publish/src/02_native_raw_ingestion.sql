CREATE OR REPLACE TABLE raw.orders_raw (
  order_id STRING,
  customer_id STRING,
  order_ts TIMESTAMP_NTZ,
  order_date DATE,
  order_status STRING,
  gross_amount NUMBER(18,2),
  src_filename STRING,
  src_last_modified TIMESTAMP_NTZ,
  load_ts TIMESTAMP_NTZ,
  ingestion_batch_id STRING
);

COPY INTO raw.orders_raw
  (
    order_id,
    customer_id,
    order_ts,
    order_date,
    order_status,
    gross_amount,
    src_filename,
    src_last_modified,
    load_ts,
    ingestion_batch_id
  )
FROM (
  SELECT
    $1:order_id::STRING,
    $1:customer_id::STRING,
    $1:order_ts::TIMESTAMP_NTZ,
    $1:order_date::DATE,
    $1:order_status::STRING,
    $1:gross_amount::NUMBER(18,2),
    METADATA$FILENAME,
    METADATA$FILE_LAST_MODIFIED,
    CURRENT_TIMESTAMP(),
    TO_VARCHAR(CURRENT_DATE)
  FROM @orders_stage
)
FILE_FORMAT = (FORMAT_NAME = ff_orders_parquet)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
ON_ERROR = ABORT_STATEMENT;

CREATE OR REPLACE VIEW stg.orders_publish_ready AS
SELECT
  order_id,
  customer_id,
  order_date,
  order_status,
  gross_amount,
  src_filename,
  load_ts
FROM raw.orders_raw
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY order_id
  ORDER BY load_ts DESC, src_filename DESC
) = 1;