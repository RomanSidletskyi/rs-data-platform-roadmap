# 03 Log Parser Pipeline

## Project Goal

Build a parser that converts raw application logs into structured event datasets and useful summaries.

## Scenario

Your team receives raw application logs that are still useful for operational analytics, but only after parsing and structuring them. The project should turn text lines into event records, identify malformed input, and produce summary outputs.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

## Starter Assets You Already Have

This guided project already includes:

- `data/sample_application.log` as a starter raw log file
- `data/expected_event_contract.md` as the target structured output contract
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for parser, transformer, and writer logic
- `config/` for log format and severity assumptions
- `data/` for sample raw logs and expected outputs
- `docker/` for optional runtime notes
- `tests/` for parser and summary validation

## Expected Deliverables

- one parser for raw log lines
- one structured event output
- one summary output
- one strategy for malformed line handling

## What You Must Build

- read raw log files
- parse timestamps and severity
- convert valid lines into structured events
- report or quarantine invalid lines
- produce summary output such as counts by severity or day

## Recommended Implementation Plan

### Step 1

Read `architecture.md` and define the log format contract.

### Step 2

Implement parser logic for one clear format.

### Step 3

Generate structured outputs and at least one summary.

### Step 4

Add tests for valid and malformed lines.

## Definition Of Done

This project is complete if:

- raw logs are transformed into structured events
- malformed lines are handled explicitly
- a summary output exists and matches the structured records

## Suggested Self-Check

The main project folder should remain a guided build exercise, not a pre-solved implementation.
