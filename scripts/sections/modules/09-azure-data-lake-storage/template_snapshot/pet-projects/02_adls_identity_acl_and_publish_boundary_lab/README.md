# 02 ADLS Identity ACL And Publish Boundary Lab

## Project Goal

Design an ADLS access model that gives engineering workloads the write scope they need without exposing broad raw or curated access to analytics consumers.

## Scenario

A Databricks ingestion job writes raw landing data, a curation workflow reads from raw and writes to curated, and analysts only need read access to one publish subtree.

The team needs to:

- choose the right identity types for each actor
- separate RBAC and ACL responsibility clearly
- keep publish access narrower than internal engineering access
- explain how group-based access avoids fragile one-off assignments

## Project Type

This folder is a guided project, not a ready implementation.

## Expected Deliverables

- one identity map for producers, platform jobs, and analysts
- one ACL plan for narrow path-level access
- one note on why publish paths are the supported consumer interface
- one warning about a likely security anti-pattern

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `artifacts/README.md`
- `run_lab.sh`
- `config/README.md`
- `data/README.md`
- `src/README.md`
- `tests/README.md`
- `config/access_blueprint.json`
- `config/access_blueprint_edge_case.json`
- `data/sample_access_requests.json`
- `src/check_access_model.py`
- `src/build_acl_assignment_plan.py`
- `src/detect_access_risks.py`
- `src/review_publish_boundary.py`
- `src/run_local_access_pipeline.py`
- `src/publish_access_policy.json`
- `tests/fixture_expected_access_check.txt`
- `tests/fixture_expected_acl_plan.json`
- `tests/fixture_expected_access_risks.json`
- `tests/fixture_expected_publish_review.json`
- `tests/fixture_expected_local_access_pipeline.json`
- `tests/verify_access_assets.sh`

## Quick Local Verification

Run:

`bash tests/verify_access_assets.sh`

Or inspect the local pipeline skeleton directly:

`python3 src/run_local_access_pipeline.py config/access_blueprint.json data/sample_access_requests.json`

Or materialize an artifact file locally:

`python3 src/run_local_access_pipeline.py config/access_blueprint.json data/sample_access_requests.json artifacts/access_assessment.json`

Or run the whole local starter flow in one command:

`bash run_lab.sh`
