# 01 Local Ops Toolkit

## Project Goal

Build a guided shell-based toolkit for local operational inspection.

## Scenario

You are handed a local project directory with logs, temporary files, and runtime processes. You need command-line helpers that quickly answer:

- what is large
- what is noisy
- which logs changed recently
- which processes are running

## Starter Assets Already Provided

- `architecture.md`
- `.env.example`
- `src/run_local_ops_toolkit.sh`
- `src/check_disk_and_logs.sh`
- `data/sample_app.log`
- `tests/fixture_expected_report_sections.txt`
- `config/README.md`
- `src/README.md`
- `tests/README.md`
- `docker/README.md`
- `data/README.md`

## Expected Deliverables

- one main shell entrypoint
- helper scripts for disk, log, and process inspection
- human-readable output for operators
- safe defaults for path handling

## Definition Of Done

The toolkit can inspect a local working directory without destructive behavior and gives useful outputs for disk, logs, and processes.