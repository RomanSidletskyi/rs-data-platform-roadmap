# 04 Snowflake Open Table Publish

## Project Goal

Design a Snowflake publishing layer that uses native tables, external tables, and Snowflake-managed Iceberg deliberately instead of treating them as interchangeable storage options.

## Scenario

Your platform ingests partner order, shipment, and refund files into cloud storage. Analytics teams work in Snowflake, but a second compute engine also needs one curated publish dataset. You need to design a path from raw file exposure to a stable consumer contract without making raw files the permanent serving layer.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

## Starter Assets You Already Have

This guided project already includes:

- `source_landscape.md` with the incoming storage and feed landscape
- `contract.md` with the expected published dataset shape
- `requirements.md` with functional and non-functional expectations
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for SQL DDL, publish logic, and comparison notes
- `config/` for external volume, stage, and environment assumptions
- `data/` for file-layout examples and sample contracts
- `tests/` for publish-contract checks and layer-boundary validation
- `docker/` for optional local tooling notes only

## Expected Deliverables

- one explicit storage-to-publish architecture
- one external table exposure pattern
- one native raw ingestion contract
- one Snowflake-managed Iceberg publish contract
- one decision note explaining why each layer exists

## What You Must Build

- describe the raw storage layout and why it matters
- define when the feed is queried externally and when it is loaded natively
- create a credible Iceberg publish table for shared curated consumption
- explain what belongs in the publish contract and what must stay internal
- document at least three anti-patterns the design avoids

## Project Structure

	04_snowflake_open_table_publish/
		README.md
		architecture.md
		source_landscape.md
		contract.md
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

Read `architecture.md`, `source_landscape.md`, `contract.md`, and `requirements.md`.

### Step 2

Define the three layers clearly:

- exploratory file exposure
- operational warehouse ingestion
- curated publish contract

### Step 3

Draft the Snowflake objects for each layer.

### Step 4

Write SQL or pseudo-SQL for the publish flow.

### Step 5

Add checks that prove the curated contract is stable and consumer-facing.

### Step 6

Summarize trade-offs, including why some datasets should remain native and not become Iceberg.

## Implementation Requirements

- keep the raw, operational, and contract layers distinct
- do not use external tables as the permanent final semantic layer
- do not publish unstable intermediate fields into the Iceberg contract
- make multi-engine sharing a real requirement, not a fashionable assumption
- keep change control visible at the publish boundary

## Validation Ideas

- verify the publish table schema is smaller and more stable than internal staging tables
- verify each layer has a clear ownership reason
- verify the design explains why not every table should be Iceberg
- verify consumer contract tests focus on schema stability and freshness expectations

## Definition Of Done

This project is complete if:

- the layer boundaries are explicit
- the Iceberg publish contract is credible
- the native/raw/external distinctions are architecturally justified
- the project reads like a real platform publishing design, not a feature checklist