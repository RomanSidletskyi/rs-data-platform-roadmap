# Docker

Docker is optional here, but this folder can hold a small local runner setup if you want a repeatable dbt execution environment.

Good candidates:

- a lightweight `Dockerfile` with `dbt-snowflake`
- a shell wrapper for `dbt deps`, `dbt build`, and `dbt docs serve`
- environment templates for local execution against a dev target

The goal is reproducible execution, not a heavy platform stack.
