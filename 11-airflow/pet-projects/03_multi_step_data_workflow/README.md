# 03 Multi-Step Data Workflow

## Project Goal

Build a multi-step Airflow workflow with meaningful task grouping, validation, and at least one branching or fan-out/fan-in pattern.

## Scenario

You need a workflow that coordinates several stages across ingestion, validation, transformation, and publishing, while keeping the DAG understandable and operationally safe.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

If a reference example is added later, it should live in a separate sibling folder named:

- `reference_example_multi_step_data_workflow`

## What This Project Should Demonstrate

- multi-step orchestration design
- a readable DAG with more than a trivial linear chain
- failure isolation and validation gates
- practical use of branching, grouping, or fan-out/fan-in

## Starter Assets You Already Have

This guided project already includes:

- starter notes in `src/`, `tests/`, `docker/`, `config/`, and `data/`

## Suggested Folder Roles

- `src/` for DAGs and helper modules
- `config/` for workflow config examples
- `data/` for workflow contract notes
- `docker/` for local runtime assets
- `tests/` for DAG and helper validation

## Expected Deliverables

- one DAG with several meaningful stages
- at least one non-trivial dependency pattern
- one operational note about retries, validation, or publish safety

## What You Must Build

- a DAG with more structure than a simple linear example
- at least one fan-out or branch pattern
- one validation gate before a publish-style step
- a short note explaining the failure domains in the DAG

## Project Structure

	03_multi_step_data_workflow/
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

Read `architecture.md` and decide where the DAG should branch or converge.

### Step 2

Define the workflow stages and validation points.

### Step 3

Implement the DAG and helpers in `src/`.

### Step 4

Add checks or tests in `tests/`.

### Step 5

Add local runtime notes in `docker/`.

### Step 6

Run the DAG and document how the non-trivial dependency pattern behaves.

## Implementation Requirements

- keep the graph readable
- use only real dependencies
- avoid hiding workflow logic inside giant task functions
- include at least one validation boundary

## Validation Ideas

- inspect graph readability
- verify branch or fan-out logic is explicit
- verify publish-like step waits for the correct prerequisites

## Definition Of Done

This project is complete if:

- the DAG is more realistic than a simple three-task chain
- dependencies are meaningful and readable
- you can explain how the DAG isolates failures and controls downstream execution

## Suggested Self-Check

If a reference example exists later, compare only after implementing the project independently.

## Possible Improvements

- task groups
- trigger rules
- richer monitoring
- external system integration