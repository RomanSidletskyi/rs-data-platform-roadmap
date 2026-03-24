# Tests, Tags, Selectors, and DAG

## Task 1 — Add Generic Tests to a Fact Model

### Goal

Learn how to protect data quality using YAML tests.

### Input

Use a `fct_orders` model with:

- order_id
- customer_id
- order_status
- amount

### Requirements

Write a YAML file that adds:

- `not_null` and `unique` to order_id
- `not_null` and `relationships` to customer_id
- `accepted_values` to order_status

### Expected Output

A model YAML block.

### Extra Challenge

Explain what happens operationally when these tests fail in CI.

--------------------------------------------------

## Task 2 — Write a Singular Test

### Goal

Learn how singular tests work.

### Input

Business rule:
no order amount may be negative.

### Requirements

Write a singular SQL test that fails when amount is negative.

Explain:

- why the test fails if rows are returned
- how this differs from a SQL syntax error

### Expected Output

A singular test SQL file and short explanation.

### Extra Challenge

Add a second singular test for future event dates.

--------------------------------------------------

## Task 3 — Use Tags and Selectors for Daily and Frequent Jobs

### Goal

Learn how to split dbt runs by cadence.

### Input

You have:

- dimensions refreshed once a day
- frequent facts refreshed every 15 minutes

### Requirements

Do the following:

- show how to assign tags using `dbt_project.yml`
- create a `selectors.yml` with:
  - `daily_dims`
  - `frequent_facts`
- show commands to run both selectors

### Expected Output

Example `dbt_project.yml`, `selectors.yml`, and run commands.

### Extra Challenge

Explain why a fact model can still `ref()` a dimension that is not rebuilt every 15 minutes.

--------------------------------------------------

## Task 4 — Practice Graph Selection with +

### Goal

Learn how `+` changes dbt selection.

### Input

Assume graph:

    stg_orders
        ↓
    int_orders
        ↓
    fct_orders
        ↓
    rpt_sales

### Requirements

Explain what each command selects:

    dbt build --select fct_orders
    dbt build --select +fct_orders
    dbt build --select fct_orders+
    dbt build --select +fct_orders+

### Expected Output

A clear explanation of the selected graph in each case.

### Extra Challenge

Add a practical note on when `+model` is safer than `model+`.

