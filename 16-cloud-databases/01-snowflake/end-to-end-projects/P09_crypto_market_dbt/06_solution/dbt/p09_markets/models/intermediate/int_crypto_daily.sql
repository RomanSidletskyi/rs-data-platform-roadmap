-- Hourly candles rolled up to UTC days. A day is complete only with all 24 hours.
select
    product_id,
    to_date(candle_start)                     as price_date,
    min_by(open_price, candle_start)          as open_price,
    max(high_price)                           as high_price,
    min(low_price)                            as low_price,
    max_by(close_price, candle_start)         as close_price,
    sum(base_volume)                          as base_volume,
    count(*)                                  as hours,
    count(*) = 24                             as is_complete_day
from {{ ref('stg_coinbase__candles') }}
group by 1, 2
