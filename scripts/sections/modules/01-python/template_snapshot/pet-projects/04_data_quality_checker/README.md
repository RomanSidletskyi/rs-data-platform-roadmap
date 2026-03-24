# 04 Data Quality Checker

## Project Goal

Build a small quality-validation tool that inspects a dataset, applies rules, and produces a readable quality report.

## Scenario

Your team receives a dataset before loading it into a reporting layer. You need a lightweight validation step that checks required fields, duplicates, formats, and business-rule violations before the data is trusted downstream.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

## Starter Assets You Already Have

This guided project already includes:

- `data/sample_orders.csv` with intentional quality problems
- `data/quality_rules.md` with structural and business validation ideas
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for reader, checks, and report generation logic
- `config/` for rule definitions and required column lists
- `data/` for input samples and report examples
- `docker/` for optional runtime notes
- `tests/` for check-level validation

## Expected Deliverables

- one dataset reader
- one set of quality checks
- one report output
- one clear failure summary

## What You Must Build

- read a structured dataset
- apply required-field and duplicate checks
- add at least one business-specific validation rule
- produce a readable quality report
- separate pass metrics from failed checks

## Recommended Implementation Plan

### Step 1

Read `architecture.md` and define the dataset contract.

### Step 2

List the checks that matter most for the scenario.

### Step 3

Implement the checks and reporting in `src/`.

### Step 4

Add tests for failed-rule behavior and report output.

## Definition Of Done

This project is complete if:

- the dataset can be evaluated against clear rules
- failures are easy to inspect
- the report explains both counts and examples of bad data

## Suggested Self-Check

The main project folder should remain a guided build exercise, not a pre-solved implementation.
