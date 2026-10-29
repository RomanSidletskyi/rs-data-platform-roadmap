CREATE BRANCH IF NOT EXISTS dev_price_fix IN lab FROM main;

USE REFERENCE dev_price_fix IN lab;

CREATE TABLE IF NOT EXISTS lab.sales.orders_fix (
  order_id STRING,
  amount DECIMAL(18,2),
  updated_at TIMESTAMP
)
USING iceberg;

INSERT INTO lab.sales.orders_fix VALUES
  ('ord-001', 25.50, TIMESTAMP '2026-03-27 10:00:00'),
  ('ord-002', 40.00, TIMESTAMP '2026-03-27 10:15:00');

SHOW REFERENCE IN lab;
LIST REFERENCES IN lab;

USE REFERENCE main IN lab;
MERGE BRANCH dev_price_fix INTO main IN lab;