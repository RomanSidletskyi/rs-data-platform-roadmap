# 01 Delta Batch Repairable Orders Lab

## Project Goal

Design a Delta Lake batch pipeline for orders that is easy to repair, safe to rerun, and clear about rewrite boundaries.

## Scenario

A data platform lands raw order events daily.

The team needs a Delta-based flow that:

- ingests raw orders into a bronze-like Delta table
- normalizes them into a silver Delta table
- publishes one gold daily sales output
- supports bounded repair for one or a few affected business dates

## Project Type

This folder is a guided project, not a ready implementation.

If you want a solved comparison after finishing your own design, use the sibling reference example:

- `08-delta-lake/pet-projects/reference_example_delta_batch_repairable_orders_lab`

## Expected Deliverables

- bronze, silver, and gold table definitions
- one bounded-rewrite strategy for repair
- one note explaining when `MERGE` is and is not needed
- one short validation approach for daily output correctness

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `artifacts/README.md`
- `run_lab.sh`
- `config/README.md`
- `data/README.md`
- `src/README.md`
- `tests/README.md`
- `config/orders_pipeline_template.yaml`
- `data/sample_orders_raw.jsonl`
- `data/sample_bad_orders_raw.jsonl`
- `src/check_orders_delta_contract.py`
- `src/preview_repair_window.py`
- `src/plan_batch_repair.py`
- `src/run_local_batch_pipeline.py`
- `src/rebuild_gold_for_business_date.sql`
- `tests/fixture_expected_schema_check.txt`
- `tests/fixture_expected_repair_window.json`
- `tests/fixture_expected_repair_plan.json`
- `tests/fixture_expected_local_batch_pipeline.json`
- `tests/verify_delta_batch_assets.sh`

## Definition Of Done

The lab explains not only how the Delta writes work, but also how the tables remain safe to rerun and repair without broad rewrites by default.

## Quick Local Verification

Run:

`bash tests/verify_delta_batch_assets.sh`

Or inspect the local pipeline skeleton directly:

`python3 src/run_local_batch_pipeline.py config/orders_pipeline_template.yaml data/sample_orders_raw.jsonl 2026-04-01`

Or materialize an artifact file locally:

`python3 src/run_local_batch_pipeline.py config/orders_pipeline_template.yaml data/sample_orders_raw.jsonl 2026-04-01 artifacts/daily_sales_preview.json`

Or run the whole local starter flow in one command:

`bash run_lab.sh`
