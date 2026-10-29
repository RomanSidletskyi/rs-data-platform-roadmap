# 05 Snowflake Dynamic Table Pipeline

## Project Goal

Design a freshness-aware Snowflake transformation pipeline using dynamic tables without turning the warehouse into an uncontrolled always-on refresh engine.

## Scenario

Orders land in Snowflake every few minutes. Product and finance stakeholders want fast but not truly real-time visibility. You need to design a layered refresh model that uses dynamic tables where they help, but still keeps cost, business latency classes, and governance under control.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

## Starter Assets You Already Have

This guided project already includes:

- `source_model.md` with the operational starting tables
- `freshness_sla.md` with candidate latency expectations
- `requirements.md` with functional and non-functional expectations
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for dynamic table definitions and comparison notes against tasks or dbt
- `config/` for warehouse, role, and naming assumptions
- `data/` for example grains and freshness classes
- `tests/` for reconciliation and lag-validation notes
- `docker/` for optional local helpers only

## Expected Deliverables

- one layered refresh design
- one or more dynamic table definitions
- one lag assignment rationale per layer
- one note explaining where tasks or dbt would still be better
- one cost and operability summary

## What You Must Build

- define raw, staging, intermediate, and serving layers
- assign target lags based on business need rather than personal preference
- show at least one dynamic table that deduplicates or standardizes raw data
- show at least one dynamic table that powers a small serving mart
- explain where dynamic tables stop being the right answer

## Project Structure

	05_snowflake_dynamic_table_pipeline/
		README.md
		architecture.md
		source_model.md
		freshness_sla.md
		requirements.md
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

Read `architecture.md`, `source_model.md`, `freshness_sla.md`, and `requirements.md`.

### Step 2

Define the data layers and consumer classes.

### Step 3

Assign target lags and warehouse ownership per layer.

### Step 4

Write the dynamic table definitions.

### Step 5

Add a note explaining when a scheduled batch or task-driven flow would be stronger.

### Step 6

Write validation and cost-control checks.

## Implementation Requirements

- do not give every layer the same target lag
- keep heavy historical logic away from unrealistic low-lag promises
- separate business-critical contract models from convenience refresh patterns
- make warehouse ownership and cost visible
- explain where dynamic tables fit and where they do not fit

## Validation Ideas

- verify the staging layer refreshes faster than the heaviest serving layer
- verify late-arriving rows do not break correctness assumptions
- verify the design calls out at least one case where tasks or dbt are preferable
- verify the cost discussion is tied to actual freshness choices

## Definition Of Done

This project is complete if:

- the lag model is business-driven
- the dynamic table usage is selective and credible
- the project distinguishes declarative freshness from full orchestration
- the final design looks operable, not just convenient on paper