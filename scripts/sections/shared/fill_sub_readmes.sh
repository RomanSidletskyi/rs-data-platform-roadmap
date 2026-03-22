#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="shared-fill-readmes"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/shared"

log "Creating README files for shared subdirectories..."


cat <<'EOF' > "$SECTION_ROOT/datasets/README.md
# Datasets

This directory contains reusable datasets shared across multiple modules.

## Purpose

Use this directory for data files that may be reused in exercises, demos, pipelines, and projects.

## Structure

    datasets/
    ├─ raw/
    ├─ sample/
    ├─ processed/
    └─ generated/

## What goes where

### raw
Original source datasets before transformations.

### sample
Small repository-safe datasets for demos, exercises, and quick testing.

### processed
Outputs produced by processing pipelines.

### generated
Synthetic datasets created by scripts.

## Rules

- keep files small and practical
- prefer sample datasets over large real datasets
- do not commit multi-GB files
- if a dataset is used by only one module, keep it in that module instead
EOF

cat <<'EOF' > "$SECTION_ROOT/schemas/README.md
# Schemas

This directory contains reusable schema definitions used across multiple modules and tools.

## Purpose

Use this directory to store shared definitions for structured data.

## Structure

    schemas/
    ├─ sql/
    ├─ json/
    ├─ avro/
    └─ protobuf/

## What goes where

### sql
DDL files and relational table definitions.

### json
JSON schema definitions and payload structures.

### avro
Streaming event schemas and schema-registry compatible contracts.

### protobuf
Protocol Buffer contracts and strongly typed message definitions.

## Rules

- keep schemas reusable
- place only shared contracts here
- module-specific schemas should stay inside the module
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/README.md
# Databases

This directory contains reusable database-related assets.

## Purpose

Use this directory for shared database setup components such as:

- docker configuration
- init scripts
- schema files
- seed data
- small dumps

## Important

This repository should not store running databases or large production backups.

## Structure

    databases/
    ├─ mysql/
    └─ mongodb/
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mysql/README.md
# MySQL Resources

This directory contains reusable MySQL-related assets shared across modules and projects.

## Structure

    mysql/
    ├─ docker/
    ├─ init/
    ├─ schema/
    ├─ seed/
    └─ dumps/

## What goes where

### docker
Docker and Compose configuration for local MySQL environments.

### init
Scripts executed during first-time database initialization.

### schema
Table definitions, indexes, and constraints.

### seed
Sample insert scripts and small development datasets.

### dumps
Small MySQL dumps for educational or testing purposes.

## Rules

- do not store production backups
- do not commit large dumps
- keep data small and reusable
- use this directory only for assets reused across modules
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mongodb/README.md
# MongoDB Resources

This directory contains reusable MongoDB-related assets shared across modules and projects.

## Structure

    mongodb/
    ├─ docker/
    ├─ init/
    ├─ collections/
    ├─ seed/
    └─ dumps/

## What goes where

### docker
Docker and Compose setup for local MongoDB environments.

### init
Initialization scripts for first-time setup.

### collections
Collection structure references and example document models.

### seed
Sample documents and reusable seed data.

### dumps
Small dumps for testing and learning.

## Rules

- do not store production dumps
- keep dumps small
- use sample or synthetic data whenever possible
EOF

cat <<'EOF' > "$SECTION_ROOT/docker/README.md
# Docker

This directory contains reusable Docker assets shared across multiple modules.

## Purpose

Use this directory for local infrastructure and reusable containerized environments.

## Structure

    docker/
    ├─ compose/
    └─ local-stacks/

## What goes where

### compose
Reusable Compose files for individual services or simple setups.

### local-stacks
Multi-service local stacks such as Spark, Kafka, databases, or combined playgrounds.

## Rules

- keep stacks reusable
- do not store runtime volumes here
- do not commit secrets or real credentials
EOF

cat <<'EOF' > "$SECTION_ROOT/environments/README.md
# Environments

This directory contains reusable environment setup assets.

## Purpose

Use this directory for tool-specific environment configuration and setup guidance.

## Structure

    environments/
    ├─ python/
    ├─ spark/
    ├─ dbt/
    └─ airflow/

## Examples

- requirements files
- setup instructions
- environment notes
- local dev setup references

## Rules

- do not store secrets
- prefer templates and examples
- keep tool setup reusable across modules
EOF

cat <<'EOF' > "$SECTION_ROOT/configs/README.md
# Configs

This directory contains reusable configuration assets.

## Purpose

Use this directory for shared configuration examples and templates.

## Structure

    configs/
    ├─ local/
    ├─ dev/
    └─ templates/

## What goes where

### local
Local development config examples.

### dev
Shared development-environment config examples.

### templates
Generic config templates for reuse.

## Rules

- never store real secrets
- never commit real credentials
- use placeholders and example values
EOF

cat <<'EOF' > "$SECTION_ROOT/scripts/README.md
# Shared Scripts

This directory contains reusable scripts shared across modules.

## Purpose

Use this directory for helper automation that can be reused in multiple places.

## Structure

    scripts/
    ├─ setup/
    ├─ data-generation/
    ├─ validation/
    └─ helpers/

## What goes where

### setup
Environment and dependency setup scripts.

### data-generation
Synthetic data generation utilities.

### validation
Validation scripts for datasets, schemas, or outputs.

### helpers
Small reusable helper scripts.

## Rules

- keep scripts generic and reusable
- module-specific scripts should stay inside the module
EOF

cat <<'EOF' > "$SECTION_ROOT/notebooks/README.md
# Notebooks

This directory contains reusable or reference notebooks.

## Purpose

Use this directory for exploratory work and demonstration notebooks that may support multiple modules.

## Structure

    notebooks/
    ├─ exploratory/
    └─ demos/

## What goes where

### exploratory
Temporary exploration, experiments, or data inspection.

### demos
Clear demo notebooks intended to illustrate concepts or workflows.

## Rules

- keep notebooks lightweight
- avoid personal one-off files if they belong only to one module
EOF

cat <<'EOF' > "$SECTION_ROOT/testing/README.md
# Testing

This directory contains shared testing resources.

## Purpose

Use this directory for reusable assets that support testing across modules and projects.

## Structure

    testing/
    ├─ mock-data/
    ├─ fixtures/
    └─ expected-outputs/

## What goes where

### mock-data
Small fake datasets used for tests.

### fixtures
Reusable test fixtures and input assets.

### expected-outputs
Known-good outputs used for comparison and validation.

## Rules

- keep files small
- make assets deterministic where possible
- do not store large test artifacts
EOF

cat <<'EOF' > "$SECTION_ROOT/architecture/README.md
# Architecture

This directory contains shared architecture references.

## Purpose

Use this directory for diagrams, patterns, and reference flows that support multiple modules.

## Structure

    architecture/
    ├─ diagrams/
    ├─ patterns/
    └─ reference-flows/

## What goes where

### diagrams
Architecture diagrams and visuals.

### patterns
Reusable solution patterns and design ideas.

### reference-flows
Example end-to-end flows and platform journeys.

## Rules

- keep references general and reusable
- module-specific design notes should stay in the module or docs
EOF

cat <<'EOF' > "$SECTION_ROOT/templates/README.md
# Templates

This directory contains reusable templates for consistent repository growth.

## Purpose

Use this directory to standardize how new content is created.

## Structure

    templates/
    ├─ module-template/
    ├─ project-template/
    └─ README-template/

## What goes where

### module-template
Base structure for new modules.

### project-template
Base structure for new projects.

### README-template
Reusable README patterns and starter templates.

## Rules

- keep templates minimal and reusable
- update templates when repository conventions evolve
EOF

log "Subdirectory README files created."