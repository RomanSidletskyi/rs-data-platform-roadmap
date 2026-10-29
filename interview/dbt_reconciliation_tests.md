# dbt Reconciliation Tests

## Goal

This file shows a practical way to validate dbt transformations by comparing aggregated values in the final model with aggregated values in the source table.

The most common example is:

- compare total amount in source
- compare total amount in transformed table
- fail the test if the difference is not acceptable

---

## Key dbt Rule

In dbt, a test passes when the SQL query returns zero rows.

So for reconciliation, the test should:

- calculate source totals
- calculate target totals
- return a row only if the totals do not match

---

## Simplest Practical Example

Assume:

- source table: `raw.orders_brand_1`
- final model: `fct_orders_brand_1`
- field to compare: `amount`

Create a singular test:

Path:

`tests/test_orders_brand_1_amount_reconciliation.sql`

```sql
with source_total as (
    select coalesce(sum(amount), 0) as total_amount
    from {{ source('raw_brand_1', 'orders_brand_1') }}
),
target_total as (
    select coalesce(sum(amount), 0) as total_amount
    from {{ ref('fct_orders_brand_1') }}
)

select
    s.total_amount as source_total,
    t.total_amount as target_total,
    s.total_amount - t.total_amount as diff
from source_total s
cross join target_total t
where s.total_amount <> t.total_amount
```

If the totals are different, the query returns one row and the test fails.

---

## More Realistic Example With Date Filter

Usually you do not compare the full historical table every time.

In practice, it is often better to compare only the latest loaded period.

```sql
with source_total as (
    select coalesce(sum(amount), 0) as total_amount
    from {{ source('raw_brand_1', 'orders_brand_1') }}
    where order_dt >= current_date - 1
),
target_total as (
    select coalesce(sum(amount), 0) as total_amount
    from {{ ref('fct_orders_brand_1') }}
    where order_dt >= current_date - 1
)

select
    s.total_amount as source_total,
    t.total_amount as target_total,
    s.total_amount - t.total_amount as diff
from source_total s
cross join target_total t
where s.total_amount <> t.total_amount
```

This is much more practical for incremental loads.

---

## Better Version With Tolerance

Sometimes exact equality is too strict because of:

- rounding
- late updates
- accepted small differences

Then use tolerance.

```sql
with source_total as (
    select coalesce(sum(amount), 0) as total_amount
    from {{ source('raw_brand_1', 'orders_brand_1') }}
    where order_dt >= current_date - 1
),
target_total as (
    select coalesce(sum(amount), 0) as total_amount
    from {{ ref('fct_orders_brand_1') }}
    where order_dt >= current_date - 1
)

select
    s.total_amount as source_total,
    t.total_amount as target_total,
    abs(s.total_amount - t.total_amount) as abs_diff
from source_total s
cross join target_total t
where abs(s.total_amount - t.total_amount) > 0.01
```

---

## Best Practical Pattern: Compare By Business Grain

Comparing one grand total is useful, but often not enough.

The stronger test is to compare totals by a business dimension such as:

- day
- brand
- country
- channel

Example by day:

```sql
with source_agg as (
    select
        order_dt,
        coalesce(sum(amount), 0) as source_amount
    from {{ source('raw_brand_1', 'orders_brand_1') }}
    where order_dt >= current_date - 7
    group by order_dt
),
target_agg as (
    select
        order_dt,
        coalesce(sum(amount), 0) as target_amount
    from {{ ref('fct_orders_brand_1') }}
    where order_dt >= current_date - 7
    group by order_dt
)

select
    coalesce(s.order_dt, t.order_dt) as order_dt,
    coalesce(s.source_amount, 0) as source_amount,
    coalesce(t.target_amount, 0) as target_amount,
    coalesce(s.source_amount, 0) - coalesce(t.target_amount, 0) as diff
from source_agg s
full outer join target_agg t
    on s.order_dt = t.order_dt
where coalesce(s.source_amount, 0) <> coalesce(t.target_amount, 0)
```

This is better because it shows exactly where the mismatch happened.

---

## If You Have 9 Brands

If you have the same reconciliation logic across brands, do not duplicate the whole test 9 times manually.

A practical pattern is:

- create one reusable macro
- pass source name, table name, model name, and filter field as parameters
- reuse the test pattern per brand

---

## Reusable Macro Example

Path:

`macros/tests/reconcile_sum.sql`

```sql
{% test reconcile_sum(model, source_name, source_table, source_column, target_column, filter_sql='1=1') %}

with source_total as (
    select coalesce(sum({{ source_column }}), 0) as total_value
    from {{ source(source_name, source_table) }}
    where {{ filter_sql }}
),
target_total as (
    select coalesce(sum({{ target_column }}), 0) as total_value
    from {{ model }}
    where {{ filter_sql }}
)

select
    s.total_value as source_total,
    t.total_value as target_total,
    s.total_value - t.total_value as diff
from source_total s
cross join target_total t
where s.total_value <> t.total_value

{% endtest %}
```

Then call it in YAML.

```yaml
version: 2

models:
  - name: fct_orders_brand_1
    tests:
      - reconcile_sum:
          source_name: raw_brand_1
          source_table: orders_brand_1
          source_column: amount
          target_column: amount
          filter_sql: "order_dt >= current_date - 1"
```

---

## How To Run It After Transformations

Option 1:

```bash
dbt run --select fct_orders_brand_1
dbt test --select fct_orders_brand_1
```

Option 2:

```bash
dbt build --select fct_orders_brand_1
```

`dbt build` is often better because it runs model build plus tests in one flow.

---

## What To Say In Interview

I usually implement reconciliation as a dbt test that compares aggregated values between the source and the transformed model. In dbt, the test query should return rows only if there is a mismatch, so I calculate totals on both sides and fail the test when the numbers are different. In practice, I prefer comparing by a business grain like day or brand instead of only one global total, because that makes mismatches easier to debug. If the same logic is needed for multiple brands, I move the reconciliation pattern into a reusable custom test macro.

---

## Short Version

I create a custom dbt test that aggregates source and target values, joins the results, and returns rows only when the totals do not match.

---

## Practical Notes

- use exact equality only if the business logic really requires it
- for incremental models, compare only the relevant load window
- if possible, compare by business grain, not only by one global sum
- for repeated brand logic, use a reusable custom test macro
- run reconciliation tests as part of `dbt build` or immediately after `dbt run`