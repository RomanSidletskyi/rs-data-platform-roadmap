# Reference Example - Production Style Airflow Project

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- showing what a small production-shaped Airflow repository can look like
- preserving a reusable pattern for config separation, validation gates, and external execution boundaries

You should attempt the guided project first:

- `11-airflow/pet-projects/04_production_style_airflow_project`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- environment-aware config loading
- small but production-shaped DAG design
- validation gate before publish-style completion
- use of external job boundaries instead of heavy compute in Airflow
- pure-Python helper modules that can be tested independently

## Folder Overview

- `.env.example` for runtime values
- `config/runtime_config.json` as a runnable local copy of the shared config template in `shared/configs/templates/airflow/runtime_config.example.json`
- `src/dags/orders_platform_dag.py` as the main DAG example
- `src/helpers/runtime_config.py` and `src/helpers/validation.py` for reusable logic
- `data/expected_output_contract.json` as a runnable local copy of the shared contract in `shared/testing/expected-outputs/airflow/orders_platform_contract.json`
- `tests/` for helper validation
- `docker/requirements.txt` for Airflow provider/runtime notes

## Reference Flow

The DAG follows this shape:

    start -> validate_runtime_contract -> run_external_transform -> validate_publish_contract -> publish_success_marker -> finish

## Why This Is A Good Reference Shape

- DAG file stays readable
- configuration is separated from workflow logic
- validation happens before publish completion
- external compute is represented as a clear orchestration boundary

## How To Compare With Your Own Solution

When comparing this reference example with your own implementation, focus on:

- whether environment-sensitive values are separated from DAG code
- whether publish-like completion is protected by validation
- whether task boundaries are clear and operationally meaningful
- whether the repository looks understandable to another engineer