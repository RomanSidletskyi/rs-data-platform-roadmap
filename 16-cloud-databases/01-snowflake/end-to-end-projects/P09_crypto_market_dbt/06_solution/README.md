# P09 Solution

Reference implementation. Open it after your own milestone passes ([07](../07_build_it_yourself.md)).

## Layout

```text
06_solution/
├── extract/
│   ├── extract_markets.py         Coinbase windows as JSON envelopes, FRED CSV; --sources all|coinbase|fred
│   └── test_extract_markets.py    4 tests: request windows, hour flooring, envelope (no network)
├── core/
│   ├── 00_account_setup.sql       roles OWNER / TRANSFORMER / READER, WH, monitor, DB, email integration
│   ├── 05_service_users.sql       P09_CI_SVC and P09_PIPELINE_SVC, TYPE = SERVICE, key pair
│   ├── 01_raw.sql                 stage, file formats, raw tables, grants to dbt
│   ├── 20_load.sql                COPY with file name and load time; FRED series from the path
│   ├── 30_alerts.sql              stale prices, large move (email lists the rows)
│   └── 90_pause.sql
├── dbt/
│   ├── profiles.yml.example       dev, prod, ci targets; key-pair auth from env vars
│   └── p09_markets/
│       ├── dbt_project.yml        layers to schemas, grants, store_failures, lookback var
│       ├── packages.yml           dbt_utils
│       ├── macros/                generate_schema_name, drop_ci_schemas
│       ├── seeds/assets.csv       asset list and observations per year
│       ├── models/staging/        sources with freshness, candles and FRED typed and deduplicated
│       ├── models/intermediate/   crypto daily rollup (unit-tested), all assets daily
│       ├── models/marts/          incremental hourly fact with contract, daily returns, volatility, correlation, exposure
│       └── tests/                 long hourly gaps, daily close equals last hourly close
├── ci/
│   ├── p09_dbt_pull_request.yml   build in CI_PR_<n>, then drop schemas
│   └── p09_scheduled_pipeline.yml hourly extract, PUT, COPY, dbt build, freshness
├── tests/
│   ├── data_quality_checks.sql    11 checks: unloaded files, coverage, merge drift, stored failures, CI leftovers
│   └── failure_drills.md          D1 to D6
├── upload.sh  run_pipeline.sh  run_sql.sh  p09.env.example  teardown.sql
```

## Expected Results

From a real extraction and a static dbt parse; your numbers will differ with the date.

| Check | Expected |
| --- | --- |
| `pytest extract/` | 4 passed |
| `dbt parse` | 8 models, 28 data tests, 1 unit test, 1 seed, 2 sources, 1 exposure, no deprecation warnings |
| Coinbase rows for 20 days per product | 482 raw candle rows, 481 unique hours, 0 gaps |
| FRED lines per series since 2023 | about 1,004, of which 37 to 40 empty (holidays) |
| First `dbt build`, 120 days | All tests pass; `MART_VOLATILITY_30` starts about 31 days after the first complete day |
| Second `COPY` without new files | 0 files loaded |
| Hourly run duration | Under a minute of XS warehouse |

## Design Notes Worth Comparing With Your Version

- **Latest fetch wins in staging, not in the extractor.** The extractor is stateless and can re-read any window; deduplication lives where it is tested.
- **The lookback reads one hour more than it writes.** Otherwise the first return of each incremental batch is null.
- **Complete days only.** A crypto day with fewer than 24 candles has no daily close; otherwise today's partial day would produce a fake daily return every hour.
- **Correlation on shared days.** The join keeps only dates where both the coin and the S&P 500 have a return; weekends do not count as zero.
- **Two service users.** CI cannot load files or touch production schemas it did not create. Ask yourself what a malicious pull request could do with the pipeline key instead.
- **Freshness runs even when the build fails.** It tells whether the cause was missing input or broken logic.
- **FRED once a day, Coinbase every hour.** Re-downloading three years of daily data 24 times a day would be cheap but pointless, and every copy lands in RAW.
