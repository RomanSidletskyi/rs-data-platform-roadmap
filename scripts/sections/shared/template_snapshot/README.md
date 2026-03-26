# Shared Resources

The `shared/` directory contains reusable resources used across multiple modules of this repository.

Its purpose is to avoid duplication and provide a central place for datasets, schemas, infrastructure templates, scripts, and other reusable assets.

---

# Core Rule

If something is reused across multiple modules, it belongs in `shared/`.

If something is used only inside one module, it should remain inside that module.

---

# Structure Overview

    shared/
    ├─ datasets/
    ├─ schemas/
    ├─ databases/
    ├─ docker/
    ├─ environments/
    ├─ configs/
    ├─ scripts/
    ├─ notebooks/
    ├─ testing/
    ├─ architecture/
    └─ templates/

Each directory serves a specific purpose described below.

---

# datasets

Reusable datasets used across exercises, tasks, and projects.

    datasets/
    ├─ raw/
    ├─ sample/
    ├─ processed/
    └─ generated/

raw  
Original datasets before processing.

Examples:

- CSV exports
- JSON event logs
- Parquet source files

sample  
Small datasets safe to store in the repository.

Used for:

- exercises
- demos
- quick experiments

processed  
Datasets produced after processing pipelines.

generated  
Synthetic datasets created by scripts.

Examples:

- fake orders
- generated clickstream events
- synthetic IoT data

---

# schemas

Reusable schema definitions.

    schemas/
    ├─ sql/
    ├─ json/
    ├─ avro/
    └─ protobuf/

Examples include:

- SQL table schemas
- JSON validation schemas
- Avro schemas for streaming events
- Protobuf definitions for messaging systems

---

# databases

Reusable assets related to database systems.

The repository should not store running database instances.

Instead it may contain:

- schema definitions
- initialization scripts
- docker configurations
- seed data
- small dumps

---

# mysql

    databases/mysql/
    ├─ docker/
    ├─ init/
    ├─ schema/
    ├─ seed/
    └─ dumps/

Use for:

- schema definitions
- initialization scripts
- local development environments

---

# mongodb

    databases/mongodb/
    ├─ docker/
    ├─ init/
    ├─ collections/
    ├─ seed/
    └─ dumps/

Use for:

- collection definitions
- seed documents
- local development setups

---

# docker

Reusable Docker configurations.

    docker/
    ├─ compose/
    └─ local-stacks/

Examples:

- Spark environments
- Kafka clusters
- development databases

---

# environments

Environment configuration for tools.

    environments/
    ├─ git-hygiene.md
    ├─ local-env-files-workflow.md
    ├─ local-shell-env-loading-examples.md
    ├─ secrets-management.md
    ├─ use-github-env.md
    ├─ use-postgres-env.md
    ├─ who-reads-what.md
    ├─ python/
    ├─ raspberry-pi/
    ├─ spark/
    ├─ dbt/
    └─ airflow/

Examples:

- Python requirements
- Spark configuration
- tool setup documentation
- remote homelab and Docker host setup
- shared rules for local and runtime secrets
- shared rules for keeping git clean
- workflow for reading and editing local env files
- concrete examples of loading env files into a shell
- concrete example for GitHub env usage
- concrete example for Postgres env usage
- overview of which process reads which config source

---

# configs

Reusable configuration templates.

    configs/
    ├─ local/
    ├─ dev/
    └─ templates/

dbt-specific shared templates should live under:

    configs/templates/dbt/

airflow-specific shared templates should live under:

    configs/templates/airflow/

Recommended contents:

- `profiles.*.example.yml`
- `dbt_project.*.example.yml`
- `selectors.example.yml`
- CI/CD workflow examples
- Airflow runtime config examples
- API landing contract examples

Examples:

- application configs
- environment configs
- connection templates

---

# scripts

Reusable utility scripts.

    scripts/
    ├─ setup/
    ├─ data-generation/
    ├─ validation/
    └─ helpers/

dbt helper utilities should live under:

    scripts/helpers/dbt/

Examples:

- render profile hints
- summarize dbt artifacts
- small operational wrappers

Examples:

- dataset generation
- environment setup
- validation tools

---

# notebooks

Exploratory and demo notebooks.

    notebooks/
    ├─ exploratory/
    └─ demos/

Used for experimentation and demonstrations.

---

# testing

Shared testing resources.

    testing/
    ├─ mock-data/
    ├─ fixtures/
    └─ expected-outputs/

Examples:

- mock datasets
- expected pipeline outputs
- testing fixtures

Airflow-oriented shared testing assets may live under:

    testing/mock-data/airflow/
    testing/expected-outputs/airflow/

Use these for:

- reusable API payload examples
- expected publish marker contracts
- small validation fixtures used by more than one workflow example

---

# architecture

Architecture references and diagrams.

    architecture/
    ├─ diagrams/
    ├─ patterns/
    └─ reference-flows/

Examples:

- data platform architecture
- pipeline patterns
- system design references

---

# templates

Templates used for consistent repository structure.

    templates/
    ├─ module-template/
    ├─ project-template/
    ├─ README-template/
    └─ dbt/

dbt reusable code templates should live under:

    templates/dbt/
    └─ macros/

These templates help maintain consistent structure when creating new modules or projects.

---

# Safe Mode Rules

To keep the repository stable:

Do NOT commit:

- large datasets
- production database dumps
- credentials
- secrets
- real .env files

Instead use:

- sample datasets
- generation scripts
- documentation
