# Reference Example - Batch Orders ETL Lakehouse Lab

This folder contains a ready reference implementation for the guided batch orders ETL lab.

You should attempt the guided project first:

- `06-spark-pyspark/pet-projects/01_batch_orders_etl_lakehouse_lab`

## What This Reference Example Demonstrates

- batch-oriented raw-to-curated reasoning
- explicit daily analytical grain
- simple schema-contract review for bad landed records
- deterministic preview output for a gold-style daily summary

## Folder Overview

- `.env.example` for local path placeholders
- `src/preview_daily_orders_gold.py` for a deterministic daily gold preview
- `src/check_orders_schema_contract.py` for simple raw-schema review
- `data/sample_orders_raw.jsonl` and `data/sample_bad_orders_raw.jsonl` as replayable inputs
- `tests/fixture_expected_daily_orders_gold.json` and `tests/fixture_expected_schema_check.txt` as expected outputs
- `tests/verify_batch_orders_assets.sh` for a smoke check
- `architecture.md` for target pipeline reasoning