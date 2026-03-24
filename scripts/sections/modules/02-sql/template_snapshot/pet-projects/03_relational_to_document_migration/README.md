# 03 Relational to Document Migration

## Project Goal

Convert a relational schema into a document-oriented model and explain the trade-offs.

## Scenario

Your team has a normalized e-commerce schema, but a new service wants a document-oriented data model that serves order-centric reads more naturally. The migration should not copy tables one-to-one. It should redesign the model around document boundaries, query paths, and update trade-offs.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

If a reference example exists later for comparison, it should live in a separate sibling folder named:

- `reference_example_relational_to_document_migration`

## Starter Assets You Already Have

This guided project already includes:

- `source_model.md` with the relational starting point
- `target_model.md` with an example document direction
- `migration_strategy.md` with the migration sequence to reason through
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for migration notes, query comparisons, or example transformation logic
- `config/` for system assumptions and collection naming notes
- `data/` for sample relational rows and target document examples
- `tests/` for query comparison checks or model-contract notes
- `docker/` for optional local MongoDB or SQL playground notes

## Expected Deliverables

- a documented source relational model
- a target document model
- side-by-side query comparisons
- a trade-off analysis covering duplication, joins, and update behavior
- an explicit migration recommendation

## What You Must Build

- describe the relational source grain and relationships clearly
- define document boundaries and what gets embedded or referenced
- compare how the same business questions work in SQL and in the document model
- explain what became easier and what became harder after migration
- document the migration strategy without pretending the target is always strictly better

## Project Structure

	03_relational_to_document_migration/
		README.md
		architecture.md
		source_model.md
		target_model.md
		migration_strategy.md
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

Read `source_model.md`, `target_model.md`, and `migration_strategy.md` to understand the redesign goal.

### Step 2

Document the main relational access patterns and pain points.

### Step 3

Design the document model around order-centric and customer-centric reads.

### Step 4

Write side-by-side SQL and document-query comparisons.

### Step 5

Summarize trade-offs such as duplication, update fan-out, and indexing differences.

### Step 6

Write a recommendation explaining when the migration is justified and when it is not.

## Implementation Requirements

- do not map tables to collections one-to-one without redesign
- justify every embedded or referenced component in terms of query behavior
- keep the trade-off analysis honest instead of treating document models as universally better
- make indexing implications visible in the target design
- keep update complexity and document growth visible in the final notes

## Validation Ideas

- verify the target model answers the main order-centric reads with fewer joins
- verify the trade-off analysis includes both read and update consequences
- verify the same business questions are compared fairly across SQL and document models
- verify the final recommendation depends on workload, not preference alone

## Definition Of Done

This project is complete if:

- the relational and document models are both described clearly
- the query-path redesign is explicit
- the trade-off analysis is balanced and concrete
- the migration recommendation shows architectural judgment rather than schema translation only

## Suggested Self-Check

If a reference example exists later, compare only after implementing the project independently.

The main project folder should remain a guided build exercise, not a pre-solved implementation.

## Possible Improvements

- add a migration script prototype
- compare MongoDB and CosmosDB target variants
- add cost and index-maintenance analysis
