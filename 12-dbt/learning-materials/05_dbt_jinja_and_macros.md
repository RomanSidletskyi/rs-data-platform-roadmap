# DBT Jinja and Macros

## Jinja in dbt

dbt uses Jinja as a templating layer on top of SQL.

Jinja lets you use:

- variables
- conditionals
- loops
- macros
- helper functions

Example:

    {% if is_incremental() %}
        where updated_at > ...
    {% endif %}

--------------------------------------------------

## What a macro is

A macro is reusable Jinja + SQL logic.

It is not executed by Snowflake directly.
dbt expands the macro into SQL before execution.

Example:

    {% macro safe_cast(expression, data_type) %}
        try_cast({{ expression }} as {{ data_type }})
    {% endmacro %}

Used in a model:

    select
        {{ safe_cast("payload:amount", "number(18,2)") }} as amount
    from {{ source('raw', 'orders') }}

--------------------------------------------------

## Why macros matter

Macros are useful when:

- logic repeats
- SQL should be standardized
- dynamic generation is needed
- environment-aware behavior is needed

Typical macro use cases:

- safe casts
- audit columns
- incremental lookback filters
- deduplication helpers
- schema naming
- surrogate keys

--------------------------------------------------

## generate_schema_name

This is one of the most important dbt macros in real projects.

dbt generates custom schema names by combining the target schema and the custom schema.
Default behavior appends custom schema to the target schema. :contentReference[oaicite:2]{index=2}

Example custom macro:

    {% macro generate_schema_name(custom_schema_name, node) -%}
        {%- set default_schema = target.schema -%}

        {%- if target.name == 'prod' -%}
            {{ custom_schema_name if custom_schema_name is not none else default_schema }}
        {%- else -%}
            {{ default_schema }}{% if custom_schema_name is not none %}_{{ custom_schema_name }}{% endif %}
        {%- endif -%}
    {%- endmacro %}

What it does:

in dev:
- target.schema = `dbt_ivan`
- model custom schema = `staging`
- final schema = `dbt_ivan_staging`

in prod:
- target.name = `prod`
- custom schema = `staging`
- final schema = `staging`

Why this is useful:

- developers do not overwrite each other
- production schemas stay clean
- the same code works across environments

--------------------------------------------------

## Important note about `generate_schema_name`

You never manually call it in models.

dbt calls it automatically when building the final schema for a model. :contentReference[oaicite:3]{index=3}

Example mental flow:

- `profiles.yml` gives target.schema = `dbt_ivan`
- `dbt_project.yml` sets `+schema: marts`
- dbt calls `generate_schema_name('marts', current_model)`
- result = `dbt_ivan_marts`

--------------------------------------------------

## Production-ready macro practices

Good macros should have:

- clear names
- limited responsibility
- optional argument validation
- logging if needed
- simple generated SQL

Example:

    {% macro deduplicate_latest(relation, key, order_by) %}

        {% if relation is none %}
            {{ exceptions.raise_compiler_error("relation is required") }}
        {% endif %}

        select *
        from (
            select
                *,
                row_number() over (
                    partition by {{ key }}
                    order by {{ order_by }}
                ) as rn
            from {{ relation }}
        )
        where rn = 1

    {% endmacro %}

--------------------------------------------------

## Useful built-in macros and variables

Common built-ins:

- `ref()`
- `source()`
- `this`
- `var()`
- `target`
- `is_incremental()`

These are foundational to how dbt behaves.

