-- The daily close of a complete day must equal the close of its last hourly candle.
select d.product_id, d.price_date, d.close_price as daily_close, h.close_price as last_hour_close
from {{ ref('int_crypto_daily') }} d
join {{ ref('fct_crypto_hourly') }} h
  on h.product_id = d.product_id
 and h.candle_start = dateadd(hour, 23, d.price_date::timestamp_ntz)
where d.is_complete_day
  and d.close_price <> h.close_price
