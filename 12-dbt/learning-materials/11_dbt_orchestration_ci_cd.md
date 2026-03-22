# DBT Orchestration, Deployment, CI/CD, and Monitoring

## Who should do what

Good responsibility split:

dbt:
- transformations
- tests
- docs
- lineage

Airflow:
- orchestration
- retries
- cross-system dependencies

Databricks:
- ingestion
- heavy processing
- streaming
- Spark jobs

GitHub Actions:
- CI/CD
- PR checks
- production deploy jobs

--------------------------------------------------

## dbt commands you should know

Install dependencies:

    dbt deps

Checks package installation from `packages.yml` and downloads packages into `dbt_packages`.

Check profile and connection:

    dbt debug

This validates profile resolution and warehouse connectivity.

Build everything selected:

    dbt build --select tag:hourly

`dbt build` includes run + test + seed + snapshot where relevant.

--------------------------------------------------

## How to run by tags, names, paths

By name:

    dbt build --select fct_orders

By path:

    dbt build --select marts.facts

By tag:

    dbt build --select tag:daily_dimension

By state:

    dbt build --select state:modified+

--------------------------------------------------

## What `state:modified+` means

dbt can compare current code to artifacts from a previous environment state.
Together with `--defer`, this enables Slim CI. :contentReference[oaicite:13]{index=13}

`state:modified`
- resources changed compared to prior state

`state:modified+`
- changed resources plus their downstream dependents

--------------------------------------------------

## What `--defer` means

`--defer` tells dbt to resolve unselected upstream references against an existing state, typically production, instead of rebuilding everything upstream. It requires prior artifacts such as `manifest.json`, usually passed through `--state`. :contentReference[oaicite:14]{index=14}

Typical Slim CI command:

    dbt build \
      --select state:modified+ \
      --defer \
      --state path/to/prod_artifacts

What this does:

- build only modified models and their downstreams
- use production-built upstream models for the rest
- reduce runtime and cost

When useful:
- PR validation
- large dbt projects
- expensive Snowflake environments

When to be careful:
- when changing base staging/source logic
- when major upstream contract changes are involved

--------------------------------------------------

## Real GitHub Actions example for PR validation

    name: dbt CI

    on:
      pull_request:
        branches:
          - main

    jobs:
      dbt-ci:
        runs-on: ubuntu-latest

        env:
          SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
          SNOWFLAKE_USER: ${{ secrets.SNOWFLAKE_USER }}
          SNOWFLAKE_PASSWORD: ${{ secrets.SNOWFLAKE_PASSWORD }}
          SNOWFLAKE_ROLE: ${{ secrets.SNOWFLAKE_ROLE }}
          SNOWFLAKE_DATABASE: ${{ secrets.SNOWFLAKE_QA_DATABASE }}
          SNOWFLAKE_WAREHOUSE: ${{ secrets.SNOWFLAKE_QA_WAREHOUSE }}
          SNOWFLAKE_SCHEMA: dbt_ci

        steps:
          - name: Checkout repository
            uses: actions/checkout@v4

          - name: Set up Python
            uses: actions/setup-python@v5
            with:
              python-version: "3.11"

          - name: Install dbt
            run: |
              pip install dbt-snowflake

          - name: Create dbt profile
            run: |
              mkdir -p ~/.dbt
              cat > ~/.dbt/profiles.yml <<EOF2
              analytics_dbt:
                target: qa
                outputs:
                  qa:
                    type: snowflake
                    account: "${SNOWFLAKE_ACCOUNT}"
                    user: "${SNOWFLAKE_USER}"
                    password: "${SNOWFLAKE_PASSWORD}"
                    role: "${SNOWFLAKE_ROLE}"
                    database: "${SNOWFLAKE_DATABASE}"
                    warehouse: "${SNOWFLAKE_WAREHOUSE}"
                    schema: "${SNOWFLAKE_SCHEMA}"
                    threads: 4
              EOF2

          - name: Install packages
            run: dbt deps

          - name: Check connection
            run: dbt debug

          - name: Build modified resources with defer
            run: |
              dbt build \
                --select state:modified+ \
                --defer \
                --state artifacts/prod

--------------------------------------------------

## Real GitHub Actions example for deploy to prod after merge

    name: dbt Production Deploy

    on:
      push:
        branches:
          - main

    jobs:
      dbt-prod:
        runs-on: ubuntu-latest

        env:
          SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
          SNOWFLAKE_USER: ${{ secrets.SNOWFLAKE_PROD_USER }}
          SNOWFLAKE_PASSWORD: ${{ secrets.SNOWFLAKE_PROD_PASSWORD }}
          SNOWFLAKE_ROLE: ${{ secrets.SNOWFLAKE_PROD_ROLE }}
          SNOWFLAKE_DATABASE: ${{ secrets.SNOWFLAKE_PROD_DATABASE }}
          SNOWFLAKE_WAREHOUSE: ${{ secrets.SNOWFLAKE_PROD_WAREHOUSE }}
          SNOWFLAKE_SCHEMA: analytics

        steps:
          - uses: actions/checkout@v4

          - uses: actions/setup-python@v5
            with:
              python-version: "3.11"

          - run: pip install dbt-snowflake

          - name: Create dbt profile
            run: |
              mkdir -p ~/.dbt
              cat > ~/.dbt/profiles.yml <<EOF2
              analytics_dbt:
                target: prod
                outputs:
                  prod:
                    type: snowflake
                    account: "${SNOWFLAKE_ACCOUNT}"
                    user: "${SNOWFLAKE_USER}"
                    password: "${SNOWFLAKE_PASSWORD}"
                    role: "${SNOWFLAKE_ROLE}"
                    database: "${SNOWFLAKE_DATABASE}"
                    warehouse: "${SNOWFLAKE_WAREHOUSE}"
                    schema: "${SNOWFLAKE_SCHEMA}"
                    threads: 8
              EOF2

          - run: dbt deps
          - run: dbt debug
          - run: dbt build --target prod

--------------------------------------------------

## Simple scheduled GitHub job

    name: dbt Frequent Facts

    on:
      schedule:
        - cron: "*/15 * * * *"
      workflow_dispatch:

    jobs:
      run-frequent-facts:
        runs-on: ubuntu-latest

        steps:
          - uses: actions/checkout@v4
          - uses: actions/setup-python@v5
            with:
              python-version: "3.11"
          - run: pip install dbt-snowflake
          - run: dbt deps
          - run: dbt build --select tag:frequent_fact --target prod

--------------------------------------------------

## Airflow example

    from airflow import DAG
    from airflow.operators.bash import BashOperator
    from datetime import datetime

    with DAG(
        dag_id="dbt_sales_pipeline",
        start_date=datetime(2025, 1, 1),
        schedule_interval="*/15 * * * *",
        catchup=False,
    ) as dag:

        dbt_deps = BashOperator(
            task_id="dbt_deps",
            bash_command="cd /opt/pipelines/dbt && dbt deps"
        )

        dbt_build_staging = BashOperator(
            task_id="dbt_build_staging",
            bash_command="cd /opt/pipelines/dbt && dbt build --select tag:staging --target prod"
        )

        dbt_build_facts = BashOperator(
            task_id="dbt_build_facts",
            bash_command="cd /opt/pipelines/dbt && dbt build --select tag:frequent_fact --target prod"
        )

        dbt_deps >> dbt_build_staging >> dbt_build_facts

Good use case:
- ingestion completed
- Airflow then triggers dbt
- Airflow handles retries and alerts

--------------------------------------------------

## Databricks job example

In Databricks Workflows, a Python task can invoke dbt CLI if the environment has dbt installed.

    import subprocess

    commands = [
        "dbt deps",
        "dbt debug --target prod",
        "dbt build --select tag:frequent_fact --target prod"
    ]

    for cmd in commands:
        result = subprocess.run(
            cmd,
            shell=True,
            check=False,
            capture_output=True,
            text=True
        )
        print(result.stdout)
        print(result.stderr)

        if result.returncode != 0:
            raise RuntimeError(f"Command failed: {cmd}")

Better use case:
- Databricks does ingestion / PySpark work
- then invokes dbt as the warehouse transformation layer

--------------------------------------------------

## Where to see execution results

Local / CI:

- terminal output
- `logs/dbt.log`
- `target/run_results.json`
- `target/manifest.json`

Compiled SQL:

- `target/compiled/`
- `target/run/`

These are essential for debugging.

--------------------------------------------------

## How to see lineage graph without dbt Cloud

Use dbt docs:

    dbt docs generate
    dbt docs serve

dbt docs commands generate documentation artifacts and a local browsable site. Even when compilation is skipped in some cases, special macros such as `generate_schema_name` are still part of parsing behavior. :contentReference[oaicite:15]{index=15}

What you get:
- model descriptions
- column docs
- lineage graph
- test info
- source-to-model dependencies

This is the standard local alternative to dbt Cloud graph browsing.

--------------------------------------------------

## Reporting and monitoring job success/failure

Common real-world patterns:

1. CI/CD status
- GitHub Actions shows passed / failed jobs
- PR checks block merge if failing

2. Airflow UI
- task success / fail history
- retries
- execution duration
- logs

3. Databricks Jobs / Workflows UI
- run history
- task logs
- alerting

4. dbt artifacts
- parse `run_results.json`
- parse `manifest.json`
- store in monitoring tables

5. Notifications
- Slack / Teams alerts on failed jobs
- email alerts on DAG failures

--------------------------------------------------

## Recommended reporting setup

Good production setup:

- GitHub Actions for CI status and deploy status
- Airflow or Databricks Workflows for orchestration status
- dbt docs for lineage and docs
- artifacts loaded into a small ops mart for historical reporting

