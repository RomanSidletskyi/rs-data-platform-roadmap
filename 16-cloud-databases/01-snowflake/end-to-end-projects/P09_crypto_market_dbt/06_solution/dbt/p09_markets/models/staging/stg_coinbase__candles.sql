-- One row per product and candle start. Windows overlap by one candle (the API's end is inclusive) and runs
-- overlap by the lookback, so the latest fetch wins.
with responses as (

    select
        payload:product::string     as product_id,
        payload:granularity::number as granularity_s,
        payload:fetched_at::timestamp_tz as fetched_at,
        payload:candles             as candles,
        loaded_at
    from {{ source('raw', 'coinbase_candles_raw') }}

),

candles as (

    select
        r.product_id,
        r.granularity_s,
        to_timestamp_ntz(c.value[0]::number)       as candle_start,
        c.value[3]::number(38, 8)                  as open_price,
        c.value[2]::number(38, 8)                  as high_price,
        c.value[1]::number(38, 8)                  as low_price,
        c.value[4]::number(38, 8)                  as close_price,
        c.value[5]::number(38, 8)                  as base_volume,
        r.fetched_at,
        r.loaded_at
    from responses r,
        lateral flatten(input => r.candles) c

)

select *
from candles
qualify row_number() over (
    partition by product_id, granularity_s, candle_start
    order by fetched_at desc, loaded_at desc
) = 1
