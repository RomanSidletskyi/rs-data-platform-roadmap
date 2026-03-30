# 02 MinIO Nessie Branching Lab

## Project Goal

Design a homelab-style Iceberg platform where MinIO stores table data, Nessie acts as the catalog control plane, and Spark is used to validate branch-aware development workflows.

The project should force deliberate decisions about:

- storage versus catalog separation
- branch-aware experimentation versus direct writes on main
- promotion flow from dev to main
- what a small lakehouse control plane adds beyond plain file storage

## Scenario

You want a low-cost internal platform where engineers can test table evolution and mutation logic before promoting the result to the main branch.

You need to support:

- one shared warehouse in MinIO
- Nessie references for isolated experimentation
- Spark as the main engine for writes and validation
- branch-aware testing before publish

## Project Type

This folder is a guided project, not a ready solution.

You are expected to design the implementation by following this README and the supporting documents in the folder.

If a solved comparison is needed after implementation, use the sibling reference example:

- `reference_example_minio_nessie_branching_lab`

## Starter Assets You Already Have

This guided project already includes:

- `architecture.md` with the target platform shape
- `requirements.md` with functional and non-functional expectations
- `contract.md` with branch and publish expectations
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for Spark SQL or PySpark flow notes
- `config/` for catalog config, branch naming, and warehouse assumptions
- `data/` for example schemas and change scenarios
- `tests/` for branch safety and promotion checks
- `docker/` for local stack notes only

## Expected Deliverables

- one MinIO plus Nessie plus Spark platform design
- one branch promotion flow
- one safe pattern for testing schema evolution off main
- one explanation of when a branch is useful and when it is operational noise

## What You Must Build

- define the warehouse path model in MinIO
- define the Nessie branch model for development and promotion
- show how Spark reads and writes on different references
- explain how to compare branch state before merge to main
- document at least three anti-patterns the design avoids

## Project Structure

	02_minio_nessie_branching_lab/
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

## Recommended Implementation Plan

### Step 1

Read `architecture.md`, `requirements.md`, and `contract.md`.

### Step 2

Define the branch model:

- `main`
- one short-lived development branch
- one promotion check path

### Step 3

Draft the Spark catalog setup and example branch-aware commands.

### Step 4

Define how changes are validated before merge into main.

### Step 5

Document operational limits for a small shared Nessie-based lab.

## Definition Of Done

This project is complete if:

- the branch model is explicit
- catalog, storage, and compute roles are clearly separated
- promotion safety is defined
- the project explains both value and cost of branch-aware table work