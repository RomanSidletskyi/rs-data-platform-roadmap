# Virtual Environment And Project Setup

This section introduces clean Python project setup as a practical engineering skill, not just a one-time setup chore.

The goal is to make the learner comfortable with:

- isolated environments
- explicit dependencies
- `.gitignore`
- `.env` and `.env.example`
- structured config
- a clean folder layout
- one clear entrypoint
- basic reproducibility

## What You Are Building

By the end of these tasks, you should be able to shape a small Python data project like this:

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

## Task 1 — Create A Virtual Environment

### Goal

Prepare an isolated Python environment.

### Input

Use the current project folder.

### Requirements

- create `.venv`
- activate it
- verify installed packages are local to the environment
- confirm `python` points inside `.venv`

### Expected Output

A working local virtual environment.

### Suggested Commands

```bash
python3 -m venv .venv
source .venv/bin/activate
which python
python --version
```

### Extra Challenge

- document activation steps for different shells
- add `.venv` to `.gitignore`

## Task 2 — Create `requirements.txt`

### Goal

Track dependencies properly.

### Input

Install at least:

- `requests`
- `PyYAML`
- `python-dotenv`

### Requirements

- install packages in the virtual environment
- export them to `requirements.txt`
- keep versions visible
- document installation steps

### Expected Output

A `requirements.txt` file with project dependencies.

### Suggested Commands

```bash
pip install requests PyYAML python-dotenv
pip freeze > requirements.txt
```

### Extra Challenge

- explain in README why each dependency exists
- add `pytest` as a development dependency for practice

## Task 3 — Add `.gitignore`

### Goal

Keep repository clean.

### Input

A Python project with:

- `.venv`
- `__pycache__`
- `.env`
- log files

### Requirements

- ignore `.venv`
- ignore cache files
- ignore local secrets
- ignore temporary outputs when appropriate

### Expected Output

A clean `.gitignore` file.

### Example Baseline

```gitignore
.venv/
__pycache__/
.env
*.log
.DS_Store
```

### Extra Challenge

- add ignores for notebook checkpoints
- explain why `.env` is ignored but `.env.example` is not

## Task 4 — Organize A Small Project

### Goal

Use a cleaner folder structure.

### Input

A single-file script.

### Requirements

- create `src/`, `data/`, `tests/`, and `config/`
- move logic into `src/`
- keep data files outside source code
- create `raw/`, `processed/`, and `quarantine/` under `data/`

### Expected Output

A project with a cleaner engineering-friendly layout.

### Extra Challenge

- add `logs/`
- split one script into `main.py`, `processor.py`, and `config_loader.py`

## Task 5 — Move Hardcoded Values Into Config

### Goal

Improve flexibility.

### Input

A script with hardcoded:

- file paths
- API URL
- timeout value

### Requirements

- remove hardcoded paths or URLs from business logic
- store structured runtime values in config
- load them in the script through one config-loading step

### Expected Output

Config-driven values used by the script.

### Suggested Format

Use `config/config.yaml`:

```yaml
api:
	base_url: https://jsonplaceholder.typicode.com
	timeout: 30

paths:
	raw_dir: data/raw
	processed_dir: data/processed
```

### Extra Challenge

- validate required config keys on startup
- allow environment variables to override selected config values

## Task 6 — Add Environment Variables

### Goal

Prepare for secrets and environment-specific settings.

### Input

Variables such as:

- `APP_ENV=dev`
- `API_TOKEN=sample_token`
- `LOG_LEVEL=INFO`

### Requirements

- create `.env.example`
- load values from `.env`
- document required environment values
- keep real secrets out of source control

### Expected Output

A script that loads environment-based settings.

### Example `.env.example`

```text
APP_ENV=dev
API_TOKEN=
LOG_LEVEL=INFO
```

### Extra Challenge

- fail early if required variables are missing
- combine YAML config with environment-based overrides

## Task 7 — Add Setup Instructions To README

### Goal

Make the project easy to run.

### Input

Any small Python project.

### Requirements

- describe environment creation
- describe dependency installation
- describe env setup
- describe how to run the script

### Expected Output

A clear README setup section.

### Suggested Run Story

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python src/main.py
```

### Extra Challenge

- add troubleshooting notes
- add expected output paths

## Task 8 — Create A CLI Entry Script

### Goal

Make project execution clearer.

### Input

Any project with multiple helper modules.

### Requirements

- create `main.py`
- run the project from one entry point
- keep orchestration in the entry script
- avoid putting all business logic there

### Expected Output

A single script that starts the application.

### Extra Challenge

- add `--config` or `--input` arguments
- validate CLI parameters before execution

## What Good Completion Looks Like

You should finish this block with a project that:

- uses `.venv`
- has explicit dependencies
- has one visible run command
- does not hardcode secrets
- has a clean folder structure
- separates config from logic

That is already a real engineering upgrade from a throwaway script.
