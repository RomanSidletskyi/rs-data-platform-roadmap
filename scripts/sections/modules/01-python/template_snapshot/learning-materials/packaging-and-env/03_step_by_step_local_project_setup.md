# Step-By-Step Local Project Setup

## Why This File Exists

Some learners understand the ideas behind environments and configuration, but still do not feel comfortable creating a clean local Python project from zero.

This file is a practical walkthrough.

The goal is to show a simple and credible local setup for a small data engineering style project.

We will build a small project that:

- uses a virtual environment
- has explicit dependencies
- keeps secrets out of source code
- stores structured configuration in YAML
- has one clear entrypoint

## Target Project Shape

By the end, the project should look like this:

```text
project/
  .env.example
  .gitignore
  README.md
  requirements.txt
  config/
    config.yaml
  data/
    raw/
    processed/
    quarantine/
  src/
    main.py
    config_loader.py
    processor.py
  tests/
```

## Step 1: Create The Project Folders

Create the basic shape first.

```bash
mkdir -p project/config project/data/raw project/data/processed project/data/quarantine project/src project/tests
cd project
```

Why:

- folders create visible responsibility boundaries early

## Step 2: Create A Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
python --version
which python
```

What to look for:

- `which python` should point inside `.venv`

Why:

- this confirms the project is using an isolated interpreter and package set

## Step 3: Install A Small Set Of Dependencies

For a small local ingestion-style project, this is enough:

```bash
python -m pip install --upgrade pip
pip install requests PyYAML python-dotenv pytest
```

Why these packages:

- `requests` for HTTP
- `PyYAML` for structured config
- `python-dotenv` for local env vars
- `pytest` for tests

## Step 4: Save Dependencies To `requirements.txt`

```bash
pip freeze > requirements.txt
```

Why:

- another machine can now install the same dependency set more reliably

## Step 5: Add `.gitignore`

Create `.gitignore` with content like:

```gitignore
.venv/
__pycache__/
.env
*.log
.DS_Store
```

Why:

- local environment files and secrets should not be committed

## Step 6: Add `.env.example`

Create `.env.example`:

```text
API_TOKEN=
APP_ENV=local
LOG_LEVEL=INFO
```

Why:

- this documents required environment variables without exposing real values

## Step 7: Add Structured Config

Create `config/config.yaml`:

```yaml
api:
  base_url: https://jsonplaceholder.typicode.com
  timeout: 30

paths:
  raw_dir: data/raw
  processed_dir: data/processed
  quarantine_dir: data/quarantine
```

Why:

- paths and non-secret runtime settings now live outside source code

## Step 8: Create A Config Loader

Create `src/config_loader.py`:

```python
from pathlib import Path
import os

import yaml
from dotenv import load_dotenv


def load_config() -> dict:
    load_dotenv()

    config = yaml.safe_load(Path("config/config.yaml").read_text(encoding="utf-8"))
    config["api"]["token"] = os.environ.get("API_TOKEN", "")
    config["runtime"] = {
        "environment": os.environ.get("APP_ENV", "local"),
        "log_level": os.environ.get("LOG_LEVEL", "INFO"),
    }
    return config
```

Why:

- the rest of the project can work with one resolved config object

## Step 9: Add A Small Processor

Create `src/processor.py`:

```python
def normalize_user(record: dict) -> dict:
    return {
        "id": record["id"],
        "name": record["name"].strip(),
        "email": record["email"].strip().lower(),
    }
```

Why:

- even a tiny project should keep transformation logic separate from setup code

## Step 10: Add The Entrypoint

Create `src/main.py`:

```python
from pathlib import Path
import json

from config_loader import load_config


def main() -> None:
    config = load_config()
    raw_dir = Path(config["paths"]["raw_dir"])
    raw_dir.mkdir(parents=True, exist_ok=True)

    sample_payload = [{"id": 1, "name": "Alice", "email": "ALICE@EXAMPLE.COM"}]
    output_path = raw_dir / "sample_users.json"
    output_path.write_text(json.dumps(sample_payload, indent=2), encoding="utf-8")

    print(f"Environment: {config['runtime']['environment']}")
    print(f"Raw sample written to: {output_path}")


if __name__ == "__main__":
    main()
```

Why:

- one obvious entrypoint makes the project easier to run and explain

## Step 11: Run The Project

```bash
cp .env.example .env
python src/main.py
```

Expected result:

- the script should create a sample JSON output under `data/raw/`
- the runtime environment should be printed

## Step 12: Add A Minimal README Run Section

Example:

```md
## Setup

python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env

## Run

python src/main.py
```

Why:

- the project now explains itself

## Step 13: Add One Minimal Test

Create `tests/test_processor.py`:

```python
from src.processor import normalize_user


def test_normalize_user() -> None:
    assert normalize_user(
        {"id": 1, "name": " Alice ", "email": "A@EXAMPLE.COM"}
    ) == {
        "id": 1,
        "name": "Alice",
        "email": "a@example.com",
    }
```

Run:

```bash
pytest
```

## What This Walkthrough Teaches

This small setup already teaches several production-shaped habits:

- isolate dependencies
- separate secrets from code
- separate config from code
- keep one clear entrypoint
- keep transformation logic testable
- keep data outside source code

## Common Beginner Mistakes During Setup

### Installing Packages Globally

This makes project dependencies blurry.

### Forgetting `requirements.txt`

This makes reproduction harder on another machine.

### Committing `.env`

This risks exposing secrets.

### Mixing Data Into `src/`

This makes the project harder to reason about.

## Final Takeaway

Local project setup is not secondary work.

It is the foundation that makes later ingestion, testing, and deployment work stable.