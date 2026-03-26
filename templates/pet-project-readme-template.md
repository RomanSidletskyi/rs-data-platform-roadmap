# <Pet Project Name>

## Project Goal

Describe what the learner should build.

## Scenario

Describe the business or engineering situation that makes the project realistic.

## Project Type

This folder is a guided project, not a ready solution.

The learner should implement the project by following this README and the target design described in `architecture.md`.

If a reference example exists for later comparison, it should live in a separate sibling folder named:

- `reference_example_<project-name>`

## Starter Assets You Already Have

List the files already provided to help the learner start.

Examples:

- sample input data
- `.env.example`
- config examples
- schema files
- starter notes in `src/`, `tests/`, or `docker/`

## Suggested Folder Roles

- `src/` for implementation code
- `config/` for config examples
- `data/` for input and output samples
- `tests/` for validation
- `docker/` for Docker-related assets

## Expected Deliverables

List what the learner must produce by the end of the project.

## What You Must Build

List the concrete outcomes that define the project.

Use action-oriented bullets such as:

- read input data
- validate required fields
- transform records
- write outputs
- run locally and in Docker

## Project Structure

	<project-name>/
		.env.example
		README.md
		architecture.md
		config/
		data/
		docker/
		src/
		tests/

## Recommended Implementation Plan

### Step 1

Read `architecture.md` and understand the target components and flow.

### Step 2

Inspect the provided starter assets.

### Step 3

Implement the application code in `src/`.

### Step 4

Add tests in `tests/`.

### Step 5

Add Docker or runtime assets in `docker/`.

### Step 6

Run and validate the project.

## Implementation Requirements

List non-negotiable technical requirements.

Examples:

- use environment variables for runtime paths
- avoid hardcoded machine-specific values
- keep the solution simple and readable
- persist outputs outside the image when relevant

## Validation Ideas

Describe how the learner can verify the project works.

## Definition Of Done

State what must be true before the project is considered complete.

## Suggested Self-Check

If a reference example exists, tell the learner to compare only after attempting the project independently.

The main project folder should remain a guided build exercise, not a pre-solved implementation.

## Possible Improvements

List optional extensions for a second iteration.

## Optional Next Step

Describe where the learner could take this project next.
