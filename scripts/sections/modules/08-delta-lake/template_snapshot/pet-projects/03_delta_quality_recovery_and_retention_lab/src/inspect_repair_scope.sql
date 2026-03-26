SELECT
  business_date,
  COUNT(*) AS affected_row_count,
  SUM(CASE WHEN quality_status = 'invalid' THEN 1 ELSE 0 END) AS invalid_row_count
FROM silver.orders_shared
WHERE business_date BETWEEN '{{ repair_window_start }}' AND '{{ repair_window_end }}'
GROUP BY business_date
ORDER BY business_date;
