# P07 Solution

Reference implementation for [P07](../README.md). Build your own first with [07_build_it_yourself.md](../07_build_it_yourself.md); run this one with [QUICKSTART.md](../QUICKSTART.md).

## Layout

```text
06_solution/
  p07.env.example / run_sql.sh     env template and SQL runner
  run_local.py                     client: File API upload, process pending months from the laptop
  package.sh                       zip retail_pipeline/ and PUT it to OPS.CODE_STAGE
  prepare/
    prepare_months.py              UCI workbook to month=YYYY-MM CSV files; --synthetic fallback
    test_prepare_months.py
  retail_pipeline/
    transforms.py                  pure DataFrame functions: classify, daily sales, product monthly, RFM
    pipeline.py                    I/O, transactions, month status, RFM refresh; procedure handler
  core/
    00_account_setup.sql           roles, warehouse, monitor, database, task privileges
    01_objects.sql                 schemas, stages, RAW, STG, MART, OPS tables
    20_load_raw.sql                COPY with month from the file path
    30_procedure.sql               CREATE PROCEDURE ... IMPORTS, first CALL
    40_task.sql                    OPS.MONTHLY_RUN: COPY then CALL
    90_pause.sql
  tests/
    conftest.py                    patches for local testing gaps
    test_transforms.py             Snowpark local testing, no account needed
    data_quality_checks.sql
    failure_drills.md
  teardown.sql
```

## Expected Results (full dataset)

| Check | Expected |
| --- | --- |
| Local tests | 5 prepare tests and 5 transform tests pass |
| `RAW.ONLINE_RETAIL` | 1,067,371 rows in 25 months, 26 files |
| Distinct lines | 1,033,036 |
| `STG.REJECTED_LINE` | About 6,000 lines, almost all `non_positive_price` |
| `STG.SALES_LINE` | About 1,027,000 lines, about 19,100 returns, about 5,700 fee lines |
| `MART.CUSTOMER_RFM` | About 5,900 customers |
| Data quality checks | All `PASS` |

## Design Notes Worth Comparing With Your Version

- **Pure transforms, separate I/O:** the reason the tests need no account.
- **Typed `CASE` expressions:** explicit casts that local testing needs and Snowflake does not mind.
- **Month replacement in a transaction** plus a status table: reruns are exact and cheap.
- **Tables defined in SQL**, appended by name: shape changes fail instead of drifting.
- **One handler, two runners:** the laptop run rehearses the scheduled run.
