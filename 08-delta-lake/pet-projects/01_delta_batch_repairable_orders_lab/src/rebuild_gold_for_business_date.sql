-- Rebuild only the affected daily slice instead of rewriting the full gold table.
INSERT OVERWRITE gold.daily_sales
SELECT
  business_date,
  UPPER(TRIM(country_code)) AS country_code,
  COUNT(*) AS order_count,
  CAST(SUM(CAST(gross_amount AS DECIMAL(18,2))) AS DECIMAL(18,2)) AS gross_revenue,
  SUM(CASE WHEN order_status = 'refunded' THEN 1 ELSE 0 END) AS refunded_order_count
FROM silver.orders_clean
WHERE business_date = '{{ business_date }}'
GROUP BY business_date, UPPER(TRIM(country_code));
