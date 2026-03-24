# 02 API To Lakehouse Orchestration

## Project Goal

Build an Airflow project that orchestrates API extraction into a lakehouse-style raw zone and then triggers downstream validation or transformation steps.

## Scenario

An external API provides daily records that must be fetched, stored in raw object storage, validated, and made ready for downstream processing.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

If you later want to compare your result with a ready implementation, use the separate reference example in:

- `reference_example_api_to_lakehouse_orchestration`

## What This Project Should Demonstrate

- API orchestration in Airflow
- external storage contract thinking
- interval-based extraction
- validation before downstream use
- clear distinction between orchestration and data movement implementation

## Starter Assets You Already Have

This guided project already includes:

- starter notes in `src/`, `tests/`, `docker/`, `config/`, and `data/`

## Suggested Folder Roles

- `src/` for DAG code and lightweight integration helpers
- `config/` for endpoint and runtime examples
- `data/` for expected raw zone contract notes
- `docker/` for local runtime assets
- `tests/` for helper and contract checks

## Expected Deliverables

- one DAG that fetches API data for an interval
- one raw landing step
- one validation step
- one downstream-ready signal or follow-up task

## What You Must Build

- a task that fetches from an API using a credible integration pattern
- a task that writes or simulates writing raw data to storage
- a validation step for raw output completeness
- at least one downstream orchestration step after validation
- a short note explaining what Airflow controls and what the external systems own

## Project Structure

	02_api_to_lakehouse_orchestration/
		README.md
		architecture.md
		config/
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

Read `architecture.md` and decide on the raw-zone contract.

### Step 2

Define how API calls will be parameterized by interval.

### Step 3

Implement DAG and integration helpers in `src/`.

### Step 4

Write tests or validation helpers.

### Step 5

Document local runtime notes in `docker/`.

### Step 6

Run one full workflow and record how you verified the raw output.

## Implementation Requirements

- keep API credentials and endpoints out of hardcoded DAG logic
- use interval-aware extraction
- externalize raw data rather than keeping it in Airflow state
- include a validation step before downstream continuation

## Validation Ideas

- verify raw output exists
- verify interval scoping is visible in file naming or metadata
- verify downstream step does not run when validation fails

## Definition Of Done

This project is complete if:

- the DAG models a credible API-to-raw flow
- raw output is validated before downstream use
- you can explain why Airflow is orchestration and not the storage or compute layer

## Suggested Self-Check

Compare with `reference_example_api_to_lakehouse_orchestration` only after implementing the project independently.

## Possible Improvements

- pagination
- backoff and retry strategy
- alerting on partial API failure
- downstream warehouse or dbt trigger