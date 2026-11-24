# P05 Quickstart

Numbered commands from an empty laptop to a running CDC pipeline with reconciliation and a dynamic table comparison. Only a Snowflake account is needed. Details: [05_snowflake_step_by_step.md](05_snowflake_step_by_step.md).

```mermaid
flowchart LR
    A[1-2 Install and connect] --> B[3 Env file]
    B --> C[4 Setup and source]
    C --> D[5 Model and bootstrap]
    D --> E[6 Task graph]
    E --> F[7 Simulate and check]
    F --> G[8 Dynamic tables]
    G --> H[9 Drills]
    H --> I[10 Pause or teardown]
```

### 1. Install

Snowflake CLI ([setup guide](../../../../shared/environments/setup-guide/01_workstation_macos.md), [Snowflake CLI](../../../../shared/environments/setup-guide/02_cli_tools_and_auth.md#snowflake-cli)). No Python packages needed.

**Done when:** `snow --version` works.

### 2. Snowflake trial and connection

[Snowflake account guide](../../../../shared/environments/setup-guide/accounts/snowflake.md); add `[connections.p05]` to `~/.snowflake/config.toml`.

**Done when:** `snow sql -c p05 -q "SELECT CURRENT_USER()"` succeeds.

### 3. Env file

```bash
cd 16-cloud-databases/01-snowflake/end-to-end-projects/P05_tpch_streams_tasks_cdc/06_solution
cp p05.env.example p05.env
```

**Done when:** `./run_sql.sh` prints its usage line.

### 4. Setup and source

```bash
./run_sql.sh core/00_account_setup.sql core/01_source.sql
```

**Done when:** the last query shows about 230,000 orders for 1997.

### 5. Model and bootstrap

```bash
./run_sql.sh core/10_core_mart.sql core/20_simulator.sql
```

**Done when:** `snow sql -c p05 -q "SELECT COUNT(*) FROM P05_CDC.OPS.V_RECONCILIATION"` returns 0.

### 6. Task graph

```bash
./run_sql.sh core/30_task_graph.sql
```

**Done when:** five tasks in `PIPE` are `started`.

### 7. Simulate and check

```bash
./simulate.sh 3
snow sql -c p05 -q "USE ROLE P05_OWNER; EXECUTE TASK P05_CDC.PIPE.CDC_ROOT AWAIT"
./run_sql.sh core/40_ops.sql tests/data_quality_checks.sql
```

**Done when:** all checks `PASS` and the run log shows the finalizer with 0 differences.

### 8. Dynamic tables

```bash
./run_sql.sh core/60_dynamic_tables.sql
./simulate.sh 5 120
./run_sql.sh tests/compare_tasks_vs_dt.sql
```

**Done when:** the comparison's first query returns no rows and you have filled the cost lines in your notes.

### 9. Drills

[tests/failure_drills.md](06_solution/tests/failure_drills.md).

**Done when:** drill log filled.

### 10. Pause or teardown

```bash
./run_sql.sh core/90_pause.sql
./run_sql.sh teardown.sql        # end of project
```

**Done when:** `SHOW WAREHOUSES LIKE 'P05_%'` returns nothing after teardown.
