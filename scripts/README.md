# Scripts System

This directory contains automation scripts used to manage the repository structure.

The scripts allow automatic creation and filling of modules, docs, and other repository sections.

The system is designed to be:

- safe-mode
- modular
- scalable
- easy to extend
- friendly for future automation

---

# Goals

The main goals of the scripts system are:

- create consistent structures across modules
- avoid manual repetitive setup
- preserve existing content
- support future growth of the repository
- make expansion of the learning roadmap predictable

---

# Repository Sections

The repository is divided into several logical sections.

## Modules

Learning modules such as:

    00-shell-linux
    00-git
    01-python
    02-sql
    03-docker
    04-github-actions
    05-confluent-kafka
    06-spark-pyspark
    07-databricks
    08-delta-lake
    09-azure-data-lake-storage
    10-powerbi-fabric
    11-airflow
    12-dbt
    13-flink
    14-iceberg

Each module follows the standard structure:

    <module>/
      README.md
      learning-materials/
      simple-tasks/
      pet-projects/

## Docs

Architecture and study-related documentation:

    docs/
      architecture/
      system-design/
      case-studies/
      trade-offs/

## AI Learning

AI-assisted learning materials:

    ai-learning/
      prompting-guides/
      workflows/
      tools/
      practical-exercises/

## Shared

Reusable resources:

    shared/
      datasets/
      diagrams/
      glossary/
      utils/

## Real Projects

Large end-to-end projects:

    real-projects/

---

# Scripts Directory Structure

The new scripts architecture is section-based.

    scripts/
      README.md
      create_module.sh
      bootstrap_section.sh
      bootstrap_all.sh

      lib/
        common.sh
        fs.sh
        section.sh

      sections/
        modules/
          01-python/
            init.sh
            fill_learning_materials.sh
            fill_simple_tasks.sh
            fill_pet_projects.sh
            bootstrap.sh

          02-sql/
            init.sh
            fill_learning_materials.sh
            fill_simple_tasks.sh
            fill_pet_projects.sh
            bootstrap.sh

        docs/
          init.sh
          fill_core_docs.sh
          fill_architecture.sh
          fill_system_design.sh
          fill_case_studies.sh
          fill_tradeoffs.sh
          bootstrap.sh

        ai-learning/
          init.sh
          fill_prompting_guides.sh
          fill_workflows.sh
          fill_tools.sh
          fill_practical_exercises.sh
          bootstrap.sh

        shared/
          init.sh
          fill_readmes.sh
          bootstrap.sh

        real-projects/
          init.sh
          fill_readmes.sh
          bootstrap.sh

      old/

---

# Core Design Principles

## 1. Safe Mode

Scripts must not overwrite existing content.

Rules:

- create directories only if they do not already exist
- create files only if they do not already exist
- write file content only if a file is empty
- preserve existing manual work

## 2. Separation of Responsibilities

Scripts are split by responsibility.

Examples:

- `init.sh` creates structure
- `fill_learning_materials.sh` fills learning content
- `fill_simple_tasks.sh` fills tasks
- `fill_pet_projects.sh` fills pet project files
- `bootstrap.sh` runs the full workflow

## 3. Section-Based Organization

Scripts are grouped by repository section, not thrown into one flat directory.

This makes the system easier to scale as the repository grows.

Finished modules may use a snapshot-based generator pattern where `template_snapshot/` is the source of truth and `fill_*` scripts copy from that snapshot.

Current generator-backed modules:

- `00-shell-linux/`
- `00-git/`
- `02-sql/`
- `03-docker/`
- `04-github-actions/`
- `11-airflow/`
- `12-dbt/`
- `15-raspberry-pi-homelab/`

## 4. Reusability

Common utilities are stored in:

    scripts/lib/

This avoids duplicated shell logic across many scripts.

---

# Library Files

## `scripts/lib/common.sh`

Contains common helper functions such as:

- log
- warn
- die

## `scripts/lib/fs.sh`

Contains file system helpers such as:

- ensure_dir
- ensure_file
- write_file_safe

## `scripts/lib/section.sh`

Contains helper logic related to repository root or section handling.

---

# Module Script Structure

Each module should have its own script directory:

    scripts/sections/modules/<module>/

Example:

    scripts/sections/modules/02-sql/

Contents:

    init.sh
    fill_readme.sh
    fill_learning_materials.sh
    fill_simple_tasks.sh
    fill_pet_projects.sh
    bootstrap.sh

## Responsibilities

### `init.sh`

Creates the directory structure for the module.

Example responsibilities:

- create module root
- create `learning-materials`
- create `simple-tasks`
- create `pet-projects`

### `fill_learning_materials.sh`

Creates and fills markdown files inside:

    learning-materials/

### `fill_simple_tasks.sh`

Creates and fills markdown task descriptions inside:

    simple-tasks/

### `fill_pet_projects.sh`

Creates and fills markdown project descriptions inside:

    pet-projects/

### `bootstrap.sh`

Runs the module scripts in the correct order.

Typical flow:

    init.sh
    fill_readme.sh
    fill_learning_materials.sh
    fill_simple_tasks.sh
    fill_pet_projects.sh

---

# Docs Script Structure

Docs are not modules, so they have their own section scripts.

Directory:

    scripts/sections/docs/

Example files:

    init.sh
    fill_core_docs.sh
    fill_architecture.sh
    fill_system_design.sh
    fill_case_studies.sh
    fill_tradeoffs.sh
    bootstrap.sh

## Why docs are separate

The docs section has different internal structure and different content types than modules.

It should not be forced into module-style automation.

---

# AI Learning Script Structure

Directory:

    scripts/sections/ai-learning/

Example files:

    init.sh
    fill_prompting_guides.sh
    fill_workflows.sh
    fill_tools.sh
    fill_practical_exercises.sh
    bootstrap.sh

This section is also separate because it is not a learning module in the same sense as Python or SQL.

---

# Shared Script Structure

Directory:

    scripts/sections/shared/

This section usually needs lighter automation:

- directory creation
- README creation
- optional future metadata files

---

# Real Projects Script Structure

Directory:

    scripts/sections/real-projects/

This section is for larger end-to-end projects and usually needs its own scaffolding logic.

---

# Entrypoints

## Run one section

Use:

    ./scripts/bootstrap_section.sh <section> [name]

Examples:

    ./scripts/bootstrap_section.sh modules 00-shell-linux
    ./scripts/bootstrap_section.sh modules 00-git
    ./scripts/bootstrap_section.sh modules 02-sql
    ./scripts/bootstrap_section.sh docs
    ./scripts/bootstrap_section.sh ai-learning

## Run foundational module bootstraps directly

The foundational modules are generator-backed too.

Use:

    ./scripts/bootstrap_section.sh modules 00-shell-linux
    ./scripts/bootstrap_section.sh modules 00-git

These commands recreate the curated module contents from:

    scripts/sections/modules/00-shell-linux/template_snapshot/
    scripts/sections/modules/00-git/template_snapshot/

## CI Validation For Foundational Modules

There is also a lightweight repository workflow that validates these foundational starter assets after changes:

    .github/workflows/foundational-starter-assets.yml

It is intended to protect the starter assets shipped with the generator-backed foundational modules.

It uses:

    ./scripts/check_foundational_starter_assets.sh

Current checks:

- bootstrap `00-shell-linux`
- bootstrap `00-git`
- verify starter scripts remain executable
- verify representative shell starter outputs
- verify representative Git starter repo state

When you change starter assets or their snapshot sources, this workflow should stay green.

Useful local command:

    ./scripts/check_foundational_starter_assets.sh

## CI Validation For All Generator-Backed Modules

There is also a repository-wide workflow for full generator integrity validation:

    .github/workflows/generator-backed-modules.yml

It uses:

    ./scripts/check_generator_backed_modules.sh

Current checks:

- bootstrap all generator-backed modules
- compare each regenerated module with its `template_snapshot/`
- fail fast when snapshot drift appears

Useful local commands:

    ./scripts/check_generator_backed_modules.sh
    ./scripts/check_generator_backed_modules.sh list

## Aggregate Repository Smoke Checks

If you want one repository-level entrypoint for the smoke checks already used in CI, use:

    ./scripts/run_repo_smoke_checks.sh

It currently runs:

- foundational starter-asset validation
- generator-backed module validation

Useful command variants:

    ./scripts/run_repo_smoke_checks.sh foundational
    ./scripts/run_repo_smoke_checks.sh generator-backed
    ./scripts/run_repo_smoke_checks.sh list

## Update a generator-backed module safely

For snapshot-based modules, edit the template snapshot first.

Recommended workflow:

1. update files under `scripts/sections/modules/<module>/template_snapshot/`
2. run `./scripts/bootstrap_section.sh modules <module>`
3. verify the regenerated module output

Example:

    ./scripts/bootstrap_section.sh modules 00-shell-linux

## Run all configured sections

Use:

    ./scripts/bootstrap_all.sh

This is useful when building or rebuilding the whole repository structure.

---

# Creating a New Module

Use:

    ./scripts/create_module.sh 03-docker

This creates:

    scripts/sections/modules/03-docker/
      init.sh
    fill_readme.sh
      fill_learning_materials.sh
      fill_simple_tasks.sh
      fill_pet_projects.sh
      bootstrap.sh

After creation, implement the logic inside these files.

Then run:

    ./scripts/bootstrap_section.sh modules 03-docker

---

# Expected Development Workflow

A typical workflow for adding a new module:

## Step 1

Create module scripts:

    ./scripts/create_module.sh 03-docker

## Step 2

Implement logic inside:

    scripts/sections/modules/03-docker/

## Step 3

Run bootstrap:

    ./scripts/bootstrap_section.sh modules 03-docker

## Step 4

Review generated content and continue manual refinement if needed.

---

# Migration Strategy

The repository originally had a flatter scripts structure.

The new architecture introduces:

- `scripts/lib/`
- `scripts/sections/`
- section-based bootstrapping

Old scripts can be moved gradually into:

    scripts/old/

This allows incremental migration without breaking working flows.

---

# Safe Mode Rules

This repository uses safe-mode scripting.

That means:

- existing directories are not recreated destructively
- existing files are not overwritten
- non-empty files are preserved
- scaffolding is additive, not destructive

This is especially important because many sections are manually curated and should not be damaged by automation.

---

# Why This System Exists

As the repository grows, manual creation of modules and documentation becomes harder to maintain.

Without a structured scripts system, the repository would risk:

- inconsistent structures
- repeated manual work
- duplicated logic
- higher maintenance cost
- lower scalability

This scripts system provides a consistent foundation for expanding the roadmap safely.

---

# Current Priorities

At the current stage, the main focus is:

- stabilize the scripts architecture
- support modules
- support docs
- support future module expansion
- prepare the repository for scalable growth

The first main migrated targets are:

- `01-python`
- `02-sql`
- `docs`

After that, future modules should use the new scripts system from the start.

---

# Recommended Next Steps

Recommended order of work:

1. finalize `scripts/lib/`
2. migrate `02-sql`
3. migrate `01-python`
4. migrate `docs`
5. move old scripts into `scripts/old/`
6. build new modules only with the new structure

---

# Final Note

This scripts system is not just a collection of shell files.

It is the automation layer of the repository.

A clean scripts architecture makes the learning platform:

- easier to expand
- easier to maintain
- safer to automate
- more consistent across sections
- better prepared for long-term growth


---

# Command Reference

This section shows the most common commands used to manage the repository structure.

These commands are intended to be run from the repository root.

---

# 1. Make Scripts Executable

After cloning the repository or creating new scripts, make them executable:

    find scripts -name "*.sh" -exec chmod +x {} \;

---

or

    f chmod +x scripts/**/*.sh
___


# 2. Bootstrap Entire Repository Structure

To initialize or verify the entire repository structure:

    ./scripts/bootstrap_all.sh

This command will run bootstrapping scripts for all configured sections:

- docs
- shared
- ai-learning
- modules
- real-projects

Safe mode guarantees that existing files will not be overwritten.

---

# 3. Bootstrap One Section

To bootstrap a specific section:

    ./scripts/bootstrap_section.sh <section>

Examples:

    ./scripts/bootstrap_section.sh docs
    ./scripts/bootstrap_section.sh shared
    ./scripts/bootstrap_section.sh ai-learning
    ./scripts/bootstrap_section.sh real-projects

---

# 4. Bootstrap One Module

To bootstrap a specific learning module:

    ./scripts/bootstrap_section.sh modules <module>

Example:

    ./scripts/bootstrap_section.sh modules 02-sql

This runs:

    init.sh
    fill_learning_materials.sh
    fill_simple_tasks.sh
    fill_pet_projects.sh

for that module.

---

# 5. Create a New Module (Scripts Only)

To create the script structure for a new module:

    ./scripts/create_module.sh 03-docker

This generates:

    scripts/sections/modules/03-docker/

        init.sh
        fill_learning_materials.sh
        fill_simple_tasks.sh
        fill_pet_projects.sh
        bootstrap.sh

After this, implement the logic inside those scripts.

---

# 6. Generate a New Module

Once the scripts for the module are implemented, generate its structure:

    ./scripts/bootstrap_section.sh modules 03-docker

This will create or fill:

    03-docker/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

---

# 7. Re-run Module Generation

You can safely run module bootstrap multiple times:

    ./scripts/bootstrap_section.sh modules 02-sql

Safe mode ensures:

- existing directories are preserved
- existing files are not overwritten
- non-empty files remain untouched

This allows incremental updates.

---

# 8. Typical Workflow for Adding a Module

Step 1 — Create scripts

    ./scripts/create_module.sh 03-docker

Step 2 — Implement module scripts

Edit files in:

    scripts/sections/modules/03-docker/

Step 3 — Generate module

    ./scripts/bootstrap_section.sh modules 03-docker

Step 4 — Continue writing learning materials manually if needed.

---

# 9. Typical Workflow for Expanding the Repository

Example workflow when expanding the roadmap:

1. create module scripts

       ./scripts/create_module.sh 04-github-actions

2. implement module logic

3. bootstrap module

       ./scripts/bootstrap_section.sh modules 04-github-actions

4. verify generated structure

5. add detailed content

---

# 10. Safe Mode Reminder

All scripts operate in safe mode.

This means:

- existing directories are not recreated destructively
- existing files are never overwritten
- non-empty files are preserved
- scripts can be safely re-run

This protects manual work from accidental loss.