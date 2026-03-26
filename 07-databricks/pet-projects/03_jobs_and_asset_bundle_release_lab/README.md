# 03 Jobs And Asset Bundle Release Lab

## Project Goal

Design a Databricks release flow where jobs and environment-specific deployment state are versioned and promoted rather than edited manually in production.

## Scenario

A team currently maintains production jobs by hand in the workspace UI.

The platform needs a safer model using:

- source control
- environment parameters
- deployable Databricks asset definitions
- explicit release steps

## Project Type

This folder is a guided project.

## Expected Deliverables

- one job definition shape
- one environment promotion model
- one release checklist
- note about what must not remain manual in production

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `config/README.md`
- `data/README.md`
- `docker/README.md`
- `src/README.md`
- `tests/README.md`

## Definition Of Done

The lab shows a credible path from workspace experimentation to versioned and reviewable Databricks job deployment.