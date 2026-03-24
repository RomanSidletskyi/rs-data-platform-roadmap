# Scripts System

This directory contains the repository automation layer.

Its job is to keep module and section generation consistent, safe, and maintainable.

At the top level, you should think about the scripts system through five entrypoints:

- `create_module.sh`
- `create_section.sh`
- `bootstrap_section.sh`
- `refresh_template_snapshots.sh`
- `check_repo.sh`

If you only need to use the scripts system day to day, this README should be enough.

If you need the exact tree, use `scripts/structure.md`.

## How To Run Shell Scripts

Run all commands from the repository root:

    cd /Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap

There are two normal ways to run the top-level `.sh` files.

### Option 1 - Run Executable Script Directly

Use this when the script already has execute permission:

    ./scripts/bootstrap_section.sh docs
    ./scripts/bootstrap_section.sh modules 01-python
    ./scripts/check_repo.sh
    ./scripts/refresh_template_snapshots.sh modules

### Option 2 - Run Through `bash`

Use this when you want to execute the script even if it is not marked executable yet:

    bash ./scripts/bootstrap_section.sh docs
    bash ./scripts/bootstrap_section.sh modules 01-python
    bash ./scripts/check_repo.sh
    bash ./scripts/refresh_template_snapshots.sh modules

### If A Script Is Not Executable

Make one script executable:

    chmod +x ./scripts/check_repo.sh

Make all shell scripts under `scripts/` executable:

    find ./scripts -name "*.sh" -exec chmod +x {} \;

After that, you can use the shorter direct form:

    ./scripts/check_repo.sh

### Quick Rule

- if the file is executable, use `./scripts/<name>.sh`
- if it is not executable yet, use `bash ./scripts/<name>.sh`
- for this repository, prefer running from the repository root so relative paths always resolve correctly

## What The System Does

The current scripts system supports two generator-backed layers:

- modules under `scripts/sections/modules/`
- top-level repository sections under `scripts/sections/`

That means the repository can generate or validate both:

- numbered learning modules such as `01-python/` or `11-airflow/`
- top-level sections such as `docs/`, `shared/`, `ai-learning/`, and `real-projects/`

The design goal is one consistent orchestration model.

## Current Top-Level Shell Scripts

These are the shell entrypoints at `scripts/` root and what they do.

### `create_module.sh`

Creates a new generator scaffold for a module under `scripts/sections/modules/<module>/`.

What it creates:

- `init.sh`
- `fill_readme.sh`
- `fill_learning_materials.sh`
- `fill_simple_tasks.sh`
- `fill_pet_projects.sh`
- `bootstrap.sh`
- `template_snapshot/`

Use when:

- you want to start a new generator-backed numbered module

Example:

    ./scripts/create_module.sh 16-some-new-module

### `create_section.sh`

Creates a new generator scaffold for a top-level section under `scripts/sections/<section>/`.

Supported section names:

- `docs`
- `shared`
- `ai-learning`
- `real-projects`

What it creates:

- `init.sh`
- `fill_readme.sh`
- `fill_content.sh`
- `bootstrap.sh`
- `template_snapshot/`

Use when:

- you want a top-level repository section to follow the same generator contract as mature sections

Example:

    ./scripts/create_section.sh shared

### `bootstrap_section.sh`

Main generation entrypoint.

Use it to regenerate one section, one module, all script-backed modules, or the whole script-backed repository surface.

Supported forms:

    ./scripts/bootstrap_section.sh <section>
    ./scripts/bootstrap_section.sh modules <module-name>
    ./scripts/bootstrap_section.sh modules --all
    ./scripts/bootstrap_section.sh all

Examples:

    ./scripts/bootstrap_section.sh docs
    ./scripts/bootstrap_section.sh shared
    ./scripts/bootstrap_section.sh ai-learning
    ./scripts/bootstrap_section.sh real-projects
    ./scripts/bootstrap_section.sh modules 01-python
    ./scripts/bootstrap_section.sh modules 11-airflow
    ./scripts/bootstrap_section.sh modules --all
    ./scripts/bootstrap_section.sh all

What `all` means:

- bootstrap all script-backed top-level sections
- bootstrap all module directories currently present under `scripts/sections/modules/`

Important:

- `all` follows the real generator tree automatically
- it does not use a hardcoded module list
- placeholders outside the generator tree are therefore not pulled into active auto-generation accidentally

### `refresh_template_snapshots.sh`

Refreshes generator snapshots from live repository content.

Use it when you intentionally changed the live generated output and want to promote those changes back into the generator source of truth.

Supported forms:

    ./scripts/refresh_template_snapshots.sh
    ./scripts/refresh_template_snapshots.sh all
    ./scripts/refresh_template_snapshots.sh sections
    ./scripts/refresh_template_snapshots.sh modules
    ./scripts/refresh_template_snapshots.sh list
    ./scripts/refresh_template_snapshots.sh <target-name> [target-name...]

Examples:

    ./scripts/refresh_template_snapshots.sh
    ./scripts/refresh_template_snapshots.sh sections
    ./scripts/refresh_template_snapshots.sh modules
    ./scripts/refresh_template_snapshots.sh 01-python
    ./scripts/refresh_template_snapshots.sh docs shared

Important behavior:

- sections sync from live section content into `template_snapshot/`
- modules sync from live module content into `template_snapshot/`
- module-level `PROGRESS.md` is intentionally excluded because it is learner-managed state, not generator source content

### `check_repo.sh`

Unified repository validation entrypoint.

Use it to validate starter assets, section snapshots, and module snapshots.

Supported forms:

    ./scripts/check_repo.sh
    ./scripts/check_repo.sh all
    ./scripts/check_repo.sh foundational
    ./scripts/check_repo.sh template-backed
    ./scripts/check_repo.sh sections
    ./scripts/check_repo.sh modules
    ./scripts/check_repo.sh list

Examples:

    ./scripts/check_repo.sh
    ./scripts/check_repo.sh foundational
    ./scripts/check_repo.sh sections
    ./scripts/check_repo.sh modules
    ./scripts/check_repo.sh template-backed
    ./scripts/check_repo.sh list

What each mode does:

- `foundational`: bootstraps `00-shell-linux` and `00-git`, validates bundled starter assets, and checks representative shell and Git labs
- `sections`: bootstraps each top-level section with `template_snapshot/` and checks snapshot sync
- `modules`: bootstraps each module with `template_snapshot/` and checks snapshot sync
- `template-backed`: runs `sections` and `modules`
- default `all`: runs `foundational` and then `template-backed`

Important behavior:

- module validation intentionally ignores root-level `PROGRESS.md`
- this keeps learner state out of generator integrity checks

## Fast Practical Workflows

### 1. Regenerate One Existing Module

Use this when you edited `template_snapshot/` of one module and want to rebuild the live module.

Steps:

1. edit files under `scripts/sections/modules/<module>/template_snapshot/`
2. run the module bootstrap
3. review the live output
4. run validation if needed

Example:

    ./scripts/bootstrap_section.sh modules 01-python
    ./scripts/check_repo.sh modules

### 2. Regenerate One Existing Section

Use this when you edited snapshot content of a top-level section such as `docs/` or `ai-learning/`.

Steps:

1. edit files under `scripts/sections/<section>/template_snapshot/`
2. run the section bootstrap
3. review the live output
4. run validation if needed

Example:

    ./scripts/bootstrap_section.sh docs
    ./scripts/check_repo.sh sections

### 3. Promote Live Changes Back Into Snapshot Source

Use this only when the live repository block is now the intended source of truth and you want to sync the snapshot to match it.

Example:

    ./scripts/refresh_template_snapshots.sh 01-python
    ./scripts/refresh_template_snapshots.sh docs

Then verify:

    ./scripts/check_repo.sh modules
    ./scripts/check_repo.sh sections

### 4. Full Validation Before Finishing Script Work

Use this when you changed generation logic, snapshots, or starter assets.

Recommended sequence:

    ./scripts/check_repo.sh foundational
    ./scripts/check_repo.sh sections
    ./scripts/check_repo.sh modules

Or just:

    ./scripts/check_repo.sh

## Generator Architecture

The current system uses one shared architectural idea across modules and sections:

1. structure creation is separate from content sync
2. bootstrap is the only orchestration entrypoint inside a generator unit
3. mature generator-backed units use `template_snapshot/` as the source of truth

## Module Generator Structure

Each generator-backed module lives under:

    scripts/sections/modules/<module>/

Typical contents:

    init.sh
    fill_readme.sh
    fill_learning_materials.sh
    fill_simple_tasks.sh
    fill_pet_projects.sh
    bootstrap.sh
    template_snapshot/

Responsibility model:

- `init.sh`: create the module directory structure safely
- `fill_readme.sh`: create or sync the root `README.md`
- `fill_learning_materials.sh`: create or sync `learning-materials/`
- `fill_simple_tasks.sh`: create or sync `simple-tasks/`
- `fill_pet_projects.sh`: create or sync `pet-projects/`
- `bootstrap.sh`: run the full module flow in the right order
- `template_snapshot/`: source of truth for mature snapshot-backed modules

Typical module bootstrap order:

1. `init.sh`
2. `fill_readme.sh`
3. `fill_learning_materials.sh`
4. `fill_simple_tasks.sh`
5. `fill_pet_projects.sh`

## Section Generator Structure

Each generator-backed top-level section lives under:

    scripts/sections/<section>/

Current sections:

- `docs/`
- `shared/`
- `ai-learning/`
- `real-projects/`

Typical contents:

    init.sh
    fill_readme.sh
    fill_content.sh
    bootstrap.sh
    template_snapshot/

Responsibility model:

- `init.sh`: create the section root safely
- `fill_readme.sh`: create or sync root `README.md`
- `fill_content.sh`: sync all remaining content from snapshot into the live section
- `bootstrap.sh`: run the full section flow in the right order
- `template_snapshot/`: source of truth for the section content

Typical section bootstrap order:

1. `init.sh`
2. `fill_readme.sh`
3. `fill_content.sh`

## Why Modules And Sections Differ

Modules have a stable internal pedagogical shape:

- `learning-materials/`
- `simple-tasks/`
- `pet-projects/`

Top-level sections do not share that shape.

So sections use a simpler split:

- create root safely
- sync README
- sync the rest of the section

This keeps both layers consistent without forcing section content into module conventions.

## Snapshot-Based Pattern

For mature generator-backed units, `template_snapshot/` is the generator source of truth.

That means:

- you usually edit snapshot first
- then bootstrap the live output
- then validate sync with `check_repo.sh`

This pattern is already used by:

- mature modules in `scripts/sections/modules/`
- top-level sections in `scripts/sections/`

## Safe-Mode Rules

The scripts system is intentionally additive and conservative.

Main rules:

- do not overwrite manual work blindly
- create directories only if needed
- create files only if needed
- keep generator orchestration predictable
- separate learner-managed state from generator-managed content

Why this matters:

- many repository areas are manually curated after generation
- destructive regeneration would make the system unsafe to use daily

## Shared Libraries

Shared shell helpers live under:

    scripts/lib/

Current files:

- `common.sh`
- `fs.sh`
- `section.sh`

Typical purposes:

- logging and fatal error helpers
- safe file and directory operations
- repository-root and section-root path helpers

Use these helpers when building or refactoring generator scripts instead of duplicating shell logic.

## Current Structure Summary

Current top-level scripts tree:

    scripts/
    ├── README.md
    ├── bootstrap_section.sh
    ├── check_repo.sh
    ├── create_module.sh
    ├── create_section.sh
    ├── refresh_template_snapshots.sh
    ├── lib/
    ├── sections/
    └── structure.md

Current top-level section generators:

    scripts/sections/docs/
    scripts/sections/shared/
    scripts/sections/ai-learning/
    scripts/sections/real-projects/

Current module generators live under:

    scripts/sections/modules/

## Recommended Usage Rules

### If you are editing generator source content

Edit `template_snapshot/` first.

Then run the corresponding bootstrap command.

### If you are editing live generated content on purpose

Promote it back into snapshot with `refresh_template_snapshots.sh`.

Then run validation.

### If you changed shell generation logic

Run:

    ./scripts/check_repo.sh

before considering the work done.

### If you are adding a new module or section

Use the scaffold script first instead of creating the structure manually.

## Minimal Command Reference

Most common day-to-day commands:

    ./scripts/bootstrap_section.sh modules 01-python
    ./scripts/bootstrap_section.sh docs
    ./scripts/bootstrap_section.sh all
    ./scripts/refresh_template_snapshots.sh 01-python
    ./scripts/refresh_template_snapshots.sh docs
    ./scripts/check_repo.sh
    ./scripts/check_repo.sh modules
    ./scripts/check_repo.sh sections
    ./scripts/create_module.sh 16-new-module
    ./scripts/create_section.sh shared

## Final Rule

Treat `scripts/` as the automation layer of the repository, not as a folder of unrelated shell files.

If a script changes structure, generation flow, or snapshot rules, validate the whole affected layer before moving on.
