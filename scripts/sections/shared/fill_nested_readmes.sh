#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="shared-fill-readmes"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/shared"


log "Creating nested README files for shared subdirectories..."


cat <<'EOF' > "$SECTION_ROOT/datasets/raw/README.md"
# Raw Datasets

This directory contains original source datasets before processing.

## Purpose

Use this directory for reusable raw inputs shared across multiple modules.

## Typical formats

- CSV
- JSON
- Parquet

## Rules

- keep only reusable raw data here
- prefer small and practical files
- do not store large production exports
EOF

cat <<'EOF' > "$SECTION_ROOT/datasets/sample/README.md"
# Sample Datasets

This directory contains small datasets safe to keep in the repository.

## Purpose

Use this directory for lightweight examples used in:

- exercises
- demos
- quick experiments
- local testing

## Rules

- keep files small
- prefer repository-friendly samples
- use this directory for training-focused data
EOF

cat <<'EOF' > "$SECTION_ROOT/datasets/processed/README.md
# Processed Datasets

This directory contains datasets produced after transformations or processing steps.

## Purpose

Use this directory for reusable processed outputs shared across modules.

## Typical usage

- transformed datasets
- cleaned outputs
- curated examples
- aggregated Parquet outputs

## Rules

- keep outputs small and meaningful
- do not store large pipeline artifacts
EOF

cat <<'EOF' > "$SECTION_ROOT/datasets/generated/README.md
# Generated Datasets

This directory contains synthetic or programmatically generated datasets.

## Purpose

Use this directory for reusable generated data such as:

- fake orders
- synthetic clickstream
- mock IoT events
- test datasets produced by scripts

## Rules

- generation should be reproducible where possible
- keep generated files repository-safe
EOF

cat <<'EOF' > "$SECTION_ROOT/schemas/sql/README.md
# SQL Schemas

This directory contains reusable SQL schema definitions.

## Purpose

Use this directory for:

- table definitions
- indexes
- constraints
- DDL scripts

## Rules

- keep schemas reusable
- place only shared relational definitions here
EOF

cat <<'EOF' > "$SECTION_ROOT/schemas/json/README.md
# JSON Schemas

This directory contains reusable JSON schema definitions.

## Purpose

Use this directory for:

- validation schemas
- payload structures
- shared JSON contracts

## Rules

- keep schema definitions reusable
- use clear naming for data contracts
EOF

cat <<'EOF' > "$SECTION_ROOT/schemas/avro/README.md
# Avro Schemas

This directory contains reusable Avro schema definitions.

## Purpose

Use this directory for:

- Kafka event schemas
- streaming contracts
- schema-registry compatible definitions

## Rules

- keep contracts versionable and reusable
- use consistent event naming
EOF

cat <<'EOF' > "$SECTION_ROOT/schemas/protobuf/README.md
# Protobuf Schemas

This directory contains reusable Protocol Buffer schema definitions.

## Purpose

Use this directory for:

- typed message contracts
- event definitions
- service payload structures

## Rules

- keep definitions reusable
- prefer clear package and message naming
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mysql/docker/README.md
# MySQL Docker

This directory contains Docker assets for reusable MySQL local environments.

## Purpose

Use this directory for:

- Docker Compose files
- container setup
- local dev database environments

## Rules

- do not store runtime data
- do not commit secrets
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mysql/init/README.md
# MySQL Init

This directory contains MySQL initialization scripts.

## Purpose

Use this directory for scripts that run during first-time database setup.

## Typical usage

- create database
- create schemas
- bootstrap initial state
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mysql/schema/README.md
# MySQL Schema

This directory contains reusable MySQL schema definitions.

## Purpose

Use this directory for:

- CREATE TABLE scripts
- indexes
- constraints
- relational structure definitions
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mysql/seed/README.md
# MySQL Seed Data

This directory contains reusable seed data for MySQL.

## Purpose

Use this directory for:

- insert scripts
- sample records
- educational datasets
- local development seed data

## Rules

- keep data small
- do not store production data
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mysql/dumps/README.md
# MySQL Dumps

This directory contains small MySQL dumps for testing and learning.

## Purpose

Use this directory only for:

- small educational dumps
- test backups
- local reproducible examples

## Rules

- do not store production backups
- do not commit large dumps
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mongodb/docker/README.md
# MongoDB Docker

This directory contains Docker assets for reusable MongoDB local environments.

## Purpose

Use this directory for:

- Docker Compose files
- local MongoDB setup
- development container configuration

## Rules

- do not store runtime data
- do not commit secrets
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mongodb/init/README.md
# MongoDB Init

This directory contains MongoDB initialization scripts.

## Purpose

Use this directory for first-time local setup automation and bootstrap scripts.
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mongodb/collections/README.md
# MongoDB Collections

This directory contains reusable collection structure references.

## Purpose

Use this directory for:

- collection design notes
- document structure examples
- shared modeling references
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mongodb/seed/README.md
# MongoDB Seed Data

This directory contains reusable MongoDB seed data.

## Purpose

Use this directory for:

- sample documents
- local development seed data
- reusable demo content

## Rules

- keep data small
- prefer synthetic or sample data
EOF

cat <<'EOF' > "$SECTION_ROOT/databases/mongodb/dumps/README.md
# MongoDB Dumps

This directory contains small MongoDB dumps for learning and testing.

## Rules

- do not store large dumps
- do not store production data
- keep dumps small and reproducible
EOF

cat <<'EOF' > "$SECTION_ROOT/docker/compose/README.md
# Docker Compose

This directory contains reusable Docker Compose definitions.

## Purpose

Use this directory for:

- single-service setups
- simple multi-service local development setups
- reusable compose examples
EOF

cat <<'EOF' > "$SECTION_ROOT/docker/local-stacks/README.md
# Local Stacks

This directory contains reusable local multi-service stacks.

## Purpose

Use this directory for combined development environments such as:

- Spark + storage
- Kafka + database
- Airflow + database
- end-to-end local playgrounds

## Rules

- keep stacks reusable
- avoid machine-specific configuration
EOF

cat <<'EOF' > "$SECTION_ROOT/environments/python/README.md
# Python Environment

This directory contains reusable Python environment setup assets.

## Purpose

Use this directory for:

- requirements files
- setup instructions
- environment notes
EOF

cat <<'EOF' > "$SECTION_ROOT/environments/spark/README.md
# Spark Environment

This directory contains reusable Spark environment setup assets.

## Purpose

Use this directory for:

- Spark local setup notes
- environment configuration
- reusable setup guidance
EOF

cat <<'EOF' > "$SECTION_ROOT/environments/dbt/README.md
# dbt Environment

This directory contains reusable dbt environment setup assets.

## Purpose

Use this directory for:

- dbt local setup
- environment notes
- reusable setup references
EOF

cat <<'EOF' > "$SECTION_ROOT/environments/airflow/README.md
# Airflow Environment

This directory contains reusable Airflow environment setup assets.

## Purpose

Use this directory for:

- Airflow setup notes
- local environment guidance
- reusable setup references
EOF

cat <<'EOF' > "$SECTION_ROOT/configs/local/README.md
# Local Configs

This directory contains reusable local configuration examples.

## Rules

- use placeholders
- never store real secrets
- keep configs generic and reusable
EOF

cat <<'EOF' > "$SECTION_ROOT/configs/dev/README.md
# Development Configs

This directory contains reusable development-environment configuration examples.

## Rules

- never commit credentials
- prefer example values and templates
EOF

cat <<'EOF' > "$SECTION_ROOT/configs/templates/README.md
# Config Templates

This directory contains reusable configuration templates.

## Purpose

Use this directory for starter configs and placeholder-based examples.
EOF

cat <<'EOF' > "$SECTION_ROOT/scripts/setup/README.md
# Setup Scripts

This directory contains reusable setup automation scripts.

## Purpose

Use this directory for scripts that prepare environments, dependencies, or local tooling.
EOF

cat <<'EOF' > "$SECTION_ROOT/scripts/data-generation/README.md
# Data Generation Scripts

This directory contains reusable scripts for generating synthetic data.

## Purpose

Use this directory for:

- fake orders generation
- clickstream simulation
- mock event generation
EOF

cat <<'EOF' > "$SECTION_ROOT/scripts/validation/README.md
# Validation Scripts

This directory contains reusable validation utilities.

## Purpose

Use this directory for scripts that validate:

- datasets
- schemas
- pipeline outputs
- expected results
EOF

cat <<'EOF' > "$SECTION_ROOT/scripts/helpers/README.md
# Helper Scripts

This directory contains small reusable helper utilities.

## Purpose

Use this directory for generic scripts used across multiple modules and projects.
EOF

cat <<'EOF' > "$SECTION_ROOT/notebooks/exploratory/README.md
# Exploratory Notebooks

This directory contains exploratory notebooks.

## Purpose

Use this directory for temporary exploration, data inspection, and concept testing.

## Rules

- keep notebooks lightweight
- move module-specific content into the relevant module if needed
EOF

cat <<'EOF' > "$SECTION_ROOT/notebooks/demos/README.md
# Demo Notebooks

This directory contains notebooks intended for clear demonstrations.

## Purpose

Use this directory for reusable example notebooks that explain workflows or concepts.
EOF

cat <<'EOF' > "$SECTION_ROOT/testing/mock-data/README.md
# Mock Data

This directory contains small fake datasets used for testing.

## Purpose

Use this directory for deterministic mock inputs shared across modules.
EOF

cat <<'EOF' > "$SECTION_ROOT/testing/fixtures/README.md
# Fixtures

This directory contains reusable test fixtures.

## Purpose

Use this directory for static inputs, support files, and repeatable test assets.
EOF

cat <<'EOF' > "$SECTION_ROOT/testing/expected-outputs/README.md
# Expected Outputs

This directory contains known-good expected outputs.

## Purpose

Use this directory for comparison files used in testing and validation.
EOF

cat <<'EOF' > "$SECTION_ROOT/architecture/diagrams/README.md
# Architecture Diagrams

This directory contains reusable diagrams that support multiple modules and projects.
EOF

cat <<'EOF' > "$SECTION_ROOT/architecture/patterns/README.md
# Architecture Patterns

This directory contains reusable architecture and solution patterns.

## Purpose

Use this directory for common design approaches that can be referenced across modules.
EOF

cat <<'EOF' > "$SECTION_ROOT/architecture/reference-flows/README.md
# Reference Flows

This directory contains reusable end-to-end reference flows.

## Purpose

Use this directory for example platform journeys and data flow references.
EOF

cat <<'EOF' > "$SECTION_ROOT/templates/module-template/README.md
# Module Template

This directory contains template assets for creating new modules.

## Purpose

Use this directory to keep module structure consistent across the repository.
EOF

cat <<'EOF' > "$SECTION_ROOT/templates/project-template/README.md
# Project Template

This directory contains template assets for creating new projects.

## Purpose

Use this directory to keep project structure consistent and reusable.
EOF

cat <<'EOF' > "$SECTION_ROOT/templates/README-template/README.md
# README Template

This directory contains reusable README starter templates and patterns.
EOF

log "Nested README files created."