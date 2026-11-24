# P11 Solution

Reference implementation. Open it after your own milestone passes ([07](../07_build_it_yourself.md)).

## Layout

```text
06_solution/
├── ingest/                          the code that runs in Azure Functions or AWS Lambda
│   ├── markets_ingest/
│   │   ├── sources.py               URLs, versioned keys, shape checks for WFP, ECB, World Bank (standard library)
│   │   ├── landing.py               create-if-absent writers: local, Azure Blob (managed identity), S3 (If-None-Match)
│   │   └── run.py                   one run, per-source error isolation, CLI
│   ├── function_app.py  host.json  requirements.txt  .funcignore     Azure Functions, timer 06:00 UTC
│   ├── lambda_handler.py            AWS Lambda entry point
│   └── tests/test_ingest.py         7 tests with a fake HTTP client
├── markets_pipeline/                the Snowpark package, zipped into OPS.CODE_STAGE
│   ├── units.py                     unit parsing
│   ├── transforms.py                pure DataFrame transforms
│   └── pipeline.py                  build(session): streams, build beside and swap, log
├── tests/
│   ├── test_transforms.py           6 tests, Snowpark local testing
│   ├── data_quality_checks.sql      10 checks: versions, loads, row accounting, units, FX, grain, plausibility, parity, builds
│   └── failure_drills.md            D1 to D7
├── core/
│   ├── 00_account_setup.sql         roles, two warehouses, monitor, DB, Power BI service user
│   ├── 01_raw.sql                   stage, formats, RAW tables, streams, parsing views
│   ├── 10_core_tables.sql           CORE tables with declared types, country-year view
│   ├── 20_load_internal.sql         COPY for internal-stage mode (same bodies as the pipes)
│   ├── 30_procedure_and_task.sql    Snowpark procedure, task with WHEN, first build
│   ├── 40_mart.sql                  star views, food against CPI, BI grants
│   ├── 50_semantic_view.sql         SEM.FOOD_PRICES and a query through it
│   └── 90_pause.sql
├── powerbi/                         semantic model guide, Power Query, DAX measures
├── azure/                           storage, queue, Event Grid, Flex Consumption app, deploy, integrations, pipes
├── aws/                             bucket, roles, Lambda with EventBridge Scheduler, integration, pipes
├── run_sql.sh  package.sh  upload.sh  p11.env.example  teardown.sql
```

## Expected Results

From live source runs on 2026-11-10 and static checks; your numbers depend on the day.

| Check | Expected |
| --- | --- |
| `pytest ingest/tests tests/test_transforms.py` | 13 passed |
| First local ingestion, Kenya, Türkiye, India | 3 WFP files, 1 ECB file, 5 World Bank files, about 5 minutes |
| Second ingestion | 0 landed, all unchanged, no CSV downloaded |
| Transforms on real data since 2025 (local testing, three countries) | 9,209 rows, 8,935 comparable, 0 without a rate |
| INR, ECB versus WFP implied, May to October 2026 | Differences between minus 0.85 and plus 0.58 percent |
| TRY, same months | Differences under 0.15 percent |
| Retail rice, September 2026, median USD per kg | India 0.44, Kenya 0.93, Türkiye 1.70 |
| Second `20_load_internal.sql` | 0 files loaded |

## Design Notes Worth Comparing With Your Version

- **Versions in names, writes that refuse to overwrite.** Blob `overwrite=False` and S3 `If-None-Match: *` make the storage service enforce idempotency, even for two runs at the same time.
- **Ask before downloading.** WFP metadata costs a few kilobytes; the India CSV costs 26 MB. Checking the version first makes a day without changes almost free.
- **Path parsing in SQL, Python where it helps.** The views own country, version, and latest-file logic; Snowpark owns units and FX precedence, which read better and test faster in Python.
- **A marker, not a null check.** `FX_SOURCE` comes from a joined literal, which behaves the same in Snowflake and in local testing.
- **Swap, not truncate.** Readers and the Power BI refresh never see an empty table.
- **Two semantic layers on purpose.** The semantic view serves SQL and AI consumers, DAX serves the report, and a check ties them together.
- **Separate BI warehouse and service user.** BI cost and access are visible and revocable on their own.
