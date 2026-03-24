# Reference Example — Python Quality Pipeline

This folder is a solved reference implementation for the guided Python quality pipeline project.

## What This Example Shows

- pull-request quality validation for Python code
- matrix testing across multiple Python versions
- explicit separation between bytecode validation and test execution
- a small Dockerfile that keeps packaging concerns visible without turning the project into a deploy workflow

## How To Read It

1. inspect the small application in `src/`
2. inspect the tests in `tests/`
3. inspect the CI workflow in `.github/workflows/python-ci.yml`
4. compare the workflow boundaries to the guided project version

## Main Lesson

A good first Python CI workflow should stay narrow, readable, and fast. Validation should be obvious, reruns should be easy to reason about, and packaging should not be mixed into deploy logic too early.