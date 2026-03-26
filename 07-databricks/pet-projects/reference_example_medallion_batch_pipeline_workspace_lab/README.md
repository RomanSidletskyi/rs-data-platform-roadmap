# Reference Example - Medallion Batch Pipeline Workspace Lab

This folder contains a ready comparison example for a Databricks medallion-style batch pipeline.

Its purpose is:

- self-checking after attempting the guided project
- comparing task boundaries and job-definition choices
- preserving a reusable Databricks platform pattern for bronze to silver to gold delivery

You should attempt the guided project first:

- `07-databricks/pet-projects/01_medallion_batch_pipeline_workspace_lab`

## What This Reference Example Demonstrates

- deterministic bronze-like input data
- one local preview of gold daily revenue output
- one job-definition validation helper
- a small but credible Databricks job-spec pattern for medallion delivery

## Folder Overview

- `.env.example` for environment and table placeholders
- `config/job_definition.json` for a production-shaped Databricks job spec
- `data/sample_orders_bronze.jsonl` as replayable raw input
- `src/build_gold_daily_revenue.py` for a local preview of the gold output shape
- `src/check_job_definition.py` for validating important job-structure choices
- `tests/` fixtures and smoke checks