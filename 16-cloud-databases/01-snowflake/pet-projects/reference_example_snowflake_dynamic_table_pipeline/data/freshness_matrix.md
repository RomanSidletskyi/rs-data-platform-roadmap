# Freshness Matrix

## Proposed Lag Classes

- `stg_orders_clean` -> 5 minutes
- `int_customer_daily_metrics` -> 15 minutes
- `mart_revenue_hourly` -> 30 minutes

## Why These Lags Differ

- staging is narrow and supports operational visibility, so low lag is justified
- intermediate customer metrics serve product analytics and can tolerate slightly more lag
- the revenue mart is consumer-facing but does not need five-minute freshness to remain useful

## Design Rule

If a table cannot justify its lag with a real consumer need, its lag is probably too low.