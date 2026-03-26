# 04 Shell Automation For Data Jobs

## Project Goal

Build a guided shell automation layer around a data-job style workflow.

## Scenario

You need operational scripts for a small batch job workflow: run, archive logs, rotate outputs, and publish a summary.

## Expected Deliverables

- one orchestration script
- one backup/archive behavior
- one summary report
- safe exit-code handling

## Starter Assets Already Provided

- `.env.example`
- `src/run_data_job_wrapper.sh`
- `src/archive_job_artifacts.sh`
- `data/sample_job_run.log`
- `tests/fixture_expected_job_summary.txt`

## Definition Of Done

The workflow can be rerun safely and leaves clear logs and artifacts.