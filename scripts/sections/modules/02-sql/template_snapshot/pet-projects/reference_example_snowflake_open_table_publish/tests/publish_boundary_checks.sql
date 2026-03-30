SELECT
  COUNT(*) AS publish_rows,
  COUNT(DISTINCT order_id) AS distinct_orders,
  COUNT_IF(order_id IS NULL) AS null_order_id_cnt
FROM publish.finance_orders_daily;

SELECT
  COUNT(*) AS raw_rows,
  COUNT(DISTINCT order_id) AS raw_distinct_orders
FROM raw.orders_raw;

SELECT
  COUNT(*) AS unexpected_negative_net_amount_cnt
FROM publish.finance_orders_daily
WHERE net_amount < 0;

SELECT
  order_id,
  COUNT(*) AS duplicate_publish_rows
FROM publish.finance_orders_daily
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
  COUNT(*) AS overly_internal_columns_cnt
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'PUBLISH'
  AND TABLE_NAME = 'FINANCE_ORDERS_DAILY'
  AND COLUMN_NAME IN ('SRC_FILENAME', 'ROW_NUMBER_RANK', 'DEDUP_VERSION');