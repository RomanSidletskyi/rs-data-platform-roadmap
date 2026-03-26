# 05 Incremental Ingestion Simulator

## Project Goal

Build a small ingestion workflow that processes only new or changed records between runs.

## Scenario

Your team cannot afford to reload the full dataset every time. The project should simulate incremental ingestion using local files, persisted state, and clear rules for identifying new or changed records.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

## Starter Assets You Already Have

This guided project already includes:

- `data/source_snapshot_run_1.json` and `data/source_snapshot_run_2.json` for first-run and next-run comparison
- `data/state_contract.md` for minimum state-management expectations
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for reading, state handling, diff logic, and output persistence
- `config/` for state and key assumptions
- `data/` for source samples, output examples, and state examples
- `docker/` for optional runtime notes
- `tests/` for state-transition validation

## Expected Deliverables

- one source reader
- one persisted state contract
- one diff or change-detection layer
- one incremental output

## What You Must Build

- read source records
- load existing state or initialize it
- detect new or changed records
- process only the incremental subset
- update state after successful processing

## Recommended Implementation Plan

### Step 1

Read `architecture.md` and define the unique key plus change-detection rule.

### Step 2

Design the state file structure.

### Step 3

Implement source reading, state handling, and incremental diff logic.

### Step 4

Add tests for first run, no-change run, and changed-record run.

## Definition Of Done

This project is complete if:

- the first run initializes state correctly
- later runs process only new or changed data
- the state update happens only after successful processing

## Suggested Self-Check

The main project folder should remain a guided build exercise, not a pre-solved implementation.
