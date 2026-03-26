# Reference Example - API To Lakehouse Orchestration

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- showing a credible Airflow shape for API-to-raw orchestration
- preserving a reusable implementation pattern for future modules

You should attempt the guided project first:

- `11-airflow/pet-projects/02_api_to_lakehouse_orchestration`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- interval-aware API extraction
- externalized raw output on a local filesystem contract
- validation before downstream continuation
- clear separation between orchestration code and helper logic

## Folder Overview

- `.env.example` for local runtime values
- `config/api_runtime.json` as a runnable local copy of the shared config template in `shared/configs/templates/airflow/api_runtime.example.json`
- `data/sample_api_response.json` as a runnable local copy of the shared payload sample in `shared/testing/mock-data/airflow/sample_api_response.json`
- `src/dags/api_to_lakehouse_dag.py` as the Airflow DAG
- `src/helpers/api_to_lakehouse_contract.py` for reusable pure-Python logic
- `tests/test_api_to_lakehouse_contract.py` for helper validation
- `docker/requirements.txt` for required Airflow provider dependency

## Reference Flow

The DAG follows this shape:

    start -> fetch_api_payload -> validate_raw_output -> mark_downstream_ready -> finish

What each stage owns:

- `fetch_api_payload` calls the API and writes raw payload outside Airflow metadata
- `validate_raw_output` checks the landed raw file and validates minimum payload quality
- `mark_downstream_ready` creates a small readiness marker for downstream systems

## Why This Is A Good Reference Shape

- Airflow orchestrates and validates, but does not become the storage layer
- XCom is only used for small metadata such as file paths
- interval-based paths make reruns and backfills safer

## How To Compare With Your Own Solution

When comparing this reference example with your own implementation, focus on:

- whether your interval boundaries are explicit
- whether your raw output is externalized cleanly
- whether validation happens before downstream continuation
- whether task boundaries are small and operationally clear