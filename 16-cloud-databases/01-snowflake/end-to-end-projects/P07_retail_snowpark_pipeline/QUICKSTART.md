# P07 Quickstart

Numbered commands from an empty laptop to a tested, deployed, and scheduled Snowpark pipeline. Only a Snowflake account is needed. Details: [05_snowflake_step_by_step.md](05_snowflake_step_by_step.md).

```mermaid
flowchart LR
    A[1-2 Install and connect] --> B[3 Env file]
    B --> C[4 Prepare and test]
    C --> D[5 Objects, upload, raw load]
    D --> E[6 Client run]
    E --> F[7 Deploy procedure]
    F --> G[8 Task and checks]
    G --> H[9 Drills]
    H --> I[10 Pause or teardown]
```

### 1. Install

Python 3.11 or 3.12, Snowflake CLI ([setup guide](../../../../shared/environments/setup-guide/01_workstation_macos.md), [Snowflake CLI](../../../../shared/environments/setup-guide/02_cli_tools_and_auth.md#snowflake-cli)), `zip`.

**Done when:** `snow --version`, `python3.12 --version`, and `zip -v` work.

### 2. Snowflake trial and connection

[Snowflake account guide](../../../../shared/environments/setup-guide/accounts/snowflake.md); add `[connections.p07]` to `~/.snowflake/config.toml`. Snowpark reads the same file.

**Done when:** `snow sql -c p07 -q "SELECT CURRENT_USER()"` succeeds.

### 3. Env file and Python environment

```bash
cd 16-cloud-databases/01-snowflake/end-to-end-projects/P07_retail_snowpark_pipeline/06_solution
cp p07.env.example p07.env      # P07_DATA_DIR: an absolute folder outside the repository
set -a; source p07.env; set +a
mkdir -p "$P07_DATA_DIR"
python3.12 -m venv .venv && source .venv/bin/activate
pip install snowflake-snowpark-python openpyxl pytest
```

**Done when:** `python -c "import snowflake.snowpark, openpyxl"` works.

### 4. Prepare and test

```bash
( cd prepare && python prepare_months.py --out "$P07_DATA_DIR" )     # or --synthetic
python -m pytest -q prepare/test_prepare_months.py tests/test_transforms.py
```

**Done when:** 25 month folders exist and 10 tests pass.

### 5. Objects, upload, raw load

```bash
./run_sql.sh core/00_account_setup.sql core/01_objects.sql
python run_local.py upload
./run_sql.sh core/20_load_raw.sql
```

**Done when:** the raw load summary shows 25 months.

### 6. Client run

```bash
python run_local.py process
```

**Done when:** it prints "25 months processed".

### 7. Deploy procedure

```bash
./package.sh
./run_sql.sh core/30_procedure.sql
```

**Done when:** the final `CALL` returns "0 months processed".

### 8. Task and checks

```bash
./run_sql.sh core/40_task.sql
snow sql -c p07 -q "USE ROLE P07_OWNER; EXECUTE TASK P07_RETAIL.OPS.MONTHLY_RUN"
./run_sql.sh tests/data_quality_checks.sql
```

**Done when:** all checks `PASS`.

### 9. Drills

[tests/failure_drills.md](06_solution/tests/failure_drills.md).

**Done when:** drill log filled.

### 10. Pause or teardown

```bash
./run_sql.sh core/90_pause.sql
./run_sql.sh teardown.sql        # end of project
```

**Done when:** `SHOW WAREHOUSES LIKE 'P07_%'` returns nothing after teardown.
