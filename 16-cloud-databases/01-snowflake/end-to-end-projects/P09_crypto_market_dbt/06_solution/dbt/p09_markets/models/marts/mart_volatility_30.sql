-- Rolling 30-observation volatility of log returns, annualized with each asset's observations per year.
select
    d.asset_id,
    d.price_date,
    stddev_samp(d.daily_log_return) over (partition by d.asset_id order by d.price_date rows between 29 preceding and current row)
        as volatility_30,
    volatility_30 * sqrt(a.observations_per_year)                            as annualized_volatility_30,
    count(d.daily_log_return) over (partition by d.asset_id order by d.price_date rows between 29 preceding and current row)
        as observations_in_window
from {{ ref('fct_asset_daily') }} d
join {{ ref('assets') }} a on a.asset_id = d.asset_id
qualify observations_in_window = 30
