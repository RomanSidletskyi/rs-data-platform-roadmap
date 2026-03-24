# Architecture - Reference Example dbt CI/CD Multi-Environment Platform

## Components

- Snowflake environments for dev, qa, and prod
- dbt configuration layer with target-specific routing
- GitHub Actions workflows for validation and deploy
- selectors for workload-based job scheduling
- helper scripts for profile rendering and artifact summaries

## Flow

1. developers work in isolated schema space
2. pull requests trigger CI validation in QA
3. CI builds only the intended graph slice and runs tests
4. merge to main triggers a production deploy flow
5. engineers inspect logs and artifacts after execution

## Key Decisions

- clean production schemas, prefixed dev and qa schemas
- warehouse routing by workload type rather than one shared default everywhere
- workflow configuration stored alongside the project for reviewability
- helper scripts kept small and operationally focused
