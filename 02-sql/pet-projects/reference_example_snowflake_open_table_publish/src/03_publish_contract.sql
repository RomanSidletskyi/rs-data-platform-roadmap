CREATE OR REPLACE EXTERNAL VOLUME lakehouse_ext_vol
  STORAGE_LOCATIONS = (
    (
      NAME = 'main'
      STORAGE_PROVIDER = 'S3'
      STORAGE_BASE_URL = 's3://company-lakehouse/'
      STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/snowflake-iceberg-role'
      STORAGE_AWS_EXTERNAL_ID = 'company-snowflake-prod'
    )
  );

CREATE OR REPLACE ICEBERG TABLE publish.finance_orders_daily (
  order_id STRING,
  customer_id STRING,
  order_date DATE,
  order_status STRING,
  gross_amount NUMBER(18,2),
  refund_amount NUMBER(18,2),
  net_amount NUMBER(18,2),
  shipment_status STRING,
  load_ts TIMESTAMP_NTZ
)
  EXTERNAL_VOLUME = 'lakehouse_ext_vol'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'publish/finance_orders_daily';

INSERT OVERWRITE INTO publish.finance_orders_daily
SELECT
  o.order_id,
  o.customer_id,
  o.order_date,
  o.order_status,
  o.gross_amount,
  COALESCE(r.refund_amount, 0) AS refund_amount,
  o.gross_amount - COALESCE(r.refund_amount, 0) AS net_amount,
  s.shipment_status,
  CURRENT_TIMESTAMP() AS load_ts
FROM stg.orders_publish_ready AS o
LEFT JOIN (
  SELECT
    order_id,
    SUM(refund_amount) AS refund_amount
  FROM finance.refunds_curated
  GROUP BY order_id
) AS r
  ON r.order_id = o.order_id
LEFT JOIN (
  SELECT
    order_id,
    shipment_status
  FROM ext_raw.shipments_json
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY order_id
    ORDER BY shipped_ts DESC, METADATA$FILENAME DESC
  ) = 1
) AS s
  ON s.order_id = o.order_id;