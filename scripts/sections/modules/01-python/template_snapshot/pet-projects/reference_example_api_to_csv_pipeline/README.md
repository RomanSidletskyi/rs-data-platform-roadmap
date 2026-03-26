# Reference Example - API To CSV Pipeline

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- showing one credible modular shape for a small ingestion workflow
- preserving a reusable implementation pattern for later Python projects

You should attempt the guided project first:

- `01-python/pet-projects/01_api_to_csv_pipeline`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- API access separated from transformation logic
- raw JSON snapshot preservation
- processed CSV output
- config loading and basic retry behavior
- logging around pipeline execution

## Folder Overview

- `.env.example` for runtime variables
- `requirements.txt` for a minimal dependency set
- `config/config.yaml` for local configuration
- `src/` for the runnable implementation modules

## How To Compare With Your Own Solution

When comparing this reference example with your own implementation, focus on:

- whether your raw snapshot is preserved before transformation
- whether your code boundaries are easy to understand
- whether failure handling is clearer than in a one-file script