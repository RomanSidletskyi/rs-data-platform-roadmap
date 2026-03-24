# 01 API To CSV Pipeline

## Project Goal

Build a small ingestion pipeline that retrieves API data, stores raw snapshots, transforms the response, and writes processed CSV outputs.

## Scenario

Your team needs a lightweight but credible ingestion workflow for a public or partner API. The pipeline should preserve the source response, validate the payload, produce tabular output, and log what happened during the run.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

If you want to compare your result with a ready implementation afterwards, use the separate reference example in:

- `reference_example_api_to_csv_pipeline`

## Starter Assets You Already Have

This guided project already includes:

- `.env.example` with minimal runtime variables
- `requirements.txt` with a small dependency baseline
- `config/config.yaml` as a starter config example
- `data/raw/sample_users_response.json` as an example API payload shape
- `data/processed/expected_columns.md` as the target CSV contract
- starter notes in `src/`, `data/`, `docker/`, and `tests/`

## Suggested Folder Roles

- `src/` for implementation code and helper modules
- `config/` for runtime config examples
- `data/` for raw and processed output contracts
- `docker/` for optional local runtime notes
- `tests/` for helper and contract validation

## Expected Deliverables

- one runnable ingestion entrypoint
- one API client layer
- one transformation layer
- raw JSON output
- processed CSV output
- basic run logging or run reporting

## What You Must Build

- call an API endpoint with timeout handling
- preserve raw response data
- select and transform output fields
- write processed CSV output
- log the important stages of the run
- fail clearly when the response is empty or unusable

## Project Structure

	01_api_to_csv_pipeline/
		README.md
		architecture.md
		.env.example
		requirements.txt
		config/
			config.yaml
			README.md
		data/
			README.md
		docker/
			README.md
		src/
			README.md
		tests/
			README.md

## Recommended Implementation Plan

### Step 1

Read `architecture.md` and inspect the provided starter assets.

### Step 2

Define the output contract for raw and processed data.

### Step 3

Implement the API client and transformation logic in `src/`.

### Step 4

Add validation or helper checks in `tests/`.

### Step 5

Run the project and verify that both raw and processed outputs are produced.

## Implementation Requirements

- keep API access separate from transformation code
- preserve raw response before aggressive transformation
- make output paths obvious and reproducible
- avoid hardcoded secrets
- emit useful logs or run summary information

## Validation Ideas

- verify the API response is not empty
- verify raw JSON is written before processed CSV
- verify processed CSV contains only the selected fields
- verify failure paths are readable

## Definition Of Done

This project is complete if:

- the pipeline reads from an API and writes both raw and processed outputs
- the code is split into credible responsibilities
- the project is understandable to another engineer
- the run can be explained as a small ingestion workflow rather than one random script

## Suggested Self-Check

Compare with `reference_example_api_to_csv_pipeline` only after implementing the project independently.

The main project folder should remain a guided build exercise, not a pre-solved implementation.

## Possible Improvements

- pagination support
- retries with backoff
- schema validation
- Parquet output
- config-driven multi-endpoint ingestion
