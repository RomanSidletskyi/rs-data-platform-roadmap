# Real Projects

This directory is the portfolio layer of the repository.

Unlike module pet projects, these projects are meant to combine multiple technologies into one coherent implementation.

## Purpose

Use `real-projects/` to practice:

- cross-technology integration
- architecture trade-offs
- project structure beyond one isolated tool
- validation, delivery, and operating concerns closer to real platform work

## Current Project Path

1. `01_python_sql_etl`
2. `02_python_docker_github_actions`
3. `03_python_kafka`
4. `04_python_kafka_databricks`
5. `05_python_spark_delta`
6. `06_databricks_adls_powerbi`
7. `07_kafka_databricks_powerbi`
8. `08_end_to_end_data_platform`

Each project directory now starts with its own brief README:

- `01_python_sql_etl/README.md`
- `02_python_docker_github_actions/README.md`
- `03_python_kafka/README.md`
- `04_python_kafka_databricks/README.md`
- `05_python_spark_delta/README.md`
- `06_databricks_adls_powerbi/README.md`
- `07_kafka_databricks_powerbi/README.md`
- `08_end_to_end_data_platform/README.md`

Each project directory also contains starter architecture notes:

- `01_python_sql_etl/architecture-notes.md`
- `02_python_docker_github_actions/architecture-notes.md`
- `03_python_kafka/architecture-notes.md`
- `04_python_kafka_databricks/architecture-notes.md`
- `05_python_spark_delta/architecture-notes.md`
- `06_databricks_adls_powerbi/architecture-notes.md`
- `07_kafka_databricks_powerbi/architecture-notes.md`
- `08_end_to_end_data_platform/architecture-notes.md`

Each project directory also contains a starter ADR document:

- `01_python_sql_etl/adr.md`
- `02_python_docker_github_actions/adr.md`
- `03_python_kafka/adr.md`
- `04_python_kafka_databricks/adr.md`
- `05_python_spark_delta/adr.md`
- `06_databricks_adls_powerbi/adr.md`
- `07_kafka_databricks_powerbi/adr.md`
- `08_end_to_end_data_platform/adr.md`

Each project directory also contains a starter implementation plan:

- `01_python_sql_etl/implementation-plan.md`
- `02_python_docker_github_actions/implementation-plan.md`
- `03_python_kafka/implementation-plan.md`
- `04_python_kafka_databricks/implementation-plan.md`
- `05_python_spark_delta/implementation-plan.md`
- `06_databricks_adls_powerbi/implementation-plan.md`
- `07_kafka_databricks_powerbi/implementation-plan.md`
- `08_end_to_end_data_platform/implementation-plan.md`

These projects are intentionally sequential.

The earlier ones teach integration across two or three layers.

The later ones force full platform thinking.

## How Real Projects Differ From Pet Projects

Pet projects inside modules are guided practice inside one technology boundary.

Real projects should:

- combine several modules
- make architecture visible
- require clearer interfaces and project structure
- include stronger execution and validation decisions

## Recommended Standard For Each Real Project

Each real project should eventually contain:

- a project `README.md`
- architecture notes
- implementation code
- local run instructions
- validation or test instructions
- sample data or fixtures where relevant
- explicit scope and non-goals

## Planning Reference

Use [docs/data-platform-projects-roadmap.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/docs/data-platform-projects-roadmap.md) as the planning layer for this directory.

## Architecture Review Route

Use the architecture review layer to think about each real project before or during implementation:

1. read [docs/architecture/reviews/real-project-review-exercises.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/docs/architecture/reviews/real-project-review-exercises.md)
2. open the project's own `README.md`
3. review the starter `architecture-notes.md`
4. answer the review question for that project using the closest checklist from [docs/architecture/reviews/README.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/docs/architecture/reviews/README.md)
5. compare your answer with [docs/architecture/reviews/real-project-reviewer-notes.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/docs/architecture/reviews/real-project-reviewer-notes.md)
6. turn the result into an ADR using [docs/architecture/adr/template.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/docs/architecture/adr/template.md)

## Suggested Review Pairings

- `01_python_sql_etl` -> batch pipeline review
- `02_python_docker_github_actions` -> system-shape review
- `03_python_kafka` -> streaming platform review
- `04_python_kafka_databricks` -> system-shape review
- `05_python_spark_delta` -> lakehouse and serving review
- `06_databricks_adls_powerbi` -> lakehouse and serving review
- `07_kafka_databricks_powerbi` -> streaming plus hybrid architecture review
- `08_end_to_end_data_platform` -> full system-shape review
