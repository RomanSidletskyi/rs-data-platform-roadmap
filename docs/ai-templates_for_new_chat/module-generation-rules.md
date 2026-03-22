# Module Generation Rules – rs-data-platform-roadmap

This document describes how new modules should be generated in this repository.

These rules ensure consistency across all modules.

--------------------------------------------------

# Module Structure

Every module must follow the same structure.

    module/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

The goal is to separate:

- theory
- exercises
- realistic projects

Learning flow:

    learning-materials → simple-tasks → pet-projects

--------------------------------------------------

# Module README

Each module must contain a root README.md.

The README acts as a module index and entry point.

It should explain:

- what the technology is
- why it matters in data platforms
- what the module covers
- how to navigate learning materials
- how tasks are structured
- how projects simulate real data engineering work

The README should also reference shared resources if used.

--------------------------------------------------

# Learning Materials Rules

learning-materials contain theoretical content.

This includes:

- architecture explanations
- design patterns
- comparisons between technologies
- links to documentation
- links to blog posts
- links to external courses

Architecture explanations are extremely important.

Learning materials should explain:

- why a technology exists
- where it fits in a data platform
- how it interacts with other systems
- trade-offs compared to alternatives

Content should prioritize system understanding over isolated syntax examples.

--------------------------------------------------

# Simple Tasks Rules

Simple tasks provide hands-on exercises.

Tasks are grouped by topic.

Example:

    simple-tasks/
        01_variables_conditions_loops/
        02_functions_modules/
        03_work_with_files_csv_json/

Each folder contains a README.md with multiple tasks.

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

Tasks should be realistic and related to data engineering workflows.

--------------------------------------------------

# Pet Projects Rules

Pet projects simulate real data engineering work.

Projects should contain:

    project/
        README.md
        architecture.md
        config/
        src/
        tests/
        docker/
        data/

Projects should demonstrate:

- data ingestion
- data processing
- logging and monitoring
- pipeline design
- configuration management

Projects should reference shared resources if possible.

--------------------------------------------------

# Shared Resource Rules

The repository contains a shared directory used by multiple modules.

Rule:

If a resource is used by two or more modules, it should be placed in shared.

Examples:

    shared/datasets
    shared/schemas
    shared/configs
    shared/scripts

Modules should reference shared resources instead of duplicating files.

If datasets are large, the README should include a download link instead of storing the file in the repository.

--------------------------------------------------

# Scripts Automation Rules

Module structure is created automatically using scripts.

Each module must contain the following scripts:

    init.sh
    fill_readme.sh
    fill_learning_materials.sh
    fill_simple_tasks.sh
    fill_pet_projects.sh
    bootstrap.sh

Responsibilities:

init.sh

    builds the folder structure of the module

fill_readme.sh

    generates the module README

fill_learning_materials.sh

    creates learning material files

fill_simple_tasks.sh

    generates task folders and task README files

fill_pet_projects.sh

    creates the initial project structure

bootstrap.sh

    runs the full module setup

--------------------------------------------------

# External Resources

Learning materials may include references to:

- documentation
- blog posts
- architecture articles
- courses
- GitHub repositories

These should be used when they improve understanding.

--------------------------------------------------

# Markdown Formatting Rules

When generating Markdown files in chat responses:

Always use **4 spaces for code blocks**.

Example:

    module/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

Do not use triple backticks.

This prevents formatting issues when copying content into repository files.