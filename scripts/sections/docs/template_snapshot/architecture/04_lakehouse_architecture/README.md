# Lakehouse Architecture

## What This Topic Is For

Lakehouse architecture combines scalable storage, reliable table semantics, and multi-stage transformation design for analytical platforms.

Use this topic to understand how ingestion, storage layout, transformation layers, and BI-ready serving fit into one coherent system.

## Typical Architecture

    Ingestion -> Bronze -> Silver -> Gold -> BI / ML / Serving

## When A Lakehouse Is A Strong Fit

- analytics platforms
- multi-stage transformations
- historical retention
- large-scale processing
- platforms that need raw preservation and curated outputs at the same time

## When A Lakehouse Is A Weak Fit

- tiny local workflows
- simple single-table reporting
- cases where a lightweight warehouse or database already solves the need directly

## What To Pay Attention To

- whether raw data is preserved before business transformations
- whether bronze, silver, and gold have distinct responsibilities
- why a table format such as Delta or Iceberg matters operationally
- how compute engines and storage boundaries interact
- where data contracts become stable enough for BI and downstream consumers

## Good Architecture Signals

- raw, cleaned, and business-serving layers are clearly separated
- data repair and replay are possible without rebuilding the whole platform blindly
- storage layout supports several downstream consumers without exposing raw chaos directly

## Common Mistakes

- calling any data lake with Parquet files a lakehouse
- skipping bronze and losing forensic or replay value
- exposing silver or raw data directly to dashboards
- treating table format features as optional until failures happen

## Real Examples To Think Through

- Databricks plus ADLS plus Delta medallion pipeline
- event ingestion into bronze followed by dbt or Spark-curated marts
- rebuilding gold models after a bug in silver transformations

Worked example:

- `worked_example_retail_lakehouse_layers.md`

## Interview Questions

- What is a lakehouse?
- Why use Delta Lake instead of plain Parquet?
- What is medallion architecture?
- Why separate bronze, silver, and gold?

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_retail_lakehouse_layers.md`
- `../../system-design/README.md`
- `../../trade-offs/README.md`

## Completion Checklist

- [ ] I understand what a lakehouse solves
- [ ] I understand bronze, silver, and gold layers
- [ ] I understand why table formats matter
