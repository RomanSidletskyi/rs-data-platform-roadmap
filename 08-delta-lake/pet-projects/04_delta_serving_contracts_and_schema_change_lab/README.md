# 04 Delta Serving Contracts And Schema Change Lab

## Project Goal

Design a Delta Lake lab for consumer-facing delivery where schema change, contracts, and official access paths must be governed deliberately.

## Scenario

A gold Delta table supports dashboards and ad hoc analytics.

The team needs to:

- expose one official consumer-facing view or table
- define freshness and row-grain expectations
- evaluate whether a schema change is safe for consumers
- explain how supported access paths stay governed across the lakehouse

## Project Type

This folder is a guided project, not a ready implementation.

If you want a solved comparison after attempting your design, use the sibling reference example:

- `08-delta-lake/pet-projects/reference_example_delta_serving_contracts_and_schema_change_lab`

## Expected Deliverables

- one consumer contract statement
- one supported access-path design
- one schema change risk assessment
- one note about official versus informal consumption paths

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `artifacts/README.md`
- `run_lab.sh`
- `config/README.md`
- `data/README.md`
- `src/README.md`
- `tests/README.md`
- `config/serving_contract.yaml`
- `data/sample_daily_store_sales.jsonl`
- `data/sample_breaking_schema_candidate.json`
- `src/check_serving_contract.py`
- `src/review_schema_change.py`
- `src/plan_serving_publish.py`
- `src/run_local_serving_pipeline.py`
- `src/create_official_consumer_view.sql`
- `tests/fixture_expected_serving_contract_check.txt`
- `tests/fixture_expected_schema_review.json`
- `tests/fixture_expected_serving_plan.json`
- `tests/fixture_expected_local_serving_pipeline.json`
- `tests/verify_serving_contract_assets.sh`

## Quick Local Verification

Run:

`bash tests/verify_serving_contract_assets.sh`

Or inspect the local pipeline skeleton directly:

`python3 src/run_local_serving_pipeline.py config/serving_contract.yaml data/sample_daily_store_sales.jsonl data/sample_breaking_schema_candidate.json`

Or materialize an artifact file locally:

`python3 src/run_local_serving_pipeline.py config/serving_contract.yaml data/sample_daily_store_sales.jsonl data/sample_breaking_schema_candidate.json artifacts/serving_contract_assessment.json`

Or run the whole local starter flow in one command:

`bash run_lab.sh`
