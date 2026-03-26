# Airflow Shared Config Templates

This directory contains reusable Airflow-oriented configuration templates shared across modules and projects.

Use these files when the same workflow contract or runtime pattern appears in more than one Airflow example.

Good candidates:

- API landing runtime configuration
- production-style runtime defaults
- environment-neutral workflow contracts

Rule:

- keep these templates generic enough to reuse
- keep scenario-specific values inside the module when they are required for a runnable reference example