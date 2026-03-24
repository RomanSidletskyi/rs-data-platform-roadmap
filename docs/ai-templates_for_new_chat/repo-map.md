# Repository Map – rs-data-platform-roadmap

This document describes the structure of the repository and the current status of modules.

The goal of this repository is to build a structured learning roadmap for
Data Engineering and Data Platform Architecture.

--------------------------------------------------

Repository Root Structure

    repo/
        00-shell-linux/
        00-git/
        01-python/
        02-sql/
        shared/
        docs/
        scripts/

--------------------------------------------------

Modules

Technology modules are numbered and represent the learning roadmap.

Each module follows the same internal structure.

    module/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

--------------------------------------------------

Module Structure Details

README.md

The module README acts as the entry point.

It should explain:

- what the technology is
- why it matters in data platforms
- what the module covers
- how to navigate learning materials
- how tasks are organized
- how projects simulate real engineering workflows

--------------------------------------------------

learning-materials

This directory contains theoretical content and architecture explanations.

Examples:

- architecture explanations
- technology comparisons
- design patterns
- documentation references
- blog articles
- external learning resources

Architecture explanations are very important because the goal is to understand
how technologies fit into real data platforms.

--------------------------------------------------

simple-tasks

This directory contains practical exercises.

Tasks are grouped by topic.

Example structure:

    simple-tasks/
        01_variables_conditions_loops/
        02_functions_modules/
        03_work_with_files_csv_json/
        04_requests_and_api/
        05_error_handling_logging/
        06_virtualenv_and_project_setup/
        07_pandas_basics/
        08_data_engineering_python_tasks/

Each topic folder contains a README.md with multiple tasks.

Task format:

    ## Task 1 — Task Name

    ### Goal

    ### Input

    ### Requirements

    ### Expected Output

    ### Extra Challenge

Optional sections may include:

    Hints
    Files
    Notes

--------------------------------------------------

pet-projects

Pet projects simulate real data engineering workflows.

Projects usually include:

    project/
        README.md
        architecture.md
        config/
        src/
        tests/
        docker/
        data/

These projects simulate real engineering problems such as:

- API ingestion
- log parsing
- data validation
- pipeline orchestration
- incremental ingestion

--------------------------------------------------

Shared Resources

The repository includes a shared directory used by multiple modules.

    shared/
        datasets/
        schemas/
        docker/
        configs/
        environments/
        scripts/
        notebooks/
        testing/
        architecture/
        templates/

Rule:

If a resource is used by two or more modules, it should be placed in shared.

Examples:

    shared/datasets/sample
    shared/schemas/sql
    shared/configs/templates

Modules should reference shared resources instead of duplicating files.

If datasets are large, the repository should include download links instead
of storing large files directly.

--------------------------------------------------

Documentation

    docs/
        ai-templates_for_new_chat/

Documentation contains:

- AI context for new chats
- repository structure description
- rules for module generation
- formatting rules

--------------------------------------------------

Scripts

The repository uses automation scripts to generate module structures.

    scripts/
        bootstrap_section.sh
        bootstrap_all.sh
        create_module.sh
        lib/
        sections/

Inside sections:

    scripts/sections/modules/<module>/

Each module has automation scripts.

    init.sh
    fill_readme.sh
    fill_learning_materials.sh
    fill_simple_tasks.sh
    fill_pet_projects.sh
    bootstrap.sh

Script responsibilities:

init.sh

    builds the entire folder structure of the module

fill_readme.sh

    generates the module README

fill_learning_materials.sh

    generates learning material files

fill_simple_tasks.sh

    creates task folders and task README files

fill_pet_projects.sh

    creates the initial project structure

bootstrap.sh

    runs all scripts in order to create a fully initialized module

Some finished modules are now generator-backed through a snapshot-based pattern where `template_snapshot/` is the source of truth and `fill_*` scripts copy curated content from it.

Current generator-backed modules:

- `00-shell-linux/`
- `00-git/`
- `02-sql/`
- `03-docker/`
- `04-github-actions/`
- `11-airflow/`
- `12-dbt/`
- `15-raspberry-pi-homelab/`

--------------------------------------------------

Foundational Modules

00-shell-linux

- shell and Linux operational foundation
- command-line, processes, permissions, SSH, scripting

00-git

- repository history and workflow foundation
- branches, remotes, diffs, recovery, PR-oriented work

--------------------------------------------------

Current Module Status

01-python

- simple-tasks mostly ready
- pet-projects mostly ready
- learning-materials structure exists but content needs to be added
- external links and shared references still need to be added

--------------------------------------------------

02-sql

- learning-materials mostly complete
- simple-tasks mostly ready
- pet-projects mostly ready
- external resources and shared references still need to be added

--------------------------------------------------

Documentation

docs

- documentation structure exists
- AI templates exist
- repository rules documented

--------------------------------------------------

Shared

shared

- directory structure exists
- README files exist
- datasets and resources still need to be populated
- download links still need to be added

--------------------------------------------------

Current Script-Backed Modules

The following modules already have active script-backed generation or active curated scope.

03-docker
04-github-actions
05-confluent-kafka
06-spark-pyspark
07-databricks
08-delta-lake
09-azure-data-lake-storage
11-airflow
12-dbt

--------------------------------------------------

Planned Placeholder Modules

The following directories already exist, but they are intentionally being kept as planned placeholders for later learning passes.

10-powerbi-fabric
13-flink
14-iceberg

--------------------------------------------------

Repository Philosophy

This repository is designed as a structured learning roadmap.

The objective is to gradually move from beginner knowledge
to the ability to design complete data platforms.

The repository focuses on:

- architecture understanding
- practical exercises
- realistic engineering projects
- system-level thinking

The goal is not only to learn tools but to understand how
technologies work together in modern data platforms.