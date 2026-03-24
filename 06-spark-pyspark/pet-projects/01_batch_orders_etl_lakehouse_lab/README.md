# 01 Batch Orders ETL Lakehouse Lab

## Project Goal

Build a Spark-shaped batch ETL pipeline that turns raw order events into curated daily analytical output.

## Scenario

An object-storage landing zone receives raw order events from an operational platform.

The data is not ready for analytics yet because it contains:

- inconsistent country codes
- malformed rows
- mixed operational fields that should not all reach the final analytical layer

Your task is to design a Spark job that creates a clean daily gold-style dataset.

## Project Type

This folder is a guided project, not a ready solution.

The starter assets help you reason about:

- raw-to-curated transformation boundaries
- business grain
- schema and data-quality checks
- daily output shape for analytical consumers

If you want a ready implementation afterwards for comparison, use the separate sibling reference project:

- `06-spark-pyspark/pet-projects/reference_example_batch_orders_etl_lakehouse_lab`

## Expected Deliverables

- a batch processing plan with bronze, silver, and gold responsibilities
- a curated output definition with explicit grain
- a strategy for invalid-record handling
- a note about partitioning and replay behavior
- a working transformation of the sample dataset into a daily summary

## Starter Assets Already Provided

- `.env.example`
- `src/preview_daily_orders_gold.py`
- `src/check_orders_schema_contract.py`
- `data/sample_orders_raw.jsonl`
- `data/sample_bad_orders_raw.jsonl`
- `tests/fixture_expected_daily_orders_gold.json`
- `tests/fixture_expected_schema_check.txt`
- `tests/verify_batch_orders_assets.sh`
- `src/README.md`
- `data/README.md`
- `tests/README.md`
- `config/README.md`
- `docker/README.md`
- `architecture.md`

## Definition Of Done

The lab demonstrates Spark as a batch modeling layer that converts messy landed data into a consumer-friendly daily analytical dataset with explicit grain and replay thinking.