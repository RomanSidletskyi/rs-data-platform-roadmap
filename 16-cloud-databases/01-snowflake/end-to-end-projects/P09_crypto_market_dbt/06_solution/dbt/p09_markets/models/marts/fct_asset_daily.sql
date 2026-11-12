-- Daily close and return per asset. Returns are between consecutive observations of the same asset:
-- calendar days for crypto, trading days for indexes.
select
    p.asset_id,
    p.asset_class,
    p.price_date,
    p.close_price,
    p.close_price / nullif(lag(p.close_price) over (partition by p.asset_id order by p.price_date), 0) - 1 as daily_return,
    ln(p.close_price / nullif(lag(p.close_price) over (partition by p.asset_id order by p.price_date), 0))  as daily_log_return
from {{ ref('int_asset_daily_prices') }} p
