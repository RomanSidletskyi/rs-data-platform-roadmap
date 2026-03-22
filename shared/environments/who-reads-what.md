# Who Reads What

This note explains which process reads which configuration source in this repository.

The short answer is:

- the repository itself does not read secrets or env files
- specific tools and processes do

## Mental Model

There are three layers:

1. repository
2. local or host env files
3. runtime process

The repository stores:

- code
- docs
- templates
- example config files

The env files store:

- real local values
- real runtime values

The runtime process reads those values and uses them.

## Main Rule

To understand where a value comes from, ask:

- where is the process running?

If it runs on your main machine, it can read local files from your main machine.

If it runs on Raspberry Pi, it can read files available on Raspberry Pi.

If it runs on GitHub-hosted infrastructure, it cannot see your local files unless you explicitly pass values through GitHub secrets or a self-hosted runner setup.

## Who Reads What

### Shell On Your Main Machine

Reads from:

- variables already loaded into the current shell session
- files that you manually `source`

Example:

```bash
set -a
source ~/.config/rs-data-platform/github.env
set +a
```

After this, commands started from the same shell can read those variables.

### Python Script Started From Your Main Machine

Can read from:

- environment variables already loaded in the shell
- env files explicitly loaded by Python code

Typical pattern:

```bash
set -a
source ~/.config/rs-data-platform/postgres.env
set +a
python script.py
```

### Docker Compose On Raspberry Pi

Reads from:

- the local `.env` file near the compose file for compose-time substitution
- any `env_file` paths defined in `docker-compose.yml`

In your Raspberry Pi stack, the real runtime secrets are expected from a host-local file outside the repo.

### Container Started By Docker Compose

Reads from:

- environment variables passed by Docker Compose
- files mounted into the container, if configured

The container does not magically know about your Mac env files.

### Airflow Inside A Container

Can read from:

- environment variables in the Airflow container
- Airflow Connections
- Airflow Variables
- secret backends, if configured

### GitHub Actions

Does not read:

- `~/.config/rs-data-platform/*.env` on your Mac
- `/srv/rs-data-platform/configs/*` on Raspberry Pi

GitHub Actions reads from:

- GitHub repository secrets
- GitHub environment secrets
- GitHub variables
- files present in the runner workspace

## Practical Examples For This Repository

### Example 1 - Local GitHub CLI Or Curl

Source file:

- `~/.config/rs-data-platform/github.env`

Read by:

- current shell
- `gh`
- `curl`
- Python script started from that shell

### Example 2 - Raspberry Pi Airflow Stack

Template file in repo:

- `shared/docker/compose/raspberry-pi/airflow-minio-postgres/.env.example`

Real runtime file on Raspberry Pi:

- `/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env`

Read by:

- Docker Compose on Raspberry Pi
- containers started by that stack

### Example 3 - GitHub Actions Workflow

Local Mac env file:

- not visible to GitHub-hosted runner

Raspberry Pi env file:

- not visible to GitHub-hosted runner

Correct source:

- GitHub Actions secrets and variables

## Cross Reference

For editing and loading local env files, see:

- `shared/environments/local-env-files-workflow.md`

For secret placement rules, see:

- `shared/environments/secrets-management.md`