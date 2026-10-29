# 01 Spark Glue Orders Lakehouse

## Project Goal

Design an AWS-oriented Iceberg lakehouse flow where Spark writes curated order data into Iceberg tables registered in Glue and stored in S3.

The project should force deliberate decisions about:

- raw landing versus curated serving
- append-only history versus current-state tables
- Glue as control plane
- maintenance, retention, and troubleshooting expectations

## Scenario

Your platform receives order events and customer updates in S3.

You need to support:

- raw event preservation for replay and debugging
- curated current-state order analytics
- customer history analysis
- Spark as the primary writer
- at least one additional read engine through the same cataloged tables

## Project Type

This folder is a guided project, not a ready solution.

You are expected to design the implementation by following this README and the supporting documents in the folder.

If a solved comparison is needed after implementation, use the sibling reference example:

- `reference_example_spark_glue_orders_lakehouse`

## Starter Assets You Already Have

This guided project already includes:

- `architecture.md` with the target platform shape
- `source_landscape.md` with incoming data feeds
- `contract.md` with target serving contracts
- `requirements.md` with functional and non-functional requirements
- `.env.example` with runtime assumptions
- `runbook.md` with an optional local-lab path
- `config/runtime_config.json` with starter project settings
- `config/.env.local.example` with local lab settings
- `config/local_lab_runtime_config.json` with local catalog settings
- `config/spark-defaults.local.conf.template` with local Spark catalog wiring
- sample input data in `data/input/`
- `docker/docker-compose.yml` for a local Spark + MinIO lab
- `src/local_lab_quickstart.sql` for local Iceberg table verification
- `tests/validation_checklist.md` for local success criteria
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Optional Local Lab Mode

The target architecture is still AWS-oriented and Glue-backed.

For hands-on practice, this project also includes a local approximation that uses:

- MinIO instead of S3
- Spark local container as the main engine
- HadoopCatalog instead of Glue

Use the local lab to validate Iceberg table lifecycle and storage layout.

Do not treat it as a one-to-one replacement for Glue semantics.

## Suggested Folder Roles

- `src/` for Spark SQL, PySpark job shapes, and publish logic notes
- `config/` for catalog, S3 layout, and environment assumptions
- `data/` for example schemas, feed shapes, and sample change events
- `tests/` for contract checks, mutation checks, and maintenance assertions
- `docker/` for optional local tooling notes only

## Expected Deliverables

- one explicit raw-to-curated architecture
- one Glue-backed catalog design
- one append-only raw event table contract
- one current-state fact table contract
- one Type 2 customer history contract
- one maintenance and retention plan

## What You Must Build

- describe the S3 landing and warehouse layout
- define how Spark registers and writes Iceberg tables through Glue
- separate append-only raw history from mutable curated state
- show where `MERGE` is required and where append is enough
- document at least three anti-patterns the design avoids

## Project Structure

	01_spark_glue_orders_lakehouse/
		.env.example
		README.md
		architecture.md
		source_landscape.md
		contract.md
		requirements.md
		runbook.md
		config/
			.env.local.example
			README.md
			local_lab_runtime_config.json
			runtime_config.json
			spark-defaults.local.conf.template
		data/
			README.md
			input/
				orders_cdc.jsonl
				customer_snapshot.jsonl
		docker/
			README.md
			docker-compose.yml
			requirements.txt
		src/
			README.md
			runtime_config.py
			starter_job_outline.py
			ddl_starter.sql
			local_lab_quickstart.sql
		tests/
			README.md
			test_runtime_config.py
			validation_checklist.md

## Recommended Implementation Plan

### Step 1

Read `architecture.md`, `source_landscape.md`, `contract.md`, and `requirements.md`.

### Step 2

Define the table roles clearly:

- raw append-only events
- current-state fact serving table
- historical dimension table

### Step 3

Inspect the provided starter assets:

- `.env.example`
- `config/runtime_config.json`
- `data/input/orders_cdc.jsonl`
- `data/input/customer_snapshot.jsonl`

### Step 4

Draft Spark + Glue catalog setup and the initial table DDL.

### Step 5

Write the core ingestion and mutation flow.

### Step 6

Add maintenance, retention, and troubleshooting checks.

### Step 7

If you want practical validation before a full AWS design write-up, run the optional local lab from `runbook.md`.

### Step 8

Summarize trade-offs, especially why not every table should use the same ingestion model.

## Implementation Requirements

- keep raw, curated fact, and historical dimension boundaries explicit
- use Glue as a real metadata control plane, not as an incidental config detail
- do not collapse event history and current-state serving into one table without justification
- make `MERGE` workload boundaries explicit
- define maintenance as part of the design, not a later patch

## Validation Ideas

- verify each table has a clear grain and contract
- verify current-state and history semantics are not mixed accidentally
- verify maintenance responsibilities are explicit
- verify multi-engine reading assumptions are stated, not implied
- verify starter config resolves expected table names cleanly
- verify sample feeds map to different ingestion mental models

## Suggested Self-Check

After attempting the guided project independently, compare your implementation with:

- `14-iceberg/pet-projects/reference_example_spark_glue_orders_lakehouse`

## Definition Of Done

This project is complete if:

- the architecture has explicit table roles
- Glue catalog ownership is clear
- the ingestion and mutation patterns are justified
- the maintenance and governance model is explicit
- the project reads like a real platform design, not a feature checklist