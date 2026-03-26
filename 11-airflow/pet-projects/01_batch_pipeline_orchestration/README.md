# 01 Batch Pipeline Orchestration

## Project Goal

Build a small Airflow project that orchestrates a repeatable batch data pipeline with clear task boundaries.

## Scenario

You have a daily batch process that reads source data, validates it, runs one transformation step, and publishes a final output or success marker. The main goal is not heavy compute, but correct orchestration shape.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

If a reference example is added later, it should live in a separate sibling folder named:

- `reference_example_batch_pipeline_orchestration`

## What This Project Should Demonstrate

- one DAG with clear stage boundaries
- batch-oriented interval thinking
- retry-safe task design
- validation before publish
- logs and operational visibility

## Starter Assets You Already Have

This guided project already includes:

- starter notes in `src/`, `tests/`, `docker/`, `config/`, and `data/`

## Suggested Folder Roles

- `src/` for DAG code and helper modules
- `config/` for runtime and environment examples
- `data/` for sample datasets or placeholder output notes
- `docker/` for local Airflow runtime assets
- `tests/` for DAG validation and helper tests

## Expected Deliverables

- one batch-oriented DAG
- at least one validation step
- one publish or success-marker step
- short run instructions
- short operational verification notes

## What You Must Build

- a DAG with stages such as extract, validate, transform, and publish
- interval-aware task behavior
- one failure-safe validation gate before publish
- local runtime instructions for executing the DAG
- a short note explaining why this is orchestration and not heavy compute

## Project Structure

	01_batch_pipeline_orchestration/
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

Read `architecture.md` and understand the target DAG boundaries.

### Step 2

Decide what the pipeline reads, validates, and publishes.

### Step 3

Implement DAG and helper code in `src/`.

### Step 4

Add checks or tests in `tests/`.

### Step 5

Define local runtime instructions in `docker/` if you want a local Airflow setup.

### Step 6

Run the DAG and write a short operational verification note.

## Implementation Requirements

- keep heavy business logic out of the DAG file
- use clear task boundaries
- make retries safe or document retry assumptions
- use interval-aware thinking for any time-based logic
- include a validation step before publish

## Validation Ideas

- verify the DAG graph is readable
- verify each task has one responsibility
- check that failure before publish prevents incorrect completion
- verify logs or state transitions in the UI

## Definition Of Done

This project is complete if:

- the DAG represents a credible batch pipeline
- task boundaries are clear and retry-safe
- there is at least one validation gate
- you can explain why the pipeline shape is operationally safer than one giant task

## Suggested Self-Check

If a reference example exists later, compare only after implementing the project independently.

## Possible Improvements

- add alerting
- add timeout policies
- add task groups
- add a small external storage contract