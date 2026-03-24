# Worked Example - Reporting Should Not Hit OLTP Directly

## Scenario

An e-commerce application stores orders in a transactional database.

The business now wants dashboards for:

- daily revenue
- top products
- order status trends
- refund rates

The first naive idea is to connect the BI tool directly to the application database.

## Why That Looks Attractive

- the data already exists
- the team can move quickly
- no separate pipeline is needed initially

## Why It Becomes A Bad Architecture

- analytical queries compete with application traffic
- source tables are shaped for writes, not analytics
- historical reconstruction becomes harder
- metric definitions drift when each dashboard author writes custom SQL

## Better Architecture Shape

    OLTP orders DB
        ->
    batch or CDC ingestion
        ->
    raw analytical landing
        ->
    curated fact and dimension models
        ->
    semantic layer / BI

## Foundations Visible In This Example

- OLTP and OLAP have different workloads
- ETL or ELT exists to reshape data for analytical consumption
- idempotency matters if loads rerun
- lineage matters when business asks where a metric came from

## What To Notice As An Architect

- the operational source of truth stays in the application system
- the analytical system becomes the reporting truth
- freshness can often be hourly or daily instead of real time
- curated models are a product layer, not a copy of source tables

## Good Questions To Ask

- what is the acceptable freshness for dashboards
- which source tables are too operationally sensitive for direct BI access
- which metrics need governed definitions
- how will historical corrections be handled

## Common Wrong Move

The team keeps adding read replicas and still lets reporting hit operational schemas directly.

This reduces some load but does not fix the modeling problem.

## Key Takeaway

The first architectural boundary in many data platforms is separating operational systems of record from analytical serving layers.