# CI/CD with GitHub Actions, Airflow, and Databricks

## Task 1 — Create a PR Validation Workflow in GitHub Actions

### Goal

Learn how dbt is validated before merge.

### Input

You need a PR workflow that:

- checks out code
- installs dbt-snowflake
- creates a runtime `profiles.yml`
- runs `dbt deps`
- runs `dbt debug`
- runs `dbt build`

### Requirements

Write a GitHub Actions workflow YAML using repository secrets for Snowflake credentials.

### Expected Output

A complete `dbt-ci.yml` example.

### Extra Challenge

Modify the workflow to use:

    dbt build --select state:modified+ --defer --state artifacts/prod

and explain why that is useful.

--------------------------------------------------

## Task 2 — Create a Production Deploy Workflow in GitHub Actions

### Goal

Learn how merge-to-main deploy works.

### Input

You need a workflow that runs on:

    push to main

and deploys dbt to production.

### Requirements

Write a GitHub Actions workflow that:

- uses prod secrets
- creates a prod profile
- runs:
  - `dbt deps`
  - `dbt debug`
  - `dbt build --target prod`

### Expected Output

A complete `dbt-prod.yml` example.

### Extra Challenge

Add a second scheduled workflow for:

    dbt build --select tag:frequent_fact --target prod

running every 15 minutes.

--------------------------------------------------

## Task 3 — Create a Simple Airflow DAG for dbt

### Goal

Understand how Airflow orchestrates dbt.

### Input

You need a DAG that:

- runs `dbt deps`
- runs staging models
- runs facts
- keeps dependency order

### Requirements

Write a minimal Airflow DAG using `BashOperator`.

Explain:

- why Airflow should orchestrate rather than hold business SQL
- where retries and alerts belong

### Expected Output

A runnable DAG example.

### Extra Challenge

Add a note about where to inspect task logs and task status in Airflow.

--------------------------------------------------

## Task 4 — Trigger dbt from a Databricks Job

### Goal

Understand how dbt can be invoked after ingestion.

### Input

Assume Databricks performs ingestion and must then trigger dbt.

### Requirements

Write a small Python script that uses `subprocess.run()` to execute:

- `dbt deps`
- `dbt debug --target prod`
- `dbt build --select tag:frequent_fact --target prod`

Explain:

- why Databricks is not replacing dbt here
- why this pattern is useful after ingestion jobs

### Expected Output

A Python job example and explanation.

### Extra Challenge

Add a short note on where run logs and results would be visible in Databricks Workflows.

--------------------------------------------------

## Task 5 — Explain Observability and Reporting for dbt Runs

### Goal

Learn how teams monitor dbt runs.

### Input

Consider three runtime environments:

- GitHub Actions
- Airflow
- Databricks Jobs

### Requirements

Explain where to look for:

- success/failure status
- logs
- compiled SQL
- run results
- lineage graph without dbt Cloud

Mention:

- `logs/dbt.log`
- `target/compiled/`
- `target/run/`
- `run_results.json`
- `manifest.json`
- `dbt docs generate`
- `dbt docs serve`

### Expected Output

A practical monitoring guide.

### Extra Challenge

Add a short section describing how a team could push dbt artifacts into an internal reporting table for operational visibility.

