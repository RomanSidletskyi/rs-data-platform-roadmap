# Environments, Dependencies, And Config

## Why This Topic Matters

Many Python problems that look like code issues are actually environment issues.

Examples:

- wrong package version
- missing dependency
- code works on one machine but not another
- API token is hardcoded in source code
- config is scattered across many files

This topic is especially important because beginners often underestimate it.

They think the hard part is only the logic.

In practice, many fragile Python projects fail because code, dependencies, secrets, and runtime configuration are mixed together.

## The Main Goal

The goal of this block is simple:

- make the project runnable on purpose, not by accident

That means the learner should understand how to separate:

- code
- dependencies
- environment-specific values
- project configuration

## 1. Environment: What It Really Means

In Python, the environment is not only the operating system.

For this module, think of the runtime environment as the combination of:

- Python version
- installed packages
- environment variables
- filesystem paths
- local config files

When these pieces are unclear, the project becomes hard to reproduce.

## 2. Why Virtual Environments Matter

If packages are installed globally, several problems appear:

- different projects interfere with each other
- one project upgrades a package and breaks another
- the learner cannot tell which dependency actually belongs to the current project

That is why virtual environments matter.

They isolate one project's Python packages from the rest of the machine.

## 3. Start With `venv`

For this module, built-in `venv` is the correct baseline.

Why:

- no extra dependency is needed
- it teaches environment isolation clearly
- it is enough for small and medium learning projects

### Example Workflow

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install requests pyyaml pytest
```

### What This Does

- creates an isolated environment in `.venv/`
- activates it in the shell
- upgrades `pip`
- installs only the packages this project needs

## 4. Dependencies: What Should Be Explicit

If a package is needed to run the project, that dependency should be visible.

In this module, the simplest correct baseline is usually:

- `requirements.txt`

Example:

```text
requests==2.32.3
PyYAML==6.0.2
python-dotenv==1.0.1
pytest==8.3.5
```

This file helps answer a basic question:

- what does this project need in order to run

## 5. Why Pinning Versions Matters

If dependencies are not versioned, the same project may behave differently over time.

Examples:

- one machine installs a newer package with breaking behavior
- a CI run pulls a different version than local development

Pinning versions is not about perfection.

It is about reducing accidental drift.

## 6. What Should Go Into Environment Variables

Environment variables are good for values that change between environments or should not be hardcoded.

Good candidates:

- API tokens
- passwords
- hostnames
- deployment-specific flags
- cloud credentials

Bad candidates:

- long nested business configuration
- complex transformation rules
- large schema definitions

## 7. What Should Go Into Config Files

Config files are useful when the project has structured settings that should be readable and grouped.

Good candidates:

- source endpoints
- timeouts
- batch sizes
- input and output paths
- allowed file patterns
- validation thresholds

This is where YAML often becomes helpful.

## 8. Environment Variables Vs Config Files

This distinction is worth learning early.

Use environment variables for:

- secrets
- deployment-specific values
- machine-specific overrides

Use config files for:

- structured runtime configuration
- grouped pipeline settings
- project-level defaults that should be readable in one place

Simple rule:

- secret or deployment-specific: env var
- structured project configuration: config file

## 9. `python-dotenv` For Local Development

`python-dotenv` is useful because local development often needs a convenient way to load environment variables.

Worth using when:

- local `.env` files help onboarding
- secrets should stay out of source code
- the project should read environment variables the same way every time

Example:

```python
from dotenv import load_dotenv
import os


load_dotenv()
token = os.environ["API_TOKEN"]
environment = os.environ.get("APP_ENV", "local")
```

### Example `.env`

```text
API_TOKEN=super-secret-token
APP_ENV=local
```

Important note:

- `.env` files are for local convenience
- they should not be committed with real secrets

## 10. `PyYAML` For Structured Config

`PyYAML` is useful when config starts outgrowing flat env vars.

Worth using when:

- config has nested structure
- multiple paths, endpoints, or runtime options must be grouped clearly
- the learner wants one readable config file instead of many hardcoded values

Example config file:

```yaml
api:
	base_url: https://api.example.com
	timeout: 30
	page_size: 100

paths:
	raw_dir: data/raw
	processed_dir: data/processed
	quarantine_dir: data/quarantine
```

Example Python loader:

```python
import yaml
from pathlib import Path


config = yaml.safe_load(Path("config/config.yaml").read_text(encoding="utf-8"))
base_url = config["api"]["base_url"]
raw_dir = config["paths"]["raw_dir"]
```

## 11. A Good Config Boundary

One useful pattern is:

- keep secrets in environment variables
- keep structured settings in YAML
- load both near the start of the program
- pass resolved values into the rest of the project

Example:

```python
from dotenv import load_dotenv
from pathlib import Path
import os
import yaml


def load_runtime_config() -> dict:
		load_dotenv()

		config = yaml.safe_load(Path("config/config.yaml").read_text(encoding="utf-8"))
		config["api"]["token"] = os.environ["API_TOKEN"]
		return config
```

This is cleaner than mixing `os.environ[...]` calls everywhere in the project.

## 12. Bad Patterns To Avoid

### Hardcoded Secrets

```python
API_TOKEN = "abc123"
```

Why bad:

- insecure
- hard to rotate
- wrong separation of concerns

### Hardcoded Machine Paths

```python
INPUT_PATH = "/Users/name/Desktop/orders.csv"
```

Why bad:

- breaks on another machine immediately

### Hidden Dependencies

If the code imports packages that are not listed in the project dependency file, the project only works by accident.

### Reading Env Vars Everywhere

If every module reaches into `os.environ` directly, config becomes harder to understand and test.

## 13. A Small Practical Setup

For a small learning project, a clean setup often looks like this:

```text
project/
	.env.example
	requirements.txt
	config/
		config.yaml
	src/
		main.py
		config_loader.py
		api_client.py
		processor.py
	data/
		raw/
		processed/
		quarantine/
```

### Why This Structure Helps

- dependencies are explicit
- local env variables have a known place
- structured config has a known place
- code that loads config is separated from transformation logic

## 14. What `.env.example` Should Do

It should show what variables the project expects without exposing real secrets.

Example:

```text
API_TOKEN=
APP_ENV=local
```

This improves onboarding because another person can see what they need to set.

## 15. A Minimal Config Loader Example

```python
from pathlib import Path
import os

import yaml
from dotenv import load_dotenv


def load_config() -> dict:
		load_dotenv()

		config_path = Path("config/config.yaml")
		config = yaml.safe_load(config_path.read_text(encoding="utf-8"))

		return {
				"api": {
						"base_url": config["api"]["base_url"],
						"timeout": config["api"].get("timeout", 30),
						"token": os.environ["API_TOKEN"],
				},
				"paths": config["paths"],
		}
```

This pattern is good because the rest of the project can receive one resolved config object instead of mixing file reads and env reads everywhere.

## 16. Connection To Reproducibility

Environment and config work are part of reproducibility.

If someone clones the repository, they should be able to answer:

- which Python version is expected
- which packages must be installed
- which environment variables are required
- where runtime configuration lives

If these answers are unclear, the project is not yet operationally healthy.

## 17. What To Learn First If This Topic Feels Weak

If the learner feels weak here, the correct order is:

1. understand what a virtual environment isolates
2. practice creating and activating `venv`
3. learn what belongs in `requirements.txt`
4. learn the difference between `.env` and `config.yaml`
5. centralize config loading in one small module

That sequence is enough to become dangerous in a good way.

## Key Architectural Takeaway

Python projects become reliable only when code, config, dependencies, and secrets are separated intentionally.