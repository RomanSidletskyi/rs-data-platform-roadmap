# Architecture - Reference Example Production Style Airflow Project

## Components

- Airflow DAG
- reusable runtime config loader
- validation helper layer
- external transform execution boundary
- publish success marker contract

## Workflow Model

1. validate configuration contract
2. trigger external transform-style work
3. validate output contract
4. publish success marker

## Configuration Model

- defaults live in `config/runtime_config.json`
- environment-specific overrides come from env vars
- DAG code reads resolved config instead of hardcoding environment values

## Operational Model

- retries are explicit
- timeouts are explicit
- publish completion happens only after validation succeeds
- heavy compute stays outside Airflow

## Trade-Offs

- this project models production structure without reproducing every production dependency
- a small repository is easier to learn from than a fully enterprise layout
- some operational constructs are simplified to stay understandable

## What Would Change In Production

- secrets backend
- CI import checks and linting
- executor-specific pools and queues
- real notification integrations
- real storage or warehouse systems