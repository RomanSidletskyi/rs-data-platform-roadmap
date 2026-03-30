CREATE OR REPLACE STORAGE INTEGRATION partner_raw_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = (
    's3://company-raw/orders/',
    's3://company-raw/shipments/',
    's3://company-raw/refunds/'
  );

CREATE OR REPLACE STAGE orders_stage
  URL = 's3://company-raw/orders/'
  STORAGE_INTEGRATION = partner_raw_int;

CREATE OR REPLACE STAGE shipments_stage
  URL = 's3://company-raw/shipments/'
  STORAGE_INTEGRATION = partner_raw_int;

CREATE OR REPLACE FILE FORMAT ff_orders_parquet
  TYPE = PARQUET;

CREATE OR REPLACE FILE FORMAT ff_shipments_json
  TYPE = JSON;

CREATE OR REPLACE EXTERNAL TABLE ext_raw.shipments_json (
  shipment_date DATE AS TO_DATE(REGEXP_SUBSTR(METADATA$FILENAME, 'dt=([0-9-]+)', 1, 1, 'e', 1)),
  shipment_id STRING AS (VALUE:shipment_id::STRING),
  order_id STRING AS (VALUE:order_id::STRING),
  shipment_status STRING AS (VALUE:status::STRING),
  carrier STRING AS (VALUE:carrier::STRING),
  shipped_ts TIMESTAMP_NTZ AS (VALUE:shipped_ts::TIMESTAMP_NTZ)
)
WITH LOCATION = @shipments_stage
FILE_FORMAT = (FORMAT_NAME = ff_shipments_json)
PATTERN = '.*[.]json';

SELECT
  shipment_date,
  COUNT(*) AS rows_cnt,
  COUNT(DISTINCT METADATA$FILENAME) AS files_cnt,
  COUNT_IF(order_id IS NULL) AS missing_order_id_cnt
FROM ext_raw.shipments_json
GROUP BY shipment_date
ORDER BY shipment_date;