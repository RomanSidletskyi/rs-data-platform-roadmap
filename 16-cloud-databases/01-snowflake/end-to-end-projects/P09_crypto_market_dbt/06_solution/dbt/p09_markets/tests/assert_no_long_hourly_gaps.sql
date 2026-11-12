-- Fails when a product has a gap of more than 3 hours in the last 7 days. Coinbase skips hours without trades,
-- so single missing hours are normal for small products; long gaps mean the extractor stopped.
select product_id, candle_start, hours_since_previous
from {{ ref('fct_crypto_hourly') }}
where candle_start >= dateadd(day, -7, sysdate())
  and hours_since_previous > 3
