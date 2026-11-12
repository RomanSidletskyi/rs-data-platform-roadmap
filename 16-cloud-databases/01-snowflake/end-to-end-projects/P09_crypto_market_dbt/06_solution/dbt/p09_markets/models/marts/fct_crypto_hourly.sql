{{
    config(
        materialized='incremental',
        unique_key=['product_id', 'candle_start'],
        incremental_strategy='merge',
        on_schema_change='append_new_columns'
    )
}}

-- Hourly fact with returns. Incremental runs re-read a lookback window: candles inside it can be corrected
-- by a later fetch, and the first new hour needs the previous close for its return.
with candles as (

    select product_id, candle_start, open_price, high_price, low_price, close_price, base_volume
    from {{ ref('stg_coinbase__candles') }}
    {% if is_incremental() %}
    where candle_start >= (
        select dateadd(hour, -{{ var('incremental_lookback_hours') }} - 1, max(candle_start)) from {{ this }}
    )
    {% endif %}

)

-- Every column is cast to the type in the enforced contract (_marts.yml).
select
    product_id::varchar                                                   as product_id,
    candle_start::timestamp_ntz                                           as candle_start,
    open_price::number(38, 8)                                             as open_price,
    high_price::number(38, 8)                                             as high_price,
    low_price::number(38, 8)                                              as low_price,
    close_price::number(38, 8)                                            as close_price,
    base_volume::number(38, 8)                                            as base_volume,
    (close_price * base_volume)::number(38, 8)                            as quote_volume,
    (close_price / nullif(lag(close_price) over (partition by product_id order by candle_start), 0) - 1)::float as hourly_return,
    datediff('hour', lag(candle_start) over (partition by product_id order by candle_start), candle_start)::number(38, 0) as hours_since_previous
from candles
{% if is_incremental() %}
-- The extra hour was read only to compute the first return; it is not written again.
qualify candle_start >= (
    select dateadd(hour, -{{ var('incremental_lookback_hours') }}, max(candle_start)) from {{ this }}
)
{% endif %}
