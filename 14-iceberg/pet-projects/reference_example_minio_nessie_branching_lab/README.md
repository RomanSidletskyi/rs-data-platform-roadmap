# Reference Example - MinIO Nessie Branching Lab

This folder contains a ready reference example for the guided project:

- `02_minio_nessie_branching_lab`

Its purpose is:

- self-checking after attempting the guided project
- showing a concrete branch-aware Iceberg control-plane design
- preserving a reusable pattern for short-lived development branches and safe promotion to main

## What This Reference Example Demonstrates

- MinIO as warehouse storage
- Nessie as reference control plane
- Spark as branch-aware writer and validator
- short-lived development branches instead of direct writes to main

## Folder Overview

- `.env.example` for local lab runtime assumptions
- `architecture.md` for the control-plane shape
- `config/catalog_setup.md` for Spark plus Nessie catalog configuration
- `config/runtime_config.json` for a local catalog and branch settings example
- `src/branch_flow.md` for branch lifecycle examples
- `src/branch_helpers.py` for branch-oriented helper logic
- `src/branch_commands.sql` for representative SQL commands
- `data/sample_branch_change_plan.json` for a branch review scenario
- `tests/promotion_checks.md` for promotion safety review
- `tests/test_branch_helpers.py` for lightweight validation of branch rules
- `docker/requirements.txt` for local Python validation dependency note

## Reference Flow

The lab follows this shape:

    main -> create dev branch -> test writes on dev -> inspect branch state -> merge to main

## How To Compare With Your Own Solution

When comparing this reference example with your own implementation, focus on:

- whether branch value is real or cosmetic
- whether promotion checks are explicit
- whether storage and catalog responsibilities stay separate