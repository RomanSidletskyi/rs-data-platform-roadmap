# 01 ADLS Namespace And Landing Zone Lab

## Project Goal

Design an ADLS landing-zone layout that keeps raw, curated, and publish boundaries explicit while staying understandable for new platform teams.

## Scenario

A retail data platform is onboarding order events and inventory snapshots into ADLS.

The team needs a storage design that:

- separates raw, curated, and publish responsibilities
- uses stable top-level paths for domain-owned datasets
- avoids accidental consumer dependence on internal landing areas
- keeps environment and ownership decisions explicit

## Project Type

This folder is a guided project, not a ready implementation.

If you want a solved comparison after attempting your own design, use the sibling reference example:

- `09-azure-data-lake-storage/pet-projects/reference_example_adls_namespace_and_landing_zone_lab`

## Expected Deliverables

- one proposed container and path layout
- one short note on why each boundary exists
- one stable publish-path decision
- one explanation of what remains internal-only

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `artifacts/README.md`
- `run_lab.sh`
- `config/README.md`
- `data/README.md`
- `src/README.md`
- `tests/README.md`
- `config/landing_zone_blueprint.json`
- `data/sample_storage_objects.json`
- `data/sample_storage_objects_edge_case.json`
- `src/check_namespace_contract.py`
- `src/plan_landing_zone.py`
- `src/preview_storage_layout.py`
- `src/review_namespace_risks.py`
- `src/run_local_namespace_pipeline.py`
- `src/create_external_locations.sql`
- `tests/fixture_expected_namespace_check.txt`
- `tests/fixture_expected_landing_plan.json`
- `tests/fixture_expected_layout_preview.json`
- `tests/fixture_expected_namespace_risks.json`
- `tests/fixture_expected_local_namespace_pipeline.json`
- `tests/verify_namespace_assets.sh`

## Definition Of Done

The lab explains not only where data lands, but also which ADLS paths are internal working areas and which are stable contract boundaries.

## Quick Local Verification

Run:

`bash tests/verify_namespace_assets.sh`

Or inspect the local pipeline skeleton directly:

`python3 src/run_local_namespace_pipeline.py config/landing_zone_blueprint.json data/sample_storage_objects.json`

Or materialize an artifact file locally:

`python3 src/run_local_namespace_pipeline.py config/landing_zone_blueprint.json data/sample_storage_objects.json artifacts/namespace_assessment.json`

Or run the whole local starter flow in one command:

`bash run_lab.sh`
