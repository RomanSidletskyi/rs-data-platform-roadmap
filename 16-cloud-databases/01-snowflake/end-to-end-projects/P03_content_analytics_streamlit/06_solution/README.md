# P03 Solution

Reference implementation for [P03](../README.md). Build your own first with [07_build_it_yourself.md](../07_build_it_yourself.md); run this one with [QUICKSTART.md](../QUICKSTART.md).

## Layout

```text
06_solution/
  p03.env.example / run_sql.sh     env template and SQL runner
  upload.sh                        PUT data folders (P03_OWNER) or app files (P03_APP_OWNER, uncompressed)
  fetch/
    fetch_pageviews.py             top lists per day and daily totals, _source lineage, skips existing days
    test_fetch_pageviews.py
  core/
    00_account_setup.sql           three roles, warehouse, monitor, database
    01_raw.sql                     schemas, stage, raw table, reference tables, app boundary grants
    20_load_and_model.sql          COPY, STG with FLATTEN, MART serving tables with COPY GRANTS
    30_app_stage.sql               app stage owned by the app owner
    31_app_deploy.sql              CREATE STREAMLIT, live version, viewer grant
    90_pause.sql
  app/
    streamlit_app.py               four tabs, bind parameters, cached queries, local fallback session
    environment.yml                pinned Streamlit for the warehouse runtime
  tests/
    data_quality_checks.sql
    test_app_smoke.py              AppTest with a fake session: renders, and search text is bound
    failure_drills.md
  teardown.sql
```

## Expected Results (30 days, three projects)

| Check | Expected |
| --- | --- |
| Files on stage | 30 top lists plus 1 aggregate file per project |
| `STG.TOP_ARTICLE_DAILY` | 987 to 1000 rows per project per day |
| `MART.ARTICLE_DAILY` | About 8 to 13 fewer rows per day than the top list |
| `MART.TRENDING` | Same rows as `ARTICLE_DAILY`; the first 7 days have little history |
| Data quality checks | All `PASS` |
| `P03_VIEWER` on any table | Not authorized |
| App smoke tests | 2 passed |

## Design Notes Worth Comparing With Your Version

- **Latest list wins per day**, not per article: a re-download replaces the list.
- **Reference tables** for main pages and namespaces keep language rules out of SQL logic.
- **`COPY GRANTS`** on every rebuilt serving object keeps the app working through reloads.
- **`V_FRESHNESS`** shows owner's rights on views: the app reads it without access to RAW or STG.
- **Deploy is a script**: upload alone changes nothing, by design of `CREATE STREAMLIT ... FROM`.
- **The smoke test** replaces Snowpark with a fake session, so app logic is tested without credentials or credits.
