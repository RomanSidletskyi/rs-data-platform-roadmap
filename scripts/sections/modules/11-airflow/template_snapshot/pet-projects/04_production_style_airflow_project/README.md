# 04 Production Style Airflow Project

## Project Goal

Build a production-shaped Airflow project that demonstrates environment-aware orchestration, operational safety, and realistic DAG engineering practices.

## Scenario

Your team needs an Airflow project that looks closer to real platform work: clear DAG ownership, environment-aware configuration, validation, monitoring assumptions, and safer operational defaults.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

If you later want to compare your result with a ready implementation, use the separate reference example in:

- `reference_example_production_style_airflow_project`

## What This Project Should Demonstrate

- production-style DAG structure
- environment separation
- operational controls such as retries, timeout ideas, and validation gates
- clear boundary between orchestration and external systems

## Starter Assets You Already Have

This guided project already includes:

- starter notes in `src/`, `tests/`, `docker/`, `config/`, and `data/`

## Suggested Folder Roles

- `src/` for DAGs, helpers, and reusable workflow logic
- `config/` for environment and runtime examples
- `data/` for contract notes or sample assets
- `docker/` for local Airflow runtime assets
- `tests/` for validation and import checks

## Expected Deliverables

- one production-shaped DAG or small DAG set
- environment-aware config approach
- validation and operational notes
- clear explanation of failure handling assumptions

## What You Must Build

- at least one DAG with realistic operational settings
- one validation or data-quality gate
- one note about retries, timeout, alerting, or concurrency controls
- one clear separation between orchestration code and external execution systems

## Project Structure

	04_production_style_airflow_project/
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

Read `architecture.md` and define the production-style concerns you will model.

### Step 2

Decide how configuration will differ across environments.

### Step 3

Implement DAGs and helpers in `src/`.

### Step 4

Add validation or import checks in `tests/`.

### Step 5

Add local runtime notes in `docker/`.

### Step 6

Run the workflow and document the operational assumptions clearly.

## Implementation Requirements

- keep DAG files readable and lightweight
- separate config from code
- document at least one operational control such as retries, timeout, pools, or alerting
- include at least one validation boundary
- keep heavy compute or storage work outside Airflow itself

## Validation Ideas

- verify DAG import success
- verify environment-dependent settings are explicit
- verify validation failure blocks downstream publish-style steps
- verify the project structure is understandable to another engineer

## Definition Of Done

This project is complete if:

- the project looks like a small but credible Airflow repository
- environment and operational concerns are explicit
- orchestration boundaries are clear
- you can explain which parts are production-like and which parts are still simplified for learning

## Suggested Self-Check

Compare with `reference_example_production_style_airflow_project` only after implementing the project independently.

## Possible Improvements

- CI checks for DAG import
- alert routing
- pools and concurrency policies
- deferrable waiting strategy