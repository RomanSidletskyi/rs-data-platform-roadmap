# P01 Solution

Reference implementation for [P01](../README.md). Build your own first with [07_build_it_yourself.md](../07_build_it_yourself.md); run this one with [QUICKSTART.md](../QUICKSTART.md).

## Layout

```text
06_solution/
  p01.env.example / run_sql.sh     env template and SQL runner
  upload_batch.sh                  PUT year folders to the internal stage (--overwrite for corrections)
  prepare/
    prepare_batches.py             download Cricsheet ODIs, split into year=YYYY folders
    test_prepare_batches.py
  core/
    00_account_setup.sql           roles, warehouse, monitor, database, task privileges
    01_bronze.sql                  schemas, file format, internal stage with directory, raw table, run log
    20_silver.sql                  stream, batch table, silver tables
    30_gold.sql                    gold tables and analyst views
    40_task_graph.sql              LOAD_RAW -> BUILD_SILVER -> BUILD_GOLD
    50_ops_and_dashboard.sql       stage reconciliation, graph history, dashboard tiles
    90_pause.sql
  tests/
    data_quality_checks.sql
    failure_drills.md
  teardown.sql
```

## Expected Results (full ODI history since 2000)

| Check | Expected |
| --- | --- |
| `RAW.MATCH_RAW` | One row per uploaded file |
| `STG.MATCH` | Same count as distinct match files |
| `STG.DELIVERY` | Hundreds of thousands to low millions of rows |
| `OPS.RUN_LOG` | Three steps per graph run |
| Data quality checks | All `PASS` |
| Second run with no new files | `BUILD_SILVER` batch size 0 |

## Design Notes Worth Comparing With Your Version

- **Batch table inside a transaction** freezes the stream contents and makes silver atomic.
- **`GET(registry.people, name)`** resolves dynamic object keys.
- **Revision-aware `MERGE`** prevents older files from overwriting newer ones.
- **Gold recomputed in full** on purpose; incremental gold is a stretch goal.
- **Retirements** are recorded as wickets in the source; quality checks and `IS_OUT` handle them explicitly.
