# Worked Example - Executive KPI Serving Layer

## Scenario

Leadership wants dashboards for:

- revenue
- gross margin
- active customers
- order conversion

They want fast, trusted, explainable numbers.

## Why A Serving Layer Is Needed

- raw data is too technical
- metric definitions must stay stable
- dashboard performance should not depend on low-level transformation complexity

## Architecture Shape

    curated gold tables
        -> semantic model
        -> KPI dashboards
        -> self-service slice and filter workflows

## What Good Looks Like

- the same KPI definition is reused across reports
- fact and dimension design matches business questions
- dashboards hit serving-friendly tables, not raw event landings
- users can trust metric meaning without reading source SQL

## What Bad Looks Like

- each dashboard author redefines revenue independently
- BI connects directly to bronze or raw source tables
- semantic model mirrors source schema instead of business logic
- serving layer is absent, so every report is a custom pipeline

## Questions To Review

- who owns KPI definitions
- which curated tables are safe for broad business use
- what freshness is really needed by executives versus operators
- how metric changes are versioned or communicated

## Key Takeaway

Serving architecture exists to turn technically correct data into business-usable and trustworthy analytical products.