# DBT Tests and Data Quality

## Why tests matter

dbt tests are one of the biggest reasons dbt is valuable in production.

They allow you to validate:

- uniqueness
- completeness
- referential integrity
- business rules

--------------------------------------------------

## Generic tests in YAML

Example:

    version: 2

    models:
      - name: fct_orders
        columns:
          - name: order_id
            tests:
              - not_null
              - unique

          - name: customer_id
            tests:
              - not_null
              - relationships:
                  to: ref('dim_customer')
                  field: customer_id

          - name: order_status
            tests:
              - accepted_values:
                  values: ['NEW', 'PAID', 'SHIPPED', 'CANCELLED']

--------------------------------------------------

## Important generic tests

`not_null`
- no null values allowed

`unique`
- no duplicates allowed

`relationships`
- foreign-key-like validation against another model

`accepted_values`
- only allowed values are accepted

--------------------------------------------------

## Singular tests

Singular tests are SQL files.

Example:

    select *
    from {{ ref('fct_orders') }}
    where amount < 0

If this query returns rows, the test fails.

--------------------------------------------------

## What happens when tests fail

In dbt, a test failure means:

- the SQL query ran successfully
- but it returned failing rows

This is different from a model execution error.

Result:

- `dbt test` exits with a failure code
- CI job may fail
- deployment may stop
- logs show which test failed

--------------------------------------------------

## Model run failure vs test failure

Model run failure:
- SQL itself failed
- missing column, syntax error, permission issue, etc.

Test failure:
- SQL ran, but data quality condition was violated

--------------------------------------------------

## Test configs and hierarchy

dbt supports data test configs with hierarchical precedence. Generic test instances in YAML can override generic SQL defaults, and both are more specific than `dbt_project.yml` settings. :contentReference[oaicite:6]{index=6}

--------------------------------------------------

## Where to run tests

Typical production approach:

- tests for staging and marts run in CI
- critical business tests run in deploy jobs
- lightweight tests may use a smaller Snowflake warehouse than heavy build models

Snowflake-specific config supports `snowflake_warehouse` for tests too. :contentReference[oaicite:7]{index=7}

--------------------------------------------------

## Reporting failed tests

Common approaches:

- CI pipeline fails and notifies team
- Airflow task fails and alerts
- test results are exported or stored
- dbt artifacts are parsed into monitoring tables
- Slack / Teams notifications on failed jobs

