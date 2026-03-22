# DBT Performance and Cost Optimization

## Why this matters

In Snowflake-based platforms, poor dbt design can become expensive very quickly.

Main cost drivers:

- full refresh on large tables
- oversized warehouses
- rebuilding too much of the DAG
- poor incremental strategy
- unnecessary wide scans

--------------------------------------------------

## Performance topics that matter most

1. model materialization choice
2. incremental design
3. warehouse sizing
4. DAG selection strategy
5. upstream/downstream rebuild scope
6. test execution footprint

--------------------------------------------------

## Use incremental where it makes sense

Especially for:

- event facts
- time-series data
- append-heavy raw landing patterns

Prefer:

- `merge` for upserts
- lookback windows for late-arriving rows
- narrower source reads

--------------------------------------------------

## Avoid rebuilding the whole graph unnecessarily

For dev and CI:

    dbt build --select state:modified+ --defer --state path/to/prod_artifacts

This is one of the biggest cost savers in larger projects. :contentReference[oaicite:16]{index=16}

--------------------------------------------------

## Warehouse sizing strategy

Recommended pattern:

- small warehouse for staging and tests
- medium for intermediate
- large for heavy facts
- XL only for backfill and exceptional workloads

Trade-off:

small warehouse:
- cheaper
- slower

large warehouse:
- faster
- more expensive

NFR should be defined as SLA, not "everything must be fast."

Example:
- hourly fact refresh SLA = 10 minutes
- daily full build SLA = 90 minutes

--------------------------------------------------

## Different jobs can have different expected runtimes

This is normal.

Examples:

fast jobs:
- staging refresh
- 1 to 10 minutes

medium jobs:
- dimensions
- 10 to 30 minutes

heavy jobs:
- full facts / backfills
- 30 to 120 minutes or more

The key question is:
does the job meet its SLA?

--------------------------------------------------

## How to debug performance problems

In dbt:
- inspect compiled SQL
- inspect model materialization
- inspect graph selection
- inspect incremental filter logic

In Snowflake:
- check query history
- inspect execution profile
- evaluate scan volume
- review warehouse size and concurrency

--------------------------------------------------

## Common optimization patterns

- use incremental instead of table rebuild
- use lookback window instead of full refresh
- avoid giant all-in-one models
- keep staging simple
- persist heavy reused logic as tables
- isolate heavy jobs into separate warehouses
- use tags and selectors to avoid unnecessary runs

--------------------------------------------------

## Final rule

Good dbt optimization is not about "always faster."
It is about:

- correct runtime for the SLA
- acceptable cost
- reliable data quality
- maintainable architecture

