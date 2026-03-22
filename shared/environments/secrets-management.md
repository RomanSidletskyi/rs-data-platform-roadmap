# Secrets Management

This note defines where secrets should live for this repository and where they should never live.

This is a shared rule for all modules.

The goal is simple:

- keep secrets usable locally
- keep secrets usable in runtime environments such as Raspberry Pi
- keep secrets out of git

## Core Rule

Real secrets must never be stored in:

- `README.md`
- `solution.md`
- `commands-cheatsheet.md`
- architecture notes
- any tracked `.md`, `.py`, `.yml`, `.json`, or `.env` file in the repository

The repository should contain only:

- templates
- placeholders
- examples with fake values

## What Counts As A Secret

Examples:

- passwords
- API keys
- access tokens
- database credentials
- cloud credentials
- webhook secrets
- connection strings with real credentials
- SSH private keys

## Recommended Storage Locations

### On Your Main Machine

Use one of these:

1. system keychain or password manager
2. local config directory outside git

Recommended local config directory:

```text
~/.config/rs-data-platform/
```

Suggested layout:

```text
~/.config/rs-data-platform/
├── github.env
├── airflow.env
├── minio.env
├── postgres.env
├── azure.env
└── app.env
```

Use this for:

- API tokens used from the laptop
- local development env files
- credentials for scripts you run directly from your main machine

### On Runtime Hosts

Use a host-local config directory outside the git repo.

For Raspberry Pi the recommended path is:

```text
/srv/rs-data-platform/configs/
```

Suggested layout:

```text
/srv/rs-data-platform/configs/
├── airflow/
│   └── .env
├── minio/
│   └── .env
├── postgres/
│   └── .env
├── github/
│   └── .env
└── shared/
    └── app.env
```

Use this for:

- Docker Compose runtime secrets
- host-local service credentials
- environment-specific runtime configuration

## What Goes In Git

Allowed in git:

- `.env.example`
- config templates
- fake example values
- docs describing required variables

Not allowed in git:

- real `.env`
- real passwords
- real tokens
- copied secret values from old notes

## Example Pattern For Compose

Good pattern:

- keep `.env.example` in repo
- create real `.env` locally on the target host
- load it when starting the stack

Repository example:

- `shared/docker/compose/raspberry-pi/airflow-minio-postgres/.env.example`

Runtime real file example:

```text
/srv/rs-data-platform/configs/airflow/.env
```

## Example Pattern For Scripts

Good pattern:

- store credentials in local env file outside repo
- load them through shell or dotenv tooling

Example on the main machine:

```bash
set -a
source ~/.config/rs-data-platform/github.env
set +a
```

Then run your script.

For a practical guide on creating, reading, editing, and loading local env files, see:

- `shared/environments/local-env-files-workflow.md`

For an overview of which tool reads which source of configuration, see:

- `shared/environments/who-reads-what.md`

## File Permissions

On the main machine:

```bash
mkdir -p ~/.config/rs-data-platform
chmod 700 ~/.config/rs-data-platform
chmod 600 ~/.config/rs-data-platform/*.env
```

On a runtime host such as Raspberry Pi:

```bash
mkdir -p /srv/rs-data-platform/configs
chmod 700 /srv/rs-data-platform/configs
find /srv/rs-data-platform/configs -type f -name "*.env" -exec chmod 600 {} \;
```

## Suggested Naming Pattern

Use names that reflect the service or tool:

- `github.env`
- `airflow.env`
- `minio.env`
- `postgres.env`
- `azure.env`
- `shared.env`

Avoid one huge catch-all file if possible.

Smaller files are easier to rotate and reason about.

## Secrets Rotation Guidance

Rotate immediately if:

- you previously stored a secret in notes
- you committed a secret by accident
- you copied passwords into markdown files
- you shared screenshots or files containing credentials

At minimum, rotate:

- Portainer password
- MinIO credentials
- Airflow admin password
- GitHub tokens
- any database passwords used in old notes

## What To Do With Old Notes

If old notes contain credentials:

1. remove or redact the secrets
2. replace them with placeholders
3. keep only the technical workflow
4. rotate anything that may still be valid

Good:

- `ssh <user>@pi5.local`
- `sudo rpi-eeprom-update -a`
- `docker run ...`

Bad:

- real password values
- copied access tokens
- private connection strings

## Recommended Working Rule For This Repo

Use this split consistently:

- repo = code, docs, templates
- main machine local config = personal local secrets
- runtime host config dir = runtime service secrets

That split will prevent most accidental leaks.

## Important Gap In Current Repository

This repository currently has no root `.gitignore` file.

That increases the risk of accidentally committing:

- `.env`
- logs
- generated runtime files
- local secrets

Recommended next step after this document:

- add a root `.gitignore` with secret and runtime exclusions