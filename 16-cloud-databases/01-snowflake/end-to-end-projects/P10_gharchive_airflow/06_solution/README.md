# P10 Solution

Reference implementation. Open it after your own milestone passes ([07](../07_build_it_yourself.md)).

## Layout

```text
06_solution/
├── airflow/
│   ├── docker-compose.yml          Airflow 3.4, LocalExecutor, Postgres, UI on 127.0.0.1:8080, pools created at init
│   ├── Dockerfile  requirements.txt  official image plus pinned providers
│   ├── make_env.sh                 .env and airflow.env from ../p10.env; connections as AIRFLOW_CONN_* JSON
│   ├── dags/
│   │   ├── gharchive_lib.py        file names, keys, publication status, size checks, hour profiler (no Airflow imports)
│   │   ├── p10_gharchive_hourly.py sensor, land (internal, azure, aws), LOAD_HOUR, BUILD_HOUR, check
│   │   └── p10_gharchive_daily.py  24-hour sensor, BUILD_DAY, ARCHIVE_DAY, PURGE_HOT, drift check
│   └── tests/
│       ├── test_gharchive_lib.py   7 tests, standard library only
│       └── test_dag_integrity.py   3 tests: imports, timetables, task order, pools (needs Airflow)
├── core/
│   ├── 00_account_setup.sql        roles OWNER / PIPELINE / READER, WH, monitor, DB, service user
│   ├── 01_schemas_and_tables.sql   internal stages, file formats, RAW, STG, MART, OPS
│   ├── 10_procedures.sql           LOAD_HOUR, BUILD_HOUR, BUILD_DAY, ARCHIVE_DAY, PURGE_HOT, SOURCE_DRIFT, grants
│   └── 90_pause.sql                suspend and show cost by Airflow task
├── azure/                          storage account with landing and archive, lifecycle, Airflow service principal,
│                                   integration, container-scoped roles, external stages and table
├── aws/                            bucket, lifecycle, IAM role for Snowflake, IAM user for Airflow, integration, stages
├── tests/
│   ├── data_quality_checks.sql     11 checks: coverage, missing hours, reloads, archive state, drift, cost
│   └── failure_drills.md           D1 to D7
├── run_sql.sh  p10.env.example  teardown.sql
```

## Expected Results

From live source samples and static checks; your numbers depend on the days you load.

| Check | Expected |
| --- | --- |
| `pytest airflow/tests` with Airflow 3.4.0 installed | 10 passed (7 without Airflow) |
| Rendered SQL of `load_raw` | `CALL P10_GH.OPS.LOAD_HOUR('2026-11-09 15:00:00'::TIMESTAMP_NTZ, '<run_id>')` after a query tag statement |
| One November 2026 hour | 2 to 5 MB, about 3,500 events, no push events |
| One full-format hour (before October 2025) | About 100 MB, 165,000 events, 55 to 70 percent push events |
| `LOAD_HOUR` twice for the same hour | Same `RAW_ROWS`, `LOAD_COUNT` 2 |
| Two backfilled days | 48 rows in `OPS.HOUR_LOG`, 2 rows in `OPS.DAY_LOG` with `VERIFIED = TRUE` |
| `OPS.SOURCE_DRIFT` with only November 2026 days | Few or no rows; with an October 2025 day and later days, `disappeared` and `ratio changed` rows |

## Design Notes Worth Comparing With Your Version

- **Thin DAGs, thick procedures.** The DAG files hold scheduling, landing, and wiring; every rule about data lives in SQL you can call by hand. Ask yourself which of your DAG tasks would break if someone ran them from a worksheet.
- **The landing code is the only cloud-specific Python.** One function per target behind one switch, `P10_LANDING`. The SQL is identical; only the stage definitions differ.
- **Check before delete.** `LOAD_HOUR` lists the file before deleting the hour, because `COPY` of a missing path succeeds with zero files.
- **Every rebuild checks its input against the log.** `BUILD_HOUR` against `RAW`, `BUILD_DAY` against `STG`, `ARCHIVE_DAY` against `DAY_LOG`. A partial input fails loudly instead of producing a smaller result.
- **Remove, unload, read back, then mark.** Order matters: marking first would let a purge delete the hot copy of a day with a broken archive.
- **Drift is a leaf.** It turns red and can alert, but archive and purge do not depend on it.
- **Secrets stay outside the image and Git.** The Snowflake key is a read-only mount; cloud credentials come from `airflow.env`. A hosted Airflow would replace both with workload identities.
