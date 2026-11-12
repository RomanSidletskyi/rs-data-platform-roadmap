# P05 Solution

Reference implementation for [P05](../README.md). Build your own first with [07_build_it_yourself.md](../07_build_it_yourself.md); run this one with [QUICKSTART.md](../QUICKSTART.md).

## Layout

```text
06_solution/
  p05.env.example / run_sql.sh     env template and SQL runner
  simulate.sh                      call OPS.SIMULATE_DAY N times with a pause
  core/
    00_account_setup.sql           roles, warehouse, monitor, database, sample data and task privileges
    01_source.sql                  schemas, SRC copies of TPC-H 1997, run log, streams
    10_core_mart.sql               model tables, V_ORDER_CURRENT, bootstrap, fact stream, reconciliation view
    20_simulator.sql               OPS.SIMULATE_DAY procedure
    30_task_graph.sql              PIPE.CDC_ROOT, LOAD_DIM_CUSTOMER, LOAD_FACT_ORDER, LOAD_DAILY_REVENUE, FINALIZE_RUN
    40_ops.sql                     streams, graph runs, skipped runs, serverless credits, run log
    60_dynamic_tables.sql          DT_ORDER and DT_DAILY_REVENUE for comparison
    90_pause.sql
  tests/
    data_quality_checks.sql
    compare_tasks_vs_dt.sql
    failure_drills.md
  teardown.sql
```

## Expected Results

| Check | Expected |
| --- | --- |
| `CORE.FACT_ORDER` after bootstrap | Same count as `SRC.ORDERS` |
| One simulated day, one graph run | About 600 new orders, a few hundred updated, 5 deleted; up to a couple of hundred dates recomputed (fulfilments touch old dates) |
| `OPS.V_RECONCILIATION` | Empty after every run |
| Graph runs with no changes | Root `SKIPPED`, no serverless credits |
| Data quality checks | All `PASS` |
| Dynamic tables | Same daily numbers as `MART.DAILY_REVENUE` once caught up |

## Design Notes Worth Comparing With Your Version

- **Two techniques:** apply stream rows for the dimension, recompute affected keys for the fact.
- **One `INSERT` reads both source streams** inside a transaction, so their offsets move together.
- **No-op updates are skipped** in the fact `MERGE`, so the fact stream carries only real changes.
- **The fact stream** gives the mart the old date of cancelled orders for free.
- **One view, three uses:** bootstrap, incremental recompute, and reconciliation share `CORE.V_ORDER_CURRENT`.
- **Finalizer** logs reconciliation after every run, including failed ones.
