# Project 03 — dbt CI/CD Multi-Environment Platform

## Project Goal

Build a production-style operational dbt platform with:

- dev / qa / prod environments
- separate Snowflake databases and schemas
- multiple virtual warehouses
- GitHub Actions CI
- production deployment
- tag-based job execution
- local lineage and docs
- operational visibility

--------------------------------------------------

## Why this project matters

Many teams learn dbt syntax but do not learn how dbt is actually operated in production.

This project focuses on the platform and deployment side of dbt:

- environment isolation
- config hierarchy
- deployment flow
- CI safety checks
- cost-aware Snowflake compute routing
- runtime observability

This is one of the most valuable advanced dbt skills.

--------------------------------------------------

## Core Architecture

    developer branch
        ↓
    GitHub Actions CI
        ↓
    QA validation
        ↓
    merge to main
        ↓
    production deploy
        ↓
    scheduled dbt jobs

Snowflake environments:

- ANALYTICS_DEV
- ANALYTICS_QA
- ANALYTICS_PROD

--------------------------------------------------

## Business Scenario

A team has a shared dbt repository and wants to deploy safely.

Requirements:

- developers must not overwrite each other
- QA should validate changes before production
- production should stay clean
- not every run should rebuild the whole project
- heavy facts and lightweight staging should not always share the same warehouse

--------------------------------------------------

## What the project should demonstrate

This project should include and explain:

- complete `profiles.yml` for dev / qa / prod
- complete `dbt_project.yml`
- custom `generate_schema_name`
- `selectors.yml`
- folder-based config routing
- multiple Snowflake virtual warehouses
- PR validation in GitHub Actions
- production deploy workflow
- scheduled jobs by tag
- local docs generation
- where to inspect artifacts and logs

--------------------------------------------------

## Recommended environment pattern

dev:
- personal schema base, for example `dbt_ivan`
- used for local development
- final schema examples:
  - `dbt_ivan_staging`
  - `dbt_ivan_marts`

qa:
- shared CI schema base, for example `dbt_ci`
- final schema examples:
  - `dbt_ci_staging`
  - `dbt_ci_marts`

prod:
- clean schemas
- final schema examples:
  - `staging`
  - `marts`

--------------------------------------------------

## Recommended warehouse pattern

Suggested Snowflake warehouses:

- `DBT_SMALL_WH` for staging and lightweight tests
- `DBT_MEDIUM_WH` for intermediate models
- `DBT_LARGE_WH` for heavy facts
- `DBT_XL_WH` for backfill / exceptional runs

This project should show:

- default warehouse in `profiles.yml`
- folder-level warehouse routing in `dbt_project.yml`
- model-level override with `config()`

--------------------------------------------------

## CI/CD pattern to implement

PR validation flow:

- checkout code
- install dbt
- generate runtime profile
- run `dbt deps`
- run `dbt debug`
- run build and tests

Production deploy flow:

- trigger on merge to main
- use prod profile
- run `dbt build --target prod`

Optional advanced extension:

- Slim CI with:
  - `state:modified+`
  - `--defer`
  - production artifacts

--------------------------------------------------

## Recommended tagging and selectors

The project should include tags such as:

- `daily_dimension`
- `frequent_fact`
- `staging`

It should also include selectors such as:

- `daily_dims`
- `frequent_facts`

This allows separate scheduled runs for different workloads.

--------------------------------------------------

## Recommended artifact visibility

The project should explicitly document where to inspect:

- `logs/dbt.log`
- `target/compiled/`
- `target/run/`
- `run_results.json`
- `manifest.json`

It should also explain how to view lineage locally:

    dbt docs generate
    dbt docs serve

--------------------------------------------------

## Recommended project structure

    config/
        profiles.example.yml
        dbt_project.example.yml
        selectors.example.yml
        github-actions-ci.example.yml
        github-actions-prod.example.yml

    src/
        helper scripts if needed

    tests/
        critical singular tests

    docker/
        optional local runner support

--------------------------------------------------

## What this project teaches

This project should teach the learner how to think like a production dbt platform engineer:

- how dbt config layers interact
- how schemas are generated across environments
- how CI blocks unsafe changes
- how production deploy is automated
- how to route workloads to different Snowflake warehouses
- how to monitor and debug dbt operationally

--------------------------------------------------

## Suggested advanced extensions

After the base version works, extend it with:

- Airflow-triggered dbt jobs
- Databricks-triggered dbt runs after ingestion
- artifact parsing for internal run reporting
- QA database cloning from prod
- additional environment-specific selectors

--------------------------------------------------

## Success Criteria

The project is successful if:

- environment separation is clear
- config hierarchy is easy to explain
- warehouses are assigned intentionally
- CI and deploy workflows are understandable
- tag-based job scheduling is possible
- the project documents where to see logs, artifacts, and lineage

