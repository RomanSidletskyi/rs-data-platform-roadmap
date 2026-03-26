# 03 Delta Quality Recovery And Retention Lab

## Project Goal

Design a Delta Lake lab focused on quality enforcement, bounded repair, time travel, restore decisions, and retention safety.

## Scenario

A silver Delta table is shared across several downstream jobs.

The team needs to:

- fail loudly on critical quality violations
- repair bad writes safely
- decide when restore is appropriate
- define a retention policy that does not destroy recovery options too early

## Project Type

This folder is a guided project, not a ready implementation.

## Expected Deliverables

- one quality rule that blocks invalid data
- one bounded repair design
- one restore decision note
- one retention-policy explanation tied to actual recovery needs

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `artifacts/README.md`
- `run_lab.sh`
- `config/README.md`
- `data/README.md`
- `src/README.md`
- `tests/README.md`
- `config/quality_recovery_policy.yaml`
- `data/sample_shared_orders_silver.jsonl`
- `data/sample_invalid_shared_orders_silver.jsonl`
- `src/check_quality_rules.py`
- `src/recommend_repair_strategy.py`
- `src/plan_quality_recovery.py`
- `src/run_local_quality_recovery_pipeline.py`
- `src/inspect_repair_scope.sql`
- `tests/fixture_expected_quality_check.txt`
- `tests/fixture_expected_repair_strategy.json`
- `tests/fixture_expected_quality_plan.json`
- `tests/fixture_expected_local_quality_pipeline.json`
- `tests/verify_quality_recovery_assets.sh`

## Quick Local Verification

Run:

`bash tests/verify_quality_recovery_assets.sh`

Or inspect the local pipeline skeleton directly:

`python3 src/run_local_quality_recovery_pipeline.py config/quality_recovery_policy.yaml data/sample_invalid_shared_orders_silver.jsonl`

Or materialize an artifact file locally:

`python3 src/run_local_quality_recovery_pipeline.py config/quality_recovery_policy.yaml data/sample_invalid_shared_orders_silver.jsonl artifacts/quality_recovery_assessment.json`

Or run the whole local starter flow in one command:

`bash run_lab.sh`
