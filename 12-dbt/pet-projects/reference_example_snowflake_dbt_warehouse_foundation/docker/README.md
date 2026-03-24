# Docker

This reference example does not require a full Docker stack.

If you want a repeatable local runner, use a small image with:

- `dbt-snowflake`
- project files mounted read-only
- environment variables for Snowflake credentials

That is enough to validate `dbt deps`, `dbt build`, and `dbt docs generate`.
