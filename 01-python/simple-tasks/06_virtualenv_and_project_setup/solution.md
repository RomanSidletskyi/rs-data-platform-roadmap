# 06 Virtual Environment And Project Setup - Solution

This file gives reference setup shapes for small Python data projects.

The goal is not to produce the only correct answer.

The goal is to show a clean baseline that separates:

- environment
- dependencies
- config
- secrets
- entrypoint
- data folders

## Pattern 1 - Create A Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
which python
python --version
```

Why this is correct:

- packages are isolated to the project
- the active interpreter is easy to verify

## Pattern 2 - Install And Freeze Dependencies

```bash
pip install requests PyYAML python-dotenv pytest
pip freeze > requirements.txt
```

Example `requirements.txt`:

```text
requests==2.32.3
PyYAML==6.0.2
python-dotenv==1.0.1
pytest==8.3.5
```

Why this is better than global installs:

- another machine can recreate the dependency set
- the project declares what it needs

## Pattern 3 - Basic `.gitignore`

```gitignore
.venv/
__pycache__/
.env
logs/
*.log
.DS_Store
```

Important detail:

- ignore `.env`
- do not ignore `.env.example`

## Pattern 4 - Clean Project Layout

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
    test_processor.py
```

Why this layout works:

- code is separate from data
- config has a clear home
- test location is obvious
- raw and processed outputs are not mixed together

## Pattern 5 - Structured Config In YAML

Example `config/config.yaml`:

```yaml
api:
  base_url: https://jsonplaceholder.typicode.com
  timeout: 30

paths:
  raw_dir: data/raw
  processed_dir: data/processed
  quarantine_dir: data/quarantine
```

Why YAML is useful here:

- grouped structure is readable
- better fit than flat env vars for nested runtime settings

## Pattern 6 - `.env.example` For Local Secrets And Runtime Flags

Example `.env.example`:

```text
API_TOKEN=
APP_ENV=local
LOG_LEVEL=INFO
```

Why this helps:

- expected runtime values are documented
- real secrets stay out of version control

## Pattern 7 - Load Environment Variables And Config Together

```python
from pathlib import Path
import os

import yaml
from dotenv import load_dotenv


def load_config() -> dict:
    load_dotenv()

    config = yaml.safe_load(Path("config/config.yaml").read_text(encoding="utf-8"))

    return {
        "api": {
            "base_url": config["api"]["base_url"],
            "timeout": config["api"].get("timeout", 30),
            "token": os.getenv("API_TOKEN", ""),
        },
        "runtime": {
            "environment": os.getenv("APP_ENV", "local"),
            "log_level": os.getenv("LOG_LEVEL", "INFO"),
        },
        "paths": config["paths"],
    }
```

Why this pattern is good:

- config access is centralized
- the rest of the codebase does not need to read env vars directly everywhere

## Pattern 8 - A Clear Entrypoint

Example `src/main.py`:

```python
from pathlib import Path
import json

from config_loader import load_config


def main() -> None:
    config = load_config()
    raw_dir = Path(config["paths"]["raw_dir"])
    raw_dir.mkdir(parents=True, exist_ok=True)

    sample_payload = [
        {"id": 1, "name": "Alice", "email": "ALICE@EXAMPLE.COM"}
    ]

    output_path = raw_dir / "sample_users.json"
    output_path.write_text(json.dumps(sample_payload, indent=2), encoding="utf-8")

    print(f"Environment: {config['runtime']['environment']}")
    print(f"Raw file written to: {output_path}")


if __name__ == "__main__":
    main()
```

Why this is a good baseline:

- one obvious run path
- setup logic and runtime config are visible
- output location is controlled

## Pattern 9 - Minimal Testable Business Logic

Example `src/processor.py`:

```python
def normalize_user(record: dict) -> dict:
    return {
        "id": record["id"],
        "name": record["name"].strip(),
        "email": record["email"].strip().lower(),
    }
```

Example test:

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

Why include this in a setup task:

- project setup should support testable code, not only runnable code

## Pattern 10 - Basic README Run Section

```md
## Setup

python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env

## Run

python src/main.py

## Test

pytest
```

Why this matters:

- the project becomes understandable to another person

## Common Mistakes

### Global Installs Only

This makes the project harder to reproduce.

### Secrets Inside Source Code

This is both unsafe and inflexible.

### Data Mixed With Source Files

This confuses the project boundary between code and artifacts.

### No Clear Entrypoint

This makes the project harder to run and document.

## Key Point

The main lesson is that project setup is part of engineering quality, not optional cleanup work.