# Virtual Environment and Project Setup

This section introduces clean Python project setup.

---

## Task 1 — Create a Virtual Environment

### Goal
Prepare an isolated Python environment.

### Input

Use the current project folder.

### Requirements

- create `.venv`
- activate it
- verify installed packages are local to the environment

### Expected Output

A working local virtual environment.

### Extra Challenge

- document activation steps for different shells
- add `.venv` to `.gitignore`

---

## Task 2 — Create `requirements.txt`

### Goal
Track dependencies properly.

### Input

Install at least:

- requests
- pyyaml

### Requirements

- install packages
- export them to `requirements.txt`
- document installation steps

### Expected Output

A `requirements.txt` file with project dependencies.

### Extra Challenge

- pin package versions
- add comments in README explaining each dependency

---

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
- ignore local secrets and temporary outputs

### Expected Output

A clean `.gitignore` file.

### Extra Challenge

- add ignores for OS-specific files
- add ignores for notebook checkpoints

---

## Task 4 — Organize a Small Project

### Goal
Use a cleaner folder structure.

### Input

A single-file script.

### Requirements

- create `src/`, `data/`, and `tests/`
- move logic into `src/`
- keep data files outside source code

### Expected Output

A project with a cleaner engineering-friendly layout.

### Extra Challenge

- add `config/` and `logs/` folders
- split one script into multiple modules

---

## Task 5 — Move Hardcoded Values Into Config

### Goal
Improve flexibility.

### Input

A script with hardcoded:
- file paths
- API URL
- timeout value

### Requirements

- remove hardcoded paths or URLs
- store them in config
- load them in the script

### Expected Output

Config-driven values used by the script.

### Extra Challenge

- support both YAML and JSON config
- validate config keys on startup

---

## Task 6 — Add Environment Variables

### Goal
Prepare for secrets and environment-specific settings.

### Input

Variables such as:

- ENV=dev
- API_TOKEN=sample_token
- LOG_LEVEL=INFO

### Requirements

- create `.env.example`
- read variables from `.env`
- document required environment values

### Expected Output

A script that loads environment-based settings.

### Extra Challenge

- use environment variables to override config values
- fail early if required variables are missing

---

## Task 7 — Add Setup Instructions to README

### Goal
Make the project easy to run.

### Input

Any small Python project.

### Requirements

- describe environment creation
- describe dependency installation
- describe how to run the script

### Expected Output

A clear README setup section.

### Extra Challenge

- add troubleshooting notes
- add example command output

---

## Task 8 — Create a CLI Entry Script

### Goal
Make project execution clearer.

### Input

Any project with multiple helper modules.

### Requirements

- create `main.py`
- run the project from one entry point
- pass simple arguments if possible

### Expected Output

A single script that starts the application.

### Extra Challenge

- add `--input` and `--output` arguments
- validate CLI parameters before execution
