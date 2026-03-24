# 01 Python Quality Pipeline

## Goal

Build a production-style Python validation pipeline around a small application repository.

## Scenario

You own a Python service used in a wider data platform. Every change should pass formatting, static validation, tests, and a minimal packaging check before merge.

## What You Should Build

- a pull-request workflow for quality validation
- a manual workflow for rerunning checks
- clear job boundaries for install, validation, and tests
- an optional matrix for multiple Python versions

## Recommended Deliverables

- `.github/workflows/python-ci.yml`
- `requirements.txt` or `pyproject.toml`
- a small `src/` package
- a small `tests/` suite
- one short document explaining failure boundaries

## Constraints

- keep deployment out of this project
- prefer observable steps over one large shell command
- treat caching as optimization, not as business state

## Completion Criteria

- PRs trigger validation automatically
- failures are easy to localize
- the workflow is understandable by a new teammate in a few minutes