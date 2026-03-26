# Config

This directory should contain the most important operational examples for the project.

If you want reusable starting points, begin from the shared dbt templates in:

- `shared/configs/templates/dbt/profiles.multi_env.example.yml`
- `shared/configs/templates/dbt/dbt_project.multi_env.example.yml`
- `shared/configs/templates/dbt/selectors.example.yml`
- `shared/configs/templates/dbt/github-actions-ci.example.yml`
- `shared/configs/templates/dbt/github-actions-prod.example.yml`

Recommended files:

- `profiles.example.yml`
- `dbt_project.example.yml`
- `selectors.example.yml`
- `github-actions-ci.example.yml`
- `github-actions-prod.example.yml`

Configuration goal:

- make environment routing explicit
- keep CI and deploy behavior reviewable in plain text
