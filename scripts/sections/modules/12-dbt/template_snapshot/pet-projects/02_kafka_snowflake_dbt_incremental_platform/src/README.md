# Source Code

This directory should hold the dbt project or helper code directly adjacent to it.

If you need a reusable schema-routing macro, start from:

- `shared/templates/dbt/macros/generate_schema_name.sql`

Recommended focus:

- staging models that parse VARIANT payloads
- intermediate models for deduplication or latest-state logic
- marts for event analytics or current-state reporting
- optional helper scripts only if they support repeated local validation

Keep Kafka consumption itself outside this directory unless you are clearly simulating landing behavior for learning purposes.
