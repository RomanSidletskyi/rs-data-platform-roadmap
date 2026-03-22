# DBT Models and Materializations

## Materialization overview

dbt supports multiple model materializations.

The most important are:

- view
- table
- incremental
- ephemeral

--------------------------------------------------

## view

Use when:

- data is lightweight
- logic is simple
- storage persistence is not required
- staging models are mostly pass-through

Pros:
- no duplicated storage
- easy to rebuild
- good for lightweight staging

Cons:
- query logic is recalculated at read time
- complex downstream chains can become expensive

--------------------------------------------------

## table

Use when:

- model is reused often
- logic is expensive
- stable persisted data is needed
- a dimension should be fast to join

Pros:
- faster downstream access
- stable performance
- good for dimensions and curated datasets

Cons:
- consumes storage
- full rebuild may be expensive

--------------------------------------------------

## incremental

Use when:

- table is large
- data arrives incrementally
- processing everything every run is too expensive
- fact tables are frequently updated

Incremental means:

- first run: full create
- next runs: process only new or changed data

If the target table does not exist, dbt falls back to creating it as a full load.

--------------------------------------------------

## ephemeral

Use when:

- logic is small and reusable
- you do not want a warehouse object
- you want a helper transformation inserted as a CTE

Ephemeral models are not created as warehouse tables or views.
They are inlined into downstream SQL as CTEs.

Pros:
- keeps warehouse cleaner
- good for helper logic

Cons:
- harder to debug
- compiled SQL becomes larger
- not ideal for heavy or frequently reused logic

--------------------------------------------------

## Practical defaults

staging:
- view

intermediate:
- view or table
- ephemeral only for small helpers

dimensions:
- table

facts:
- incremental or table depending on volume

--------------------------------------------------

## Example model-level config

    {{ config(
        materialized='incremental',
        unique_key='order_id'
    ) }}

--------------------------------------------------

## What materialization changes in practice

If model `stg_orders` is a view, then:

    {{ ref('stg_orders') }}

resolves to a warehouse view.

If `stg_orders` is a table, `ref()` resolves to a physical table.

If `stg_orders` is ephemeral, dbt inlines it as a CTE into downstream SQL.

