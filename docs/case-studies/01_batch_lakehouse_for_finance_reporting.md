# Batch Lakehouse For Finance Reporting

## Background

A retail company needs trusted finance reporting every morning by 7 AM.

The reporting scope includes:

- gross revenue
- net revenue after refunds
- margin by product category
- daily order trends

Source systems are operational and not designed for analytical querying.

## Problem

The business needs stable, auditable numbers.

The platform must therefore optimize for:

- trusted daily outputs
- safe reruns
- historical corrections
- raw-data preservation for investigation

Low-latency reporting is not the main goal.

## Architecture Overview

Typical shape:

    source extracts
        -> raw landing
        -> validation and normalization
        -> bronze / silver / gold analytical layers
        -> finance marts
        -> dashboards and exports

The architecture preserves raw data first, then applies technical cleanup, then business logic.

## Why This Shape Makes Sense

- finance needs reproducible numbers more than second-level freshness
- reruns and backfills are normal, so raw preservation matters
- business-facing marts should be isolated from source schema noise
- a lakehouse model supports historical depth plus layered curation

## Technologies Used

Possible technology shape:

- source databases or file extracts
- object storage or ADLS for landing
- Spark or Databricks for transformations
- Delta Lake or similar table format for reliable tables
- Power BI or another BI tool for final consumption

The exact tools matter less than the layered design and recovery posture.

## Main Trade-Offs

Benefits:

- strong historical traceability
- safer backfills
- curated business-serving layer
- lower complexity than continuous streaming when daily cadence is enough

Drawbacks:

- not suitable for real-time operational reaction
- late corrections may appear only in the next reporting cycle unless special handling exists
- data contracts across layers still require discipline

## Simpler Alternative

A simpler alternative is direct BI access to source tables or a light warehouse extract with little layering.

That may work early, but it usually breaks when:

- source load becomes sensitive
- business metrics require stable definitions
- historical fixes need replay or backfill

## What To Look At In Review

- where raw truth is preserved before transformations
- whether one day or one partition can be rerun safely
- whether refunds and late-arriving records are modeled clearly
- whether BI touches only curated layers
- whether reporting truth is separated from operational truth

## What Would Be Bad Here

- full-history refresh every morning without need
- no raw landing, so debugging depends on source system access only
- direct dashboard reads from source tables
- finance logic hidden in dashboard SQL instead of shared marts

## Lessons Learned

- batch remains a strong architecture when schedule-driven trust matters more than low latency
- finance platforms usually need layered storage and explicit rerun strategy
- lakehouse value comes from operational boundaries between raw, cleaned, and curated layers, not from the label alone

## Read With

- `../architecture/02_batch_architecture/README.md`
- `../architecture/04_lakehouse_architecture/README.md`
- `../system-design/batch-etl.md`
- `../trade-offs/kafka-vs-batch-ingestion.md`