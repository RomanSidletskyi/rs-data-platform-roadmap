# 02 JSON Normalizer

## Project Goal

Build a reusable tool that converts nested JSON payloads into flat, analysis-friendly outputs.

## Scenario

Your team receives nested JSON files from APIs or internal services. Downstream consumers do not want nested payloads directly, so the project needs to flatten selected structures and produce a cleaner analytical output contract.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

## Starter Assets You Already Have

This guided project already includes:

- `data/sample_nested_orders.json` as a starter nested payload
- `data/expected_output_contract.md` as the first normalized target shape
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for reader, normalizer, and writer logic
- `config/` for normalization mapping ideas
- `data/` for sample nested JSON and output examples
- `docker/` for optional runtime notes
- `tests/` for flattening and schema checks

## Expected Deliverables

- one JSON reader boundary
- one normalization layer
- one flat output contract
- handling for missing nested keys
- a short note explaining field mapping choices

## What You Must Build

- read one or more nested JSON files
- flatten selected structures intentionally
- write normalized output in a tabular-friendly shape
- handle invalid or inconsistent inputs clearly

## Recommended Implementation Plan

### Step 1

Read `architecture.md` and define the target output columns.

### Step 2

Design the flattening rules for nested objects and arrays.

### Step 3

Implement the reader, normalizer, and writer in `src/`.

### Step 4

Add tests for nested-key extraction and fallback behavior.

## Definition Of Done

This project is complete if:

- nested JSON is converted into a clear flat contract
- the mapping is understandable to another engineer
- invalid inputs fail clearly or are quarantined explicitly

## Suggested Self-Check

The main project folder should remain a guided build exercise, not a pre-solved implementation.
