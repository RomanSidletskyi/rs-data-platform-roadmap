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

The goal of learning-materials is not only to explain syntax or commands.

They must help the learner build:

- conceptual understanding
- practical intuition
- architectural judgment

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

# Learning Materials Blueprint

learning-materials should combine three perspectives:

- concept
- architecture
- cookbook

This repository is designed for a learner who is practical-first, but who also wants to understand the final architectural meaning of a tool.

That means learning-materials should not be only abstract theory and should not be only copy-paste examples.

They should connect:

- what a technology is
- where it fits in a platform
- how it is used in realistic engineering workflows
- what breaks when it is misused

Preferred learning-material file types:

- concept files
- architecture files
- cookbook files

These do not need to be separated mechanically in every module, but the learning block as a whole must cover all three perspectives.

## Concept Files

Concept files should explain:

- what the technology or feature is
- why it exists
- what problem it solves
- what it is not
- core mental model

The learner should leave the file understanding the language of the topic.

## Architecture Files

Architecture files should explain:

- where the technology fits in a data platform
- system boundaries and ownership
- what it should own
- what it should not own
- trade-offs
- anti-patterns
- production failure modes when relevant

The learner should leave the file understanding how to reason about the technology in a larger system.

## Cookbook Files

Cookbook files should explain how realistic solutions are shaped.

They should include:

- a realistic scenario
- a compact but practical example
- explanation of why the example is shaped this way
- notes about boundaries, trade-offs, or failure risks

Cookbook files are not meant to be random code dumps.

They should help the learner move from:

- theoretical understanding
- practical intuition
- architectural recognition

## Preferred Internal Structure For A Learning File

When relevant, a learning-material file should use a structure similar to:

- why this topic matters
- what it is
- what it is not
- role in architecture
- good strategy
- bad strategy
- why bad is bad
- small cookbook example
- production-shaped example
- common failures or anti-patterns
- key architectural takeaway

Not every file must contain every section.

However, across a module, the learner should repeatedly see this style of explanation.

## Learning Materials Quality Standard

Good learning-materials should do all of the following:

- explain the core idea in simple language
- show one or more realistic examples
- make architectural boundaries visible
- explain trade-offs and misuse cases
- help the learner connect code to system design

Target outcome:

- theory gives language
- cookbook gives intuition
- architecture gives judgment

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

Each simple-task topic folder should also include:

    solution.md

The solution is used for:

- later self-checking
- comparison after independent attempt
- preserving a known-good answer shape

Simple tasks should follow the same educational logic used in the Docker module:

- focused hands-on practice
- increasing realism across topics
- practical outputs, not only theoretical answers
- optional extra challenge or hard mode when useful

The learner should be able to move directly from a learning-material topic into a matching simple-task topic.

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

Main rule:

The primary pet-project folder should be a guided project.

That means:

- the learner builds the implementation by following README.md
- architecture.md defines the target shape and trade-offs
- sample assets such as input data, config, and env examples may be provided
- ready-made implementation code should not be placed in the main guided project unless the learning goal explicitly requires it

Optional pattern:

If a reference example is useful for later comparison, create a separate sibling folder named:

    reference_example_<project-name>/

The reference example is not the main assignment.

It is used for:

- self-checking after the learner attempts the project
- preserving a known-good implementation
- establishing a reusable design pattern for future pet modules

Guided projects may include starter notes inside:

    src/README.md
    tests/README.md
    docker/README.md

These starter notes should explain what the learner must implement.

The main guided project README.md should include:

- project goal
- scenario
- project type (guided project)
- starter assets already provided
- expected deliverables
- recommended implementation plan
- implementation requirements
- validation ideas
- definition of done
- possible improvements

Pet projects should follow the same educational logic used in the Docker module:

- the main folder is the learner's build space
- the README explains what to build, not a fully pre-solved implementation
- architecture.md explains the target shape and system reasoning
- starter assets may reduce setup friction without removing the implementation work
- reference examples are optional comparison artifacts, not the main path

The architecture.md file should include:

- components
- data flow
- storage model
- configuration model
- trade-offs
- target outputs when relevant
- what would change in production

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