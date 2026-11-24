# 5. Step by Step on Snowflake

Every step: **what**, **why**, **verify**, **common errors**. Scripts are in [06_solution](06_solution/README.md).

```mermaid
flowchart LR
    P0[0 Setup] --> P1[1 Prepare months]
    P1 --> P2[2 Tests first]
    P2 --> P3[3 Objects and upload]
    P3 --> P4[4 Raw load]
    P4 --> P5[5 Client run]
    P5 --> P6[6 Deploy procedure]
    P6 --> P7[7 Task and checks]
    P7 --> P8[8 Drills and pause]
```

---

## Phase 0: Setup

- **What:** `./run_sql.sh core/00_account_setup.sql`; Python environment with `snowflake-snowpark-python`, `openpyxl`, `pytest`.
- **Verify:** `python -c "import snowflake.snowpark"` works.

---

## Phase 1: Prepare Months

```bash
cd prepare && python prepare_months.py --out "$P07_DATA_DIR" && cd ..
```

- **Why:** monthly files as a shop system would deliver them; both sheets kept.
- **Verify:** 25 `month=` folders; December 2010 has two files.
- **Common errors:** no network or UCI unavailable: `--synthetic` writes three small months with the same kinds of dirt.

---

## Phase 2: Tests First

```bash
python -m pytest -q prepare/test_prepare_months.py tests/test_transforms.py
```

- **Why:** transformations are proven correct before any data reaches Snowflake.
- **Verify:** 10 passed in a few seconds, without a Snowflake connection.

---

## Phase 3: Objects and Upload

```bash
./run_sql.sh core/01_objects.sql
python run_local.py upload
```

- **Why:** tables are a contract; files go up with the Snowpark File API.
- **Verify:** the upload prints `UPLOADED` for every file; a second run prints `SKIPPED`.

---

## Phase 4: Raw Load

- **What:** `./run_sql.sh core/20_load_raw.sql`.
- **Why:** `COPY` with the month taken from the folder name.
- **Verify:** 25 months, December 2010 with two files, about 1.07 million rows in total.

---

## Phase 5: Client Run

```bash
python run_local.py process
```

- **Why:** the full pipeline from the laptop; all DataFrame work runs on `P07_WH`.
- **Verify:** "25 months processed, about 5,900 customers scored"; Snowsight query history shows the generated SQL.

---

## Phase 6: Deploy the Procedure

```bash
./package.sh
./run_sql.sh core/30_procedure.sql
```

- **Why:** the same code, now running inside Snowflake.
- **Verify:** the `CALL` at the end returns "0 months processed" (the client already did the work). Delete one row from `OPS.MONTH_STATUS` and call again: one month processed.
- **Common errors:**
  - `ModuleNotFoundError: retail_pipeline`: the zip must contain the `retail_pipeline/` folder at its root.
  - Package not found: only Anaconda channel packages can be listed in `PACKAGES`.

---

## Phase 7: Task and Checks

```bash
./run_sql.sh core/40_task.sql
snow sql -c p07 -q "USE ROLE P07_OWNER; EXECUTE TASK P07_RETAIL.OPS.MONTHLY_RUN"
./run_sql.sh tests/data_quality_checks.sql
```

- **Verify:** all checks `PASS`; reject reasons and duplicate counts per month look like the numbers in [01](01_problem.md).

---

## Phase 8: Drills and Pause

- Work through [tests/failure_drills.md](06_solution/tests/failure_drills.md).
- Pause: `./run_sql.sh core/90_pause.sql`. Teardown at the end: `./run_sql.sh teardown.sql`.
