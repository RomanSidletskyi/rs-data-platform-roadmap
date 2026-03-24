# Config

Use this directory for the minimum configuration a clean warehouse dbt project should expose.

If you want a reusable starting point, begin from the shared dbt templates in:

- `shared/configs/templates/dbt/profiles.warehouse_foundation.example.yml`
- `shared/configs/templates/dbt/dbt_project.warehouse_foundation.example.yml`

Recommended files:

- `profiles.example.yml` for local and CI targets
- `dbt_project.example.yml` for model routing and materialization defaults
- `sources.example.yml` for raw table ownership and freshness patterns
- `packages.yml` if you decide to use shared dbt packages

Configuration goal:

- keep routing decisions separate from model SQL
- make schema and warehouse behavior easy to explain
