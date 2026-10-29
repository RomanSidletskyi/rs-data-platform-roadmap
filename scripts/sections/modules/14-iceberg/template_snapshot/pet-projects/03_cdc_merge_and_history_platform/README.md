# 03 CDC Merge And History Platform

## Project Goal

Design an Iceberg platform for CDC-style ingestion where raw events, mutable current state, and historical analysis are separated on purpose.

The project should force deliberate decisions about:

- append-only raw ingestion
- merge-driven current state
- Type 2 history boundaries
- compaction and delete cleanup expectations

## Scenario

Your platform receives inserts, updates, and deletes for orders and customers.

You need to support:

- raw CDC preservation for replay
- one current-state serving layer for operational analytics
- one historical customer layer for time-aware analysis
- Spark as the engine performing mutation logic

## Project Type

This folder is a guided project, not a ready solution.

You are expected to design the implementation by following this README and the supporting documents in the folder.

## Starter Assets You Already Have

This guided project already includes:

- `architecture.md`
- `requirements.md`
- `contract.md`
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Expected Deliverables

- one explicit raw CDC table design
- one current-state merge table design
- one Type 2 history design
- one maintenance plan for small files and delete artifacts

## What You Must Build

- define which feeds remain append-only
- define where `MERGE` is mandatory
- explain how deletes affect current-state and history tables differently
- document maintenance responsibilities after mutation-heavy workloads

## Project Structure

	03_cdc_merge_and_history_platform/
		README.md
		architecture.md
		requirements.md
		contract.md
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

## Definition Of Done

This project is complete if:

- raw, current-state, and history roles are separated clearly
- mutation boundaries are explicit
- maintenance is part of the design
- the project explains why one-table-does-everything is a bad idea here