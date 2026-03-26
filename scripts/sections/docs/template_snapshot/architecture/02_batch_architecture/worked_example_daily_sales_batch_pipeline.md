# Worked Example - Daily Sales Batch Pipeline

## Scenario

A retail company needs trusted daily sales reporting by 7 AM every morning.

Source systems include:

- orders database
- refund table
- product catalog extract

## Why Batch Is A Good Fit

- the report has a fixed delivery time
- finance prefers stable daily numbers over minute-by-minute volatility
- replay and backfill are more important than sub-minute freshness

## Architecture Shape

    Source extracts
        ->
    raw landing
        ->
    validation and normalization
        ->
    daily aggregated marts
        ->
    BI dashboards and finance export

## Important Design Decisions

- keep raw landed files or tables before transformations
- separate validation from business aggregation
- make the daily partition rerunnable safely
- publish only curated outputs to BI consumers

## What Good Looks Like

- the pipeline can rerun one day without rebuilding the whole year
- refunds and corrections can be backfilled explicitly
- finance sees stable definitions of revenue and net sales
- failures stop before bad data reaches the final mart

## What Bad Looks Like

- full refresh of all history every morning with no reason
- dashboards query intermediate transformation tables directly
- no raw preservation, so debugging source defects becomes guesswork
- reruns duplicate rows because the load path is not idempotent

## Questions To Review

- what is the partitioning unit for reruns
- how are late-arriving records handled
- which metrics are recalculated versus overwritten
- how will a backfill be isolated from the normal daily run

## Key Takeaway

Batch architecture is strong when the business process is schedule-driven and the system is designed around safe reruns, raw preservation, and curated outputs.