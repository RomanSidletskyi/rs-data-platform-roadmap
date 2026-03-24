# 04 ADLS Multi-Engine Contracts And Consumption Lab

## Project Goal

Design a publish layer in ADLS that can be consumed safely by several engines without turning internal curated folders into unstable public interfaces.

## Scenario

Databricks jobs, a serverless SQL layer, and BI dashboards all read from the same lake.

The team needs to:

- define one official published interface for consumer data
- distinguish supported and unsupported access paths
- evaluate a schema-change proposal against downstream consumers
- keep engine-specific convenience from leaking into the storage contract

## Project Type

This folder is a guided project, not a ready implementation.

If you want a solved comparison after attempting your own design, use the sibling reference example:

- `09-azure-data-lake-storage/pet-projects/reference_example_adls_multi_engine_contracts_and_consumption_lab`

## Expected Deliverables

- one official consumer-path design
- one multi-engine compatibility note
- one schema-change risk assessment
- one explanation of why publish paths matter more than internal curated locations

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `artifacts/README.md`
- `run_lab.sh`
- `config/README.md`
- `data/README.md`
- `src/README.md`
- `tests/README.md`
- `config/consumer_contract.json`
- `config/consumer_contract_edge_case.json`
- `data/sample_consumer_requests.json`
- `src/check_consumer_contract.py`
- `src/review_engine_access_paths.py`
- `src/plan_publish_interface.py`
- `src/review_schema_contract_risks.py`
- `src/run_local_contract_pipeline.py`
- `src/create_official_publish_view.sql`
- `tests/fixture_expected_consumer_check.txt`
- `tests/fixture_expected_engine_review.json`
- `tests/fixture_expected_publish_plan.json`
- `tests/fixture_expected_schema_contract_risks.json`
- `tests/fixture_expected_local_contract_pipeline.json`
- `tests/verify_contract_assets.sh`

## Quick Local Verification

Run:

`bash tests/verify_contract_assets.sh`

Or inspect the local pipeline skeleton directly:

`python3 src/run_local_contract_pipeline.py config/consumer_contract.json data/sample_consumer_requests.json`

Or materialize an artifact file locally:

`python3 src/run_local_contract_pipeline.py config/consumer_contract.json data/sample_consumer_requests.json artifacts/consumer_contract_assessment.json`

Or run the whole local starter flow in one command:

`bash run_lab.sh`
