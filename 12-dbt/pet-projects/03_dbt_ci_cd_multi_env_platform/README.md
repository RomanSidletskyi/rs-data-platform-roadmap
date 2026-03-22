# Project 03 — dbt CI/CD Multi-Environment Platform

## Project Goal

Build a production-style dbt platform setup focused on:

- dev / qa / prod environments
- Snowflake database and schema separation
- multiple virtual warehouses
- GitHub Actions CI
- deploy to production
- selectors and tagged jobs
- local docs and lineage

--------------------------------------------------

## Why this project matters

A lot of real dbt complexity is not in the SQL itself.
It is in:

- environment isolation
- deployment
- orchestration
- cost control
- CI/CD

This project simulates the operational side of dbt.

--------------------------------------------------

## Architecture

    developer branch
        ↓
    GitHub Actions CI
        ↓
    qa build / validation
        ↓
    merge to main
        ↓
    production deploy
        ↓
    scheduled jobs by tag

Snowflake environments:

- ANALYTICS_DEV
- ANALYTICS_QA
- ANALYTICS_PROD

--------------------------------------------------

## What should be implemented

1. Create a realistic `profiles.yml` example for:
   - dev
   - qa
   - prod

2. Create a `dbt_project.yml` that includes:
   - layered configs
   - warehouse routing
   - tags

3. Create a custom `generate_schema_name` macro

4. Add `selectors.yml` for:
   - daily dimensions
   - frequent facts

5. Add a GitHub Actions PR validation workflow

6. Add a GitHub Actions production deploy workflow

7. Document how to view dbt lineage locally using:
   - `dbt docs generate`
   - `dbt docs serve`

--------------------------------------------------

## What this project teaches

- how dbt is operated in teams
- why config hierarchy matters
- why environments need isolation
- how CI/CD can block bad changes
- how `--defer` and Slim CI reduce cost
- how virtual warehouses are assigned to workloads

--------------------------------------------------

## Expected outcome

The learner should finish this project able to design a production-ready dbt platform with multiple environments and deployment automation.

