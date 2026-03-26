# Pet Project 03 - Optional Python ETL Service On Pi

## Goal

Run a small Python ETL service on Raspberry Pi without Docker.

## Why This Project Is Optional

This project is useful if later you want to compare Docker-based runtime against a direct host-level `systemd` runtime:

- log in with SSH
- create a host directory layout
- create a Python virtual environment
- run the job as a `systemd` service
- inspect logs with `journalctl`

This gives you a second runtime model, but it is not the main recommended path.

## Scope

- one small Python ETL-style script
- local runtime directory under `/srv/rs-data-platform/runtime`
- Python virtual environment
- one `systemd` unit file
- restart and log inspection workflow

## Suggested Project Layout

```text
/srv/rs-data-platform/runtime/pi-etl-service/
├── app.py
├── requirements.txt
└── .venv/
```

## Suggested Script Behavior

The service can do something simple but realistic, for example:

- read a small local CSV or JSON file
- transform it a little
- write output to `/srv/rs-data-platform/data/generated/`
- log one line every run

## Recommended Workflow

1. create `/srv/rs-data-platform/runtime/pi-etl-service`
2. add a small Python script
3. create `.venv` and install dependencies
4. create `/etc/systemd/system/pi-etl-service.service`
5. enable and start the service
6. inspect logs with `journalctl -u pi-etl-service`

## Expected Outcome

You can operate a persistent Python service on Raspberry Pi without Docker and with normal Linux service management.

## Better Default Path Before This Project

Do these first:

- [Pet Project 01 - Remote Docker Lab](../01_remote_docker_lab/README.md)
- [Pet Project 02 - Airflow On Raspberry Pi](../02_airflow_on_raspberry_pi/README.md)