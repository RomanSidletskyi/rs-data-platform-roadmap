# P06 Solution

Reference implementation for [P06](../README.md). Build your own first with [07_build_it_yourself.md](../07_build_it_yourself.md); run this one with [QUICKSTART.md](../QUICKSTART.md).

## Layout

```text
06_solution/
  p06.env.example / run_sql.sh     env template and SQL runner
  upload_day.sh                    PUT one or more day folders (no OVERWRITE: extracts are immutable)
  generator/
    food_oltp.py                   deterministic OLTP simulator, full extract on day 0, deltas after
    test_food_oltp.py
  core/
    00_account_setup.sql           roles, warehouse, monitor, database, task privileges
    01_raw.sql                     schemas, CSV format with header parsing, stage, RAW tables, append-only streams
    10_model.sql                   dimensions with unknown members, facts, date dimension, work tables, V_MODEL_CHECKS
    20_build_procedure.sql         CORE.SP_BUILD_CORE: SCD1, SCD2, inferred members, facts, one transaction
    30_task_graph.sql              PIPE.LOAD_RAW -> PIPE.BUILD_CORE, PIPE.FINALIZE_RUN
    40_mart.sql                    V_ORDER, V_REVENUE_BY_TIER, DT_DAILY_KPI, dashboard tiles
    90_pause.sql
  tests/
    data_quality_checks.sql
    failure_drills.md
  teardown.sql
```

## Expected Results (14 days, seed 6)

| Check | Expected |
| --- | --- |
| Generator tests | 8 passed |
| Extracts | Day 0 about 3,000 customers and 2,000 orders; later days about 70 customers and 2,100 orders |
| `DIM_CUSTOMER` after 14 days | About 3,500 keys, several hundred extra versions |
| Inferred customers | About 4 per day, all completed the next day except those of the last loaded day |
| `FACT_ORDER` | Equal to distinct order ids in `RAW.ORDERS`, about 30,000 |
| `OPS.V_MODEL_CHECKS` | All 0 |

## Design Notes Worth Comparing With Your Version

- **Hash of tracked attributes** separates SCD2 changes from SCD1 corrections in one comparison.
- **Versions inside a batch** are chained with `LEAD`, so load cadence does not change history.
- **First version from 1900** so early facts always find a version.
- **Inferred members completed in place**, never versioned.
- **Keys resolved once**, when the order is first seen; later extracts only fill milestones.
- **Nondeterministic `MERGE` error** turns a broken SCD2 range into a failed run instead of wrong numbers.
