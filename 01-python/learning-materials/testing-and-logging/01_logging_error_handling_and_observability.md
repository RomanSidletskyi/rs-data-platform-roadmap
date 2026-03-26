# Logging, Error Handling, And Observability

## Why This Topic Matters

If a Python data script fails silently or logs nothing useful, it is operationally weak even if the transformation logic is correct.

## Logging Should Answer

- what started
- what input was processed
- how many records were handled
- where output was written
- what failed and why

## Good Strategy

- log stage boundaries
- log counts and output paths
- raise errors intentionally when contracts fail
- keep failure messages specific

## Bad Strategy

- rely only on `print`
- swallow exceptions and continue blindly

## Why Bad Is Bad

- incident analysis is slow
- bad outputs may be trusted accidentally
- reruns may happen without understanding the previous failure

## Libraries Worth Knowing Here

### Start With `logging`

The built-in `logging` module should be the baseline.

Why:

- it is already enough for most early pipeline logging
- it teaches levels, handlers, and message structure without extra dependencies

Example:

```python
import logging


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
logger.info("Starting run")
```

### Add `structlog` Later If Structured Logging Becomes Important

Worth using when:

- the team wants structured logs
- logs are consumed by centralized observability systems

Why useful:

- easier machine-readable logging
- clearer enrichment with fields like `run_id` and `source`

## Cookbook Example

```python
logger.info("Starting pipeline run for %s", input_path)
logger.info("Loaded %s records", len(records))
logger.info("Writing processed output to %s", output_path)
```

## Key Architectural Takeaway

Observability starts at module 1.