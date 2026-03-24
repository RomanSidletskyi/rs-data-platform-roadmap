# 02 Delta CDC Customer State Lab

## Project Goal

Design a Delta Lake lab that turns customer change events into a reliable current-state table and a clearly justified history strategy.

## Scenario

A CRM system produces inserts, updates, and occasional duplicate change events for customers.

The team needs a Delta design that:

- ingests CDC records safely
- defines a stable business key and winner logic
- publishes a latest-state customer table
- explains whether a separate history-preserving view or table is needed

## Project Type

This folder is a guided project, not a ready implementation.

## Expected Deliverables

- one CDC ingestion shape
- one `MERGE` strategy with explicit precedence logic
- one explanation of current-state versus history needs
- one short note about replay and duplicate handling

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `artifacts/README.md`
- `run_lab.sh`
- `config/README.md`
- `data/README.md`
- `src/README.md`
- `tests/README.md`
- `config/customer_cdc_rules.yaml`
- `data/sample_customer_cdc.jsonl`
- `data/sample_bad_customer_cdc.jsonl`
- `src/check_customer_cdc_keys.py`
- `src/preview_customer_current_state.py`
- `src/plan_customer_merge.py`
- `src/run_local_cdc_pipeline.py`
- `src/merge_customer_current_state.sql`
- `tests/fixture_expected_cdc_check.txt`
- `tests/fixture_expected_customer_current_state.json`
- `tests/fixture_expected_merge_plan.json`
- `tests/fixture_expected_local_cdc_pipeline.json`
- `tests/verify_delta_cdc_assets.sh`

## Quick Local Verification

Run:

`bash tests/verify_delta_cdc_assets.sh`

Or inspect the local pipeline skeleton directly:

`python3 src/run_local_cdc_pipeline.py config/customer_cdc_rules.yaml data/sample_customer_cdc.jsonl`

Or materialize an artifact file locally:

`python3 src/run_local_cdc_pipeline.py config/customer_cdc_rules.yaml data/sample_customer_cdc.jsonl artifacts/customer_current_state_preview.json`

Or run the whole local starter flow in one command:

`bash run_lab.sh`
