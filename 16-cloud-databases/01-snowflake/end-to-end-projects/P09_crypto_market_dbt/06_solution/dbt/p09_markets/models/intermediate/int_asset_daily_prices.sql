-- All assets at daily grain with a close price, crypto and FRED series in one shape.
select
    a.asset_id,
    a.asset_class,
    c.price_date,
    c.close_price
from {{ ref('int_crypto_daily') }} c
join {{ ref('assets') }} a on a.source_symbol = c.product_id
where c.is_complete_day

union all

select
    a.asset_id,
    a.asset_class,
    f.observation_date as price_date,
    f.value            as close_price
from {{ ref('stg_fred__observations') }} f
join {{ ref('assets') }} a on a.source_symbol = f.series_id
