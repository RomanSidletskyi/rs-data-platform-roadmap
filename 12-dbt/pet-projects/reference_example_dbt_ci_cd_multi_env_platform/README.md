# Reference Example - dbt CI/CD Multi-Environment Platform

This folder contains a ready reference implementation for the guided project:

- `12-dbt/pet-projects/03_dbt_ci_cd_multi_env_platform`

Use it only after attempting the guided version yourself.

## What This Reference Example Demonstrates

- dev, qa, and prod profile patterns
- folder-based warehouse routing in `dbt_project.yml`
- a custom `generate_schema_name` macro
- selectors for different workload cadences
- GitHub Actions workflows for PR validation and production deploy
- small helper scripts for runtime config rendering and artifact summarization

## Folder Overview

- `.env.example` shows environment variables the workflows expect
- `config/README.md` points to shared dbt config templates under `shared/configs/templates/dbt/`
- `src/macros/README.md` points to the shared macro under `shared/templates/dbt/macros/`
- `src/scripts/README.md` points to shared helper scripts under `shared/scripts/helpers/dbt/`
- `tests/` contains a small singular test example

## Why This Is A Good Reference Shape

- the operational surface is visible in plain text
- environment behavior is deterministic
- warehouse routing and selectors are easy to review
- CI and deploy flows are present without becoming too abstract

## How To Compare With Your Own Solution

When comparing this reference example with your own implementation, focus on:

- whether dev, qa, and prod naming are separated cleanly
- whether CI and deploy workflows are understandable to another engineer
- whether warehouse routing reflects workload type
- whether the project clearly explains where to inspect logs and artifacts
