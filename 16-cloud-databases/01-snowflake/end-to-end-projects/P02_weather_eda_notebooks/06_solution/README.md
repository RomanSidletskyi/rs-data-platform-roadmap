# P02 Solution

Reference implementation for [P02](../README.md). Build your own first with [07_build_it_yourself.md](../07_build_it_yourself.md); run this one with [QUICKSTART.md](../QUICKSTART.md).

## Layout

```text
06_solution/
  p02.env.example / run_sql.sh     env template and SQL runner
  upload.sh                        PUT data folders or the notebook (uncompressed) to their stages
  fetch/
    fetch_weather.py               Open-Meteo archive, one file per city per year, _source lineage
    test_fetch_weather.py
  core/
    00_account_setup.sql           roles, warehouse, monitor, database
    01_raw.sql                     schemas, file format, data and notebook stages, raw table, cities
    20_load_and_model.sql          COPY, hourly table with FLATTEN and index, MART views, grants
    30_notebook.sql                CREATE NOTEBOOK from the stage, live version
    90_pause.sql
  notebooks/
    weather_eda.ipynb              portable: Snowflake Notebook, Jupyter, Deepnote
  tests/
    data_quality_checks.sql
    analysis_drills.md
  teardown.sql
```

## Expected Results (six cities, 2016 to last week)

| Check | Expected |
| --- | --- |
| Files on stage | 6 per year |
| `STG.WEATHER_HOURLY` | About 8760 rows per city per full year, about 0.5 million in total |
| `MART.V_DAILY` full days | `HOURS = 24` except daylight saving days (23 or 25) |
| Seasonal chart | Northern cities peak in July or August, southern in January or February |
| Data quality checks | All `PASS` |
| Notebook | Every cell pulls at most a few thousand rows |

## Design Notes Worth Comparing With Your Version

- **One `FLATTEN` plus `[t.index]`** unzips all parallel arrays in one pass.
- **`QUALIFY` on load time** makes re-downloads safe without deleting raw history.
- **Definitions live in views**; the notebook only asks questions.
- **`IN_SNOWFLAKE` flag** in the first cell makes the notebook portable and closes local sessions.
- **`AUTO_COMPRESS = FALSE`** for the notebook upload; Snowflake reads the `.ipynb` directly.
