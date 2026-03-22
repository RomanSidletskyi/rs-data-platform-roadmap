#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="shared-fill-readmes"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/shared"

log "Creating shared README..."

cat <<'EOF' > "$SECTION_ROOT/README.md"
# Shared Resources

The `shared/` directory contains reusable resources used across multiple modules of this repository.

Its purpose is to avoid duplication and provide a central place for datasets, schemas, infrastructure templates, scripts, and other reusable assets.

---

# Why `shared/` exists

As the repository grows, multiple modules may need the same resources:

- datasets
- schemas
- docker environments
- configuration templates
- helper scripts
- sample database seeds
- architecture references

Without a shared area, the same files would be copied into multiple modules, which creates duplication, inconsistency, and maintenance overhead.

The `shared/` directory solves this by acting as a central library of reusable assets.

---

# Core Rule

Use `shared/` for anything reused across two or more modules.

If a resource is used only inside one module, keep it inside that module.

Simple rule:

- used by one module -> keep it inside the module
- used by multiple modules -> place it in `shared/`

---

# How to use `shared/`

Modules should reference resources from `shared/` whenever possible.

Examples:

- a SQL module and a Spark module may use the same dataset
- a Kafka module and a Flink module may use the same Avro schema
- several modules may use the same Docker Compose stack
- multiple projects may use the same config templates

The goal is not to move everything into `shared/`, but to keep only reusable assets there.

---

# Structure Overview

    shared/
    ├─ README.md
    ├─ datasets/
    │  ├─ raw/
    │  │  ├─ csv/
    │  │  ├─ json/
    │  │  └─ parquet/
    │  ├─ sample/
    │  │  ├─ csv/
    │  │  ├─ json/
    │  │  └─ parquet/
    │  ├─ processed/
    │  │  └─ parquet/
    │  └─ generated/
    │     └─ parquet/
    ├─ schemas/
    │  ├─ sql/
    │  ├─ json/
    │  ├─ avro/
    │  └─ protobuf/
    ├─ databases/
    │  ├─ mysql/
    │  │  ├─ README.md
    │  │  ├─ docker/
    │  │  ├─ init/
    │  │  ├─ schema/
    │  │  ├─ seed/
    │  │  └─ dumps/
    │  └─ mongodb/
    │     ├─ README.md
    │     ├─ docker/
    │     ├─ init/
    │     ├─ collections/
    │     ├─ seed/
    │     └─ dumps/
    ├─ docker/
    │  ├─ compose/
    │  └─ local-stacks/
    ├─ environments/
    │  ├─ python/
    │  ├─ spark/
    │  ├─ dbt/
    │  └─ airflow/
    ├─ configs/
    │  ├─ local/
    │  ├─ dev/
    │  └─ templates/
    ├─ scripts/
    │  ├─ setup/
    │  ├─ data-generation/
    │  ├─ validation/
    │  └─ helpers/
    ├─ notebooks/
    │  ├─ exploratory/
    │  └─ demos/
    ├─ testing/
    │  ├─ mock-data/
    │  ├─ fixtures/
    │  └─ expected-outputs/
    ├─ architecture/
    │  ├─ diagrams/
    │  ├─ patterns/
    │  └─ reference-flows/
    └─ templates/
       ├─ module-template/
       ├─ project-template/
       └─ README-template/

---

# What goes where

## datasets

Reusable datasets used across exercises, tasks, and projects.

    datasets/
    ├─ raw/
    ├─ sample/
    ├─ processed/
    └─ generated/

### raw

Original source data before transformations.

Use this for:

- raw CSV files
- raw JSON exports
- original Parquet inputs

### sample

Small and lightweight datasets used for:

- exercises
- demos
- quick experiments
- repository-safe examples

This is the best place for training-friendly data that should stay in Git.

### processed

Datasets produced after processing steps.

Use this for:

- transformed Parquet files
- aggregated outputs
- cleaned datasets
- curated examples

### generated

Synthetic or automatically generated data.

Use this for:

- fake orders
- generated clickstream events
- synthetic IoT data
- test data produced by scripts

---

## schemas

Reusable schema definitions shared across systems.

    schemas/
    ├─ sql/
    ├─ json/
    ├─ avro/
    └─ protobuf/

### sql

Use for:

- table definitions
- DDL files
- relational schemas

### json

Use for:

- JSON schema definitions
- validation models
- API payload structure definitions

### avro

Use for:

- streaming event schemas
- Kafka message formats
- schema registry compatible files

### protobuf

Use for:

- message contracts
- event formats
- strongly typed service payloads

---

## databases

Reusable assets related to database systems.

Important:
This repository should not store live database instances.

It may store only reusable database-related resources such as:

- docker setup
- initialization scripts
- schema definitions
- seed data
- small dumps
- collection structures

### mysql

    databases/mysql/
    ├─ docker/
    ├─ init/
    ├─ schema/
    ├─ seed/
    └─ dumps/

Use for:

- database schema definitions
- database initialization scripts
- local development environments
- seed data for exercises
- small test dumps

### mongodb

    databases/mongodb/
    ├─ docker/
    ├─ init/
    ├─ collections/
    ├─ seed/
    └─ dumps/

Use for:

- collection definitions
- sample document structures
- seed documents
- initialization scripts
- local development setup

Do not place large production backups in this directory.

---

## docker

Reusable Docker configurations.

    docker/
    ├─ compose/
    └─ local-stacks/

Examples:

- local Spark clusters
- Kafka environments
- development databases
- multi-service local playgrounds

---

## environments

Tool-specific environment configuration.

    environments/
    ├─ python/
    ├─ spark/
    ├─ dbt/
    └─ airflow/

Use for:

- requirements files
- environment setup notes
- tool-specific runtime setup
- local environment instructions

---

## configs

Reusable configuration templates.

    configs/
    ├─ local/
    ├─ dev/
    └─ templates/

Use for:

- application configuration examples
- local environment configs
- development configs
- reusable config templates

Do not store real credentials here.

---

## scripts

Reusable utility scripts.

    scripts/
    ├─ setup/
    ├─ data-generation/
    ├─ validation/
    └─ helpers/

Use for:

- setup automation
- synthetic data generation
- validation tools
- reusable helper utilities

---

## notebooks

Exploratory and demonstration notebooks.

    notebooks/
    ├─ exploratory/
    └─ demos/

Use this area for:

- experimentation
- demo notebooks
- analysis examples
- temporary exploration that may later evolve into module content

---

## testing

Shared testing resources.

    testing/
    ├─ mock-data/
    ├─ fixtures/
    └─ expected-outputs/

Use for:

- mock datasets
- testing fixtures
- expected pipeline results
- comparison outputs for validation

---

## architecture

Architecture references and design assets.

    architecture/
    ├─ diagrams/
    ├─ patterns/
    └─ reference-flows/

Use for:

- platform diagrams
- reference architecture
- solution patterns
- example end-to-end flows

---

## templates

Templates for consistent repository structure.

    templates/
    ├─ module-template/
    ├─ project-template/
    └─ README-template/

Use these templates to keep future modules and projects consistent.

---

# How to fill this directory over time

The `shared/` directory does not need to be fully populated immediately.

A good approach is to grow it gradually as new reusable assets appear.

Recommended order:

1. start with structure only
2. add small sample datasets
3. add shared schemas
4. add reusable database seeds and init scripts
5. add docker setups and local stacks
6. add helper scripts and templates

This keeps the repository clean and prevents overengineering at the start.

---

# What should NOT go into `shared/`

Do not place the following here:

- files used only by one module
- large datasets
- production database backups
- secrets
- real `.env` files
- credentials
- API keys
- tokens
- local runtime files
- temporary machine-specific files

Examples of bad candidates:

- a dataset only needed for one SQL task
- a personal notebook only relevant to one experiment
- a multi-GB Parquet export
- a production MySQL dump

---

# Safe Mode Rules

To keep the repository stable and portable, do NOT commit:

- large datasets
- production database dumps
- credentials
- secrets
- real `.env` files
- large Parquet datasets
- runtime Docker volumes

Prefer instead:

- small sample datasets
- generation scripts
- schema files
- config examples
- documentation

---

# Repository Philosophy

This repository is designed as a structured learning roadmap for data engineering and data platform development.

The `shared/` directory acts as the central library of reusable assets that support multiple modules and projects.

It should make the repository:

- cleaner
- more consistent
- easier to maintain
- easier to scale over time
EOF

log "shared/README.md created."