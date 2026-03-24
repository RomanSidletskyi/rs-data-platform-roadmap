# Source Code

This directory should hold the dbt project itself or helper scripts directly adjacent to it.

If you need a reusable schema-routing macro, start from:

- `shared/templates/dbt/macros/generate_schema_name.sql`

Recommended structure:

- `models/sources/` for source YAML
- `models/staging/` for source standardization
- `models/intermediate/` for reusable business logic
- `models/marts/` for dimensions and facts
- `macros/` for reusable SQL generation

If you add helper scripts, keep them secondary to the dbt models.
