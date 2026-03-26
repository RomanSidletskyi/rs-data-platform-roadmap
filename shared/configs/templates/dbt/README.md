# dbt Shared Config Templates

This directory contains reusable dbt configuration templates shared across modules and projects.

Use these files when the same operational pattern appears in more than one dbt learning project.

Recommended contents:

- `profiles.*.example.yml` for target and credential patterns
- `dbt_project.*.example.yml` for routing and materialization patterns
- `selectors.example.yml` for workload-based selection examples
- CI/CD workflow examples for validation and deploy

Rule:

- keep these templates generic enough to reuse
- keep project-specific business context inside the module itself