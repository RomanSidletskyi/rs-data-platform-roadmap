# Solution

## Task 1 — Generic tests for `fct_orders`

```yaml
version: 2

models:
  - name: fct_orders
    description: Curated fact table for order analytics.
    columns:
      - name: order_id
        description: Primary order identifier.
        tests:
          - not_null
          - unique
      - name: customer_id
        description: Foreign key to the customer dimension.
        tests:
          - not_null
          - relationships:
              to: ref('dim_customer')
              field: customer_id
      - name: order_status
        description: Business status for the order.
        tests:
          - accepted_values:
              values: ['created', 'paid', 'shipped', 'cancelled']
      - name: amount
        description: Monetary order amount.
```

What happens when tests fail in CI:

- dbt marks the run as failed
- the CI workflow should return a failed status for the pull request
- the bad change is blocked before promotion to shared environments

## Task 2 — Singular tests

Negative amount test:

```sql
select *
from {{ ref('fct_orders') }}
where amount < 0
```

Future event date test:

```sql
select *
from {{ ref('fct_orders') }}
where event_time > current_timestamp()
```

Why returning rows means failure:

- singular tests express invalid data as a query result set
- if the query returns one or more rows, dbt treats those rows as rule violations
- this is different from SQL syntax errors, where the statement itself cannot compile or execute

## Task 3 — Tags and selectors

Example `dbt_project.yml` fragment:

```yaml
models:
  analytics_project:
    marts:
      dimensions:
        +tags: ['daily']
      facts:
        +tags: ['frequent']
```

Example `selectors.yml`:

```yaml
selectors:
  - name: daily_dims
    definition:
      method: tag
      value: daily

  - name: frequent_facts
    definition:
      method: tag
      value: frequent
```

Run commands:

```bash
dbt build --selector daily_dims
dbt build --selector frequent_facts
```

Why frequent facts can still `ref()` dimensions not rebuilt every 15 minutes:

- `ref()` resolves dependency names, not necessarily rebuild cadence
- a fact model can read the latest persisted dimension table from a prior daily run
- the key requirement is that the dimension remains a stable trusted input

## Task 4 — Graph selection with `+`

Given:

    stg_orders
        ↓
    int_orders
        ↓
    fct_orders
        ↓
    rpt_sales

Selection behavior:

- `dbt build --select fct_orders`
  - selects only `fct_orders`
- `dbt build --select +fct_orders`
  - selects `stg_orders`, `int_orders`, and `fct_orders`
- `dbt build --select fct_orders+`
  - selects `fct_orders` and `rpt_sales`
- `dbt build --select +fct_orders+`
  - selects the full chain: `stg_orders`, `int_orders`, `fct_orders`, `rpt_sales`

Practical note:

- `+model` is safer when you need upstream correctness before rebuilding a downstream relation
- `model+` is useful when you are confident the upstream state is already valid and you only want downstream propagation
