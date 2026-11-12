-- Rolling 60-day correlation of each crypto asset's daily returns with the S&P 500.
-- Only dates where both have a return count: crypto trades every day, the index does not.
with crypto as (
    select asset_id, price_date, daily_log_return
    from {{ ref('fct_asset_daily') }}
    where asset_class = 'crypto' and daily_log_return is not null
),

spx as (
    select price_date, daily_log_return
    from {{ ref('fct_asset_daily') }}
    where asset_id = 'SPX' and daily_log_return is not null
),

paired as (
    select c.asset_id, c.price_date, c.daily_log_return as crypto_return, s.daily_log_return as spx_return
    from crypto c
    join spx s on s.price_date = c.price_date
)

select
    asset_id,
    price_date,
    corr(crypto_return, spx_return) over (partition by asset_id order by price_date rows between 59 preceding and current row)
        as correlation_with_spx_60,
    count(*) over (partition by asset_id order by price_date rows between 59 preceding and current row)
        as paired_observations
from paired
qualify paired_observations = 60
