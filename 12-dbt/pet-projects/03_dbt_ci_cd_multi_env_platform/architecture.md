# Architecture — dbt CI/CD Multi-Environment Platform

## Overview

This project focuses on operational architecture rather than only transformation logic.

It models how a team safely changes and deploys dbt in Snowflake.

--------------------------------------------------

## Environment design

Recommended environment split:

dev:
- developer-specific schemas
- isolated experiments
- fast feedback

qa:
- shared validation environment
- CI execution
- release confidence

prod:
- stable deployment target
- clean schemas
- service account access

--------------------------------------------------

## Warehouse design

Recommended warehouse split:

- `DBT_SMALL_WH` for staging and tests
- `DBT_MEDIUM_WH` for intermediate
- `DBT_LARGE_WH` for heavy facts
- `DBT_XL_WH` for backfills

--------------------------------------------------

## CI/CD flow

    feature branch
        ↓
    PR validation
        ↓
    dbt deps
        ↓
    dbt debug
        ↓
    dbt build --select state:modified+ --defer
        ↓
    tests
        ↓
    merge
        ↓
    dbt build --target prod

--------------------------------------------------

## Reporting and visibility

Results should be observable through:

- GitHub Actions run history
- dbt logs
- `run_results.json`
- `manifest.json`
- local `dbt docs`

