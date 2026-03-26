# Architecture Notes

## Project

`02_python_docker_github_actions`

## Intended System Shape

Batch workflow with reproducible packaging and CI validation:

    Source -> Python Workflow -> Packaged Runtime -> CI Validation -> Delivery

## Main Responsibilities

- reproducible local and CI execution
- containerized runtime definition
- automated validation before change acceptance

## Key Design Questions

- what real execution or delivery problem does Docker solve here
- what should CI validate on every change
- where does tooling overhead exceed the project need

## First Risks To Watch

- containerization added without a real reproducibility problem
- CI validates formatting only and misses workflow correctness
- local and CI environments drift despite extra tooling

## Candidate ADRs

- `Use Containerized Execution For Reproducible ETL Delivery`
- `Validate Data Workflow Changes In CI Before Merge`

## Review Pairing

- `../../docs/architecture/reviews/system-shape-review-checklist.md`
- `../../docs/architecture/adr/template.md`