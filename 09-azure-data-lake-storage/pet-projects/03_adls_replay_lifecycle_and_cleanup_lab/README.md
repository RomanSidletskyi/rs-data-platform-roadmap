# 03 ADLS Replay Lifecycle And Cleanup Lab

## Project Goal

Design replay, retention, and cleanup rules for ADLS paths so the platform can recover safely without keeping every temporary file forever.

## Scenario

A lake contains raw landed history, curated outputs, temporary backfill folders, and old working paths left behind after urgent fixes.

The team needs to:

- decide which history is replay-critical
- define tighter cleanup rules for temporary and backfill areas
- protect published and audit-relevant paths from careless deletion
- explain how lifecycle rules differ by path purpose

## Project Type

This folder is a guided project, not a ready implementation.

## Expected Deliverables

- one replay-safe boundary map
- one retention policy proposal by path class
- one cleanup plan that distinguishes active and stale paths
- one note on what should never be deleted blindly

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `artifacts/README.md`
- `run_lab.sh`
- `config/README.md`
- `data/README.md`
- `src/README.md`
- `tests/README.md`
- `config/lifecycle_blueprint.json`
- `data/sample_storage_inventory.json`
- `data/sample_storage_inventory_edge_case.json`
- `src/check_replay_boundary.py`
- `src/plan_cleanup_actions.py`
- `src/preview_retention_windows.py`
- `src/review_cleanup_risks.py`
- `src/run_local_lifecycle_pipeline.py`
- `src/identify_stale_paths.sql`
- `tests/fixture_expected_replay_check.txt`
- `tests/fixture_expected_cleanup_plan.json`
- `tests/fixture_expected_cleanup_risks.json`
- `tests/fixture_expected_retention_preview.json`
- `tests/fixture_expected_local_lifecycle_pipeline.json`
- `tests/verify_lifecycle_assets.sh`

## Quick Local Verification

Run:

`bash tests/verify_lifecycle_assets.sh`

Or inspect the local pipeline skeleton directly:

`python3 src/run_local_lifecycle_pipeline.py config/lifecycle_blueprint.json data/sample_storage_inventory.json`

Or materialize an artifact file locally:

`python3 src/run_local_lifecycle_pipeline.py config/lifecycle_blueprint.json data/sample_storage_inventory.json artifacts/lifecycle_assessment.json`

Or run the whole local starter flow in one command:

`bash run_lab.sh`
