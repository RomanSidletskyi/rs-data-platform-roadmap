# Solution

## Task 1 — GitHub Actions pull request validation

Example workflow:

```yaml
name: dbt-pr-validation

on:
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dbt
        run: pip install dbt-snowflake

      - name: Install dependencies
        run: dbt deps

      - name: Parse project
        run: dbt parse --target qa

      - name: Build modified graph
        run: dbt build --target qa --select state:modified+
        env:
          DBT_QA_PASSWORD: ${{ secrets.DBT_QA_PASSWORD }}
```

Why this matters:

- PR validation catches broken SQL, tests, and config before merge
- QA environment keeps validation separate from developer schemas
- selective execution reduces wasted Snowflake cost

## Task 2 — Production deploy workflow

Example workflow:

```yaml
name: dbt-prod-deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dbt
        run: pip install dbt-snowflake

      - name: Install dependencies
        run: dbt deps

      - name: Run production build
        run: dbt build --target prod --selector daily_dims
        env:
          DBT_PROD_PASSWORD: ${{ secrets.DBT_PROD_PASSWORD }}
```

Production note:

- in real platforms, frequent facts and daily dimensions are often deployed or scheduled separately
- merge to main should not automatically imply running every heavy model in one job

## Task 3 — Airflow orchestration pattern for dbt

Example design:

    Airflow DAG
        ↓
    dbt deps
        ↓
    dbt build --selector frequent_facts
        ↓
    quality gate / alerting

Example task sequence:

- `prepare_runtime`
- `run_dbt_deps`
- `run_dbt_build`
- `publish_status`

What Airflow owns:

- schedule and retries
- dependency orchestration
- alerting and runtime observability

What dbt owns:

- SQL graph
- tests
- lineage
- transformation semantics

## Task 4 — Databricks and dbt boundary

Recommended division:

- Databricks handles heavy compute, Spark ETL, and lakehouse-native processing
- dbt handles warehouse SQL modeling on top of curated tables already available in a SQL engine

Realistic example:

    raw files / streams
        ↓
    Databricks bronze / silver
        ↓
    curated warehouse tables or SQL-accessible serving layer
        ↓
    dbt marts and semantic modeling

Why this is a good boundary:

- Spark is better for distributed data preparation at scale
- dbt is better for analytical modeling, testing, and docs in the SQL layer
- mixing responsibilities too early creates operational confusion

## Task 5 — Observability and failure handling

Recommended checks:

- dbt test failures should fail CI or scheduled builds
- source freshness should alert when ingestion is stale
- Airflow should surface task-level runtime failures and retries
- GitHub Actions should expose PR validation status before merge

Short operational rule:

- do not treat a successful SQL execution as equivalent to a healthy pipeline
- pipeline health includes freshness, test results, run status, and deployment traceability
