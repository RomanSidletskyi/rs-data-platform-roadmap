# Use Postgres Env

This note shows how to use your local Postgres env file from the shell.

Expected file:

```text
~/.config/rs-data-platform/postgres.env
```

Example content:

```bash
POSTGRES_DB=mydb
POSTGRES_USER=myuser
POSTGRES_PASSWORD=replace_me_locally
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

## Option 1 - Load Manually

```bash
set -a
source ~/.config/rs-data-platform/postgres.env
set +a
```

Verify:

```bash
env | grep '^POSTGRES_'
```

## Option 2 - Load With Helper Script

From the repository root:

```bash
source shared/scripts/helpers/load-env.sh postgres
```

Verify:

```bash
env | grep '^POSTGRES_'
```

## Use With Python

Example shell flow:

```bash
source shared/scripts/helpers/load-env.sh postgres
python script.py
```

Inside Python, code can read:

```python
import os

postgres_host = os.environ["POSTGRES_HOST"]
postgres_db = os.environ["POSTGRES_DB"]
```

## Use With Psql

Example:

```bash
source shared/scripts/helpers/load-env.sh postgres
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB"
```

## Common Pattern

```bash
cd /Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap
source shared/scripts/helpers/load-env.sh app postgres
env | grep '^POSTGRES_'
python script.py
```