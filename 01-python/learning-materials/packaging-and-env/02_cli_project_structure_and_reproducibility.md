# CLI, Project Structure, And Reproducibility

## Why This Topic Matters

Even a small data script becomes much more useful when it can be run predictably and understood quickly.

That usually requires:

- a clear entrypoint
- a stable folder structure
- repeatable run instructions
- obvious configuration boundaries

This topic matters because many beginner projects technically work, but only for the person who wrote them.

That is not yet reproducible engineering.

## The Main Goal

The learner should be able to build a project that another person can understand and run without reading the entire source code first.

That means the project should answer:

- where is the code
- where is the config
- where does the data go
- how do I run it
- what output should I expect

## 1. What A CLI Entrypoint Is

A CLI entrypoint is the main way a user runs the project from the command line.

In a small project, that might be:

- `python src/main.py`
- `python -m src.main`
- a `typer` command like `python src/cli.py run --input ...`

The key idea is that the project has one obvious place where execution starts.

## 2. Why One Clear Entrypoint Matters

Without a clear entrypoint, several problems appear:

- users do not know which file to run
- each run requires code edits instead of parameters
- debugging becomes inconsistent
- documentation becomes vague

One clear entrypoint makes the project easier to explain and harder to misuse.

## 3. Start Simple: `main.py`

For module 1, a simple `main.py` is still a good default.

Example:

```python
def main() -> None:
		print("Run the pipeline here")


if __name__ == "__main__":
		main()
```

This is useful because it gives the project one visible execution path.

## 4. When A CLI Library Helps

As soon as the project needs multiple inputs or runtime options, a CLI library becomes helpful.

For this roadmap, `typer` is a strong next step.

Good for:

- input paths
- output paths
- environment selection
- run mode flags

Example:

```python
import typer


app = typer.Typer()


@app.command()
def run(config_path: str = "config/config.yaml") -> None:
		print(f"Running with config: {config_path}")


if __name__ == "__main__":
		app()
```

## 5. Project Structure: Why It Matters

Project structure is not cosmetic.

It helps define boundaries between responsibilities.

At minimum, a learner should be able to separate:

- source code
- config
- data
- tests
- documentation or run instructions

## 6. A Weak Project Shape

Weak shape:

```text
project/
	script.py
	users.csv
	users_clean.csv
	config values hardcoded in script.py
	random notes.txt
```

Why weak:

- no separation of concerns
- data mixed with source
- config hidden in code
- hard to understand what is input versus output

## 7. A Better Project Shape

```text
project/
	requirements.txt
	.env.example
	README.md
	config/
		config.yaml
	src/
		main.py
		config_loader.py
		api_client.py
		processor.py
		writer.py
	tests/
		test_processor.py
	data/
		raw/
		processed/
		quarantine/
```

Why better:

- entrypoint is visible
- config has a known location
- data flow is easier to reason about
- tests have a natural place

## 8. Separate Inputs And Outputs

This is one of the simplest but most important habits.

Good pattern:

- raw inputs in `data/raw/`
- cleaned outputs in `data/processed/`
- invalid records in `data/quarantine/`

Why useful:

- easier debugging
- cleaner reruns
- more obvious contracts

## 9. Reproducibility: What It Really Means

Reproducibility does not mean “it worked once on my laptop.”

It means another person should be able to reproduce the same intended run with the same project setup.

For module 1, that usually means:

- same dependency versions
- same config structure
- same expected command
- same output locations

## 10. The Simplest Reproducible Run Story

A small project should ideally support a run story like this:

1. create and activate `venv`
2. install dependencies from `requirements.txt`
3. copy `.env.example` to `.env`
4. fill in required env vars
5. run one documented command

If the project cannot explain itself at this level, it is not yet reproducible enough.

## 11. Example README Run Section

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python src/main.py
```

This is basic, but already much better than undocumented magic steps.

## 12. Why Manual Code Editing Is A Smell

If every run requires changing constants in source code, the project is sending a signal that boundaries are weak.

Example of weak pattern:

```python
INPUT_PATH = "orders_2026_03_01.csv"
OUTPUT_PATH = "orders_clean.csv"
```

This should usually move to:

- CLI arguments
- config file
- environment variables when appropriate

## 13. Reproducibility Is Also About Output Determinism

Predictable projects also write outputs in a predictable way.

Good examples:

- same input partition produces same target path
- run summaries are written consistently
- file names include clear timestamps when needed

This helps with:

- reruns
- debugging
- handoff to downstream tools

## 14. Project Structure And Testing

Project structure affects testing directly.

If the codebase is organized, then tests become easier to write and find.

Example:

- `src/processor.py`
- `tests/test_processor.py`

This may look small, but it teaches a habit that scales well.

## 15. When To Upgrade From `main.py` To A Richer CLI

Move beyond a single `main.py` when:

- the project has multiple commands
- local run options are increasing
- users need discoverable help text
- different run modes should be explicit

At that point, a CLI library like `typer` is usually justified.

## 16. A Small Reproducible Data Project Example

Imagine a project that ingests users from an API.

Good reproducible shape:

- `src/main.py` coordinates the run
- `config/config.yaml` stores paths and API settings
- `.env` stores `API_TOKEN`
- `requirements.txt` lists dependencies
- `README.md` explains setup and run command
- outputs land in `data/raw/`, `data/processed/`, and `data/quarantine/`

This is already enough to feel like a real project, not a disposable script.

## 17. Common Beginner Mistakes

### Multiple Entrypoints With No Clear Rule

If the project has many runnable files and no obvious main path, users get confused.

### Data Mixed Into Source Folders

This makes cleanup and debugging harder.

### No Run Instructions

If the project only works when the author remembers invisible setup steps, the project is not reproducible.

### Outputs Written To Random Paths

This breaks trust in the run process.

## 18. What To Practice First If This Topic Feels Weak

Practice in this order:

1. create one project with `src/`, `config/`, and `data/`
2. add one `main.py` entrypoint
3. move hardcoded values out of source code
4. add `requirements.txt`
5. write one short setup-and-run section in `README.md`

That is enough to build a real foundation.

## Key Architectural Takeaway

Reproducibility is part of basic engineering quality.

A Python project becomes credible when its code, entrypoint, config, and run instructions are all intentional and easy to follow.