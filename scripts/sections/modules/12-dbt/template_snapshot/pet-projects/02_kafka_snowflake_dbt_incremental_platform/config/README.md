# Config

Use this directory if you want to make the project more operationally explicit.

If you want reusable starting points, begin from the shared dbt templates in:

- `shared/configs/templates/dbt/dbt_project.multi_env.example.yml`
- `shared/configs/templates/dbt/selectors.example.yml`

Good additions:

- `sources.example.yml` for the raw Kafka landing table
- `dbt_project.example.yml` with incremental and warehouse defaults
- `selectors.example.yml` for frequent builds
- short notes on how dev and prod targets would differ

Keep configuration focused on how the warehouse project is run, not on Kafka infrastructure itself.
