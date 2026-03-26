# Jinja, Macros, and generate_schema_name

## Task 1 — Write a Reusable safe_cast Macro

### Goal

Learn how macros generate reusable SQL.

### Input

You often need:

    try_cast(payload:amount as number(18,2))

in many models.

### Requirements

Create a macro:

- name: `safe_cast`
- parameters: expression, data_type
- return SQL using `try_cast`

Then show how it would be used inside a staging model.

### Expected Output

One macro definition and one example usage.

### Extra Challenge

Add a second example for timestamps.

--------------------------------------------------

## Task 2 — Write a deduplicate_latest Macro

### Goal

Practice writing a production-style macro.

### Input

You want to keep only the latest record per `order_id`.

### Requirements

Create a macro that accepts:

- relation
- key
- order_by

The macro should return SQL using `row_number()` and `rn = 1`.

### Expected Output

A macro definition plus an example usage against `ref('stg_orders')`.

### Extra Challenge

Add simple argument validation with `exceptions.raise_compiler_error`.

--------------------------------------------------

## Task 3 — Implement generate_schema_name

### Goal

Understand how dbt builds final schemas across environments.

### Input

You have:

- dev target schema = `dbt_ivan`
- qa target schema = `dbt_ci`
- prod target schema = `analytics`

You want:

- dev staging → `dbt_ivan_staging`
- qa marts → `dbt_ci_marts`
- prod staging → `staging`
- prod marts → `marts`

### Requirements

Write a custom `generate_schema_name` macro implementing this behavior.

Explain:

- why developers should not write into a shared `staging` schema
- why production should remain clean
- why dbt calls this macro automatically

### Expected Output

A complete macro and a short explanation.

### Extra Challenge

Add a short note explaining where `custom_schema_name` comes from.

