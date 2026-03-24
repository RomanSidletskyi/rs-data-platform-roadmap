# 01 SQL Analytics Engine

## Project Goal

Build a mini analytics layer on top of an e-commerce dataset using production-style SQL patterns.

## Scenario

Your team has transactional tables and event logs, but every KPI request still turns into ad hoc SQL. You need to design a small, reusable analytics layer that answers finance, customer, product, funnel, and retention questions with stable query outputs.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

If a reference example exists later for comparison, it should live in a separate sibling folder named:

- `reference_example_sql_analytics_engine`

## Starter Assets You Already Have

This guided project already includes:

- `dataset.md` with suggested source tables and columns
- `requirements.md` with functional and non-functional expectations
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for SQL files, notebooks, or query modules grouped by analytical layer
- `config/` for dataset assumptions and runtime notes if you use a database locally
- `data/` for sample schemas, seed notes, or output contracts
- `tests/` for validation queries and reconciliation checks
- `docker/` for optional local database runner notes

## Expected Deliverables

- a documented source model
- reusable KPI queries or views
- customer analytics outputs
- product analytics outputs
- funnel and retention outputs
- a short assumptions note covering business rules and edge cases

## What You Must Build

- document source table grain and key columns
- define what counts as valid revenue and valid orders
- create reusable SQL for KPI, customer, and product analytics
- build at least one funnel output and one retention output
- add a validation approach for duplicates, missing timestamps, or ambiguous statuses

## Project Structure

	01_sql_analytics_engine/
		README.md
		architecture.md
		dataset.md
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

Read `architecture.md`, `dataset.md`, and `requirements.md` to define the analytical layers and business rules.

### Step 2

Document the source model and grain assumptions.

### Step 3

Implement reusable SQL for KPI, customer, and product analytics in `src/`.

### Step 4

Add funnel and retention logic.

### Step 5

Write validation queries or reconciliation checks in `tests/`.

### Step 6

Summarize assumptions, limitations, and known trade-offs.

## Implementation Requirements

- keep query grain explicit
- use deterministic tie-break logic for ranking and deduplication
- make business filters visible instead of hiding them in ambiguous predicates
- separate reusable intermediate logic from final analytical outputs
- name outputs so another engineer can understand them without reverse engineering the SQL

## Validation Ideas

- reconcile revenue outputs against source orders
- compare product revenue and order totals for consistency
- verify no duplicate latest customer rows if you build current-state logic
- verify funnel and retention definitions match the documented assumptions

## Definition Of Done

This project is complete if:

- the project produces stable, explainable analytical outputs
- KPI, customer, product, funnel, and retention layers are all represented
- business assumptions and edge cases are documented clearly
- the SQL looks like a maintainable analytics foundation rather than isolated one-off queries

## Suggested Self-Check

If a reference example exists later, compare only after implementing the project independently.

The main project folder should remain a guided build exercise, not a pre-solved implementation.

## Possible Improvements

- add dbt-style model layering
- add warehouse-specific optimizations
- add benchmark datasets for performance comparison
