# DBT ref, source, selection, DAG, and selectors

## ref()

`ref()` references another dbt model.

Example:

    select *
    from {{ ref('stg_orders') }}

What it gives:

- dependency in the DAG
- correct object name resolution
- safe refactoring
- lineage

--------------------------------------------------

## source()

`source()` references an external source declared in YAML.

Example:

    select *
    from {{ source('raw', 'kafka_orders') }}

--------------------------------------------------

## DAG behavior

dbt uses `ref()` and `source()` to construct the graph.

Example:

    stg_orders
        ↓
    int_orders
        ↓
    fct_orders

`dbt build` executes this in order automatically.

--------------------------------------------------

## The `+` graph operator

The `+` operator expands selection to include ancestors or descendants of a resource. :contentReference[oaicite:8]{index=8}

Practical meaning:

`+model_name`
- include upstream dependencies

`model_name+`
- include downstream dependents

`+model_name+`
- include both upstream and downstream

Example:

    dbt build --select +fct_orders

This selects:

- all models required to build `fct_orders`
- and `fct_orders` itself

Example:

    dbt build --select fct_orders+

This selects:

- `fct_orders`
- all downstream models depending on it

Example:

    dbt build --select +fct_orders+

This selects the full neighborhood of `fct_orders` in both directions.

--------------------------------------------------

## Tags

Tags are labels attached to models, tests, sources, snapshots, and other resources. They can be configured in YAML or project config, and are selectable with node selection syntax. :contentReference[oaicite:9]{index=9}

Example in model config:

    {{ config(tags=['hourly', 'sales']) }}

Example in YAML:

    version: 2

    models:
      - name: fct_orders
        config:
          tags: ['hourly', 'sales']

Example in `dbt_project.yml`:

    models:
      my_project:
        marts:
          facts:
            +tags: ['frequent_fact']

--------------------------------------------------

## Why tags matter

Tags are used for:

- selecting subsets of models
- separating daily vs hourly jobs
- domain-based jobs
- different deployment cadences
- targeted testing

Example:

    dbt build --select tag:daily_dimension

With graph operator:

    dbt build --select tag:daily_dimension+

--------------------------------------------------

## Selectors

dbt supports named selectors in `selectors.yml`. Node selection syntax applies across commands such as `run`, `build`, `test`, and `ls`. :contentReference[oaicite:10]{index=10}

Example:

    selectors:
      - name: daily_dims
        definition:
          method: tag
          value: daily_dimension

      - name: frequent_facts
        definition:
          method: tag
          value: frequent_fact

Run:

    dbt build --selector daily_dims
    dbt build --selector frequent_facts

--------------------------------------------------

## Run by name, path, tag

By model name:

    dbt build --select fct_orders

By folder path:

    dbt build --select marts.facts

By tag:

    dbt build --select tag:hourly

By state:

    dbt build --select state:modified+

--------------------------------------------------

## Re-run patterns

Re-run one model:

    dbt build --select fct_orders

Re-run model and its children:

    dbt build --select fct_orders+

Re-run model and required upstreams:

    dbt build --select +fct_orders

Re-run everything around it:

    dbt build --select +fct_orders+

