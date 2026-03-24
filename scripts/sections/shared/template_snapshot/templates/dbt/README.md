# dbt Shared Templates

This directory contains reusable dbt code templates that are more like project building blocks than plain config.

Use this location for things such as:

- reusable macros
- starter SQL patterns
- shared project scaffolding fragments

Rule:

- if the file is pure config, prefer `shared/configs/templates/dbt/`
- if the file is reusable dbt code, prefer `shared/templates/dbt/`