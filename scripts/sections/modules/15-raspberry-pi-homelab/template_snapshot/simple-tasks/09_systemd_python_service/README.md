# Simple Task 09 - Optional Systemd Python Service

## Goal

Run a small Python script as a background service on Raspberry Pi without Docker.

Ready answer with concrete steps and commands:

- [solution.md](solution.md)

Use this as an optional alternative path if you want to run a small host service without containers.

Start with this learning material:

- [systemd Python service cheatsheet](../../learning-materials/14_systemd_python_service_cheatsheet.md)

## What To Practice

- creating a Python virtual environment
- creating a `systemd` unit file
- enabling and starting the service
- reading logs with `journalctl`

## Definition Of Done

- the service starts with `systemctl`
- the service survives restart through `enable`
- you can inspect logs with `journalctl`