# Reference Example — Data Project Reusable Automation

This folder is a solved reference implementation for the guided reusable automation project.

## What This Example Shows

- a repository-facing CI workflow that delegates validation to a reusable workflow
- a reusable workflow with one focused validation responsibility
- a small Python helper that validates structural expectations
- explicit artifact hand-off for a validation report

## How To Read It

1. inspect the repository entry workflow in `.github/workflows/ci.yml`
2. inspect the reusable workflow in `.github/workflows/reusable-validate.yml`
3. inspect the helper and tests in `src/` and `tests/`
4. compare the ownership boundary to the guided project version

## Main Lesson

Reusable automation works best when the repository still owns triggers and local policy, while shared workflow logic owns only the repeated validation graph.