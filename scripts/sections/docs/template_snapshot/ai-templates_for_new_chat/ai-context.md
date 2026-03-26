# AI Context – rs-data-platform-roadmap

## Repository Goal

Structured learning roadmap for Data Engineering and Data Platform Architecture.

The goal is to progress from beginner to data platform architect by building modules, tasks, and projects.

--------------------------------------------------

## Core Learning Flow

Each module follows the structure:

    learning-materials
    simple-tasks
    pet-projects

learning-materials → theory and architecture

simple-tasks → practice

pet-projects → real engineering simulations

--------------------------------------------------

## Module Structure

    module/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

--------------------------------------------------

## Simple Tasks Format

Simple tasks are grouped by topic.

Each topic folder contains a README with multiple tasks.

Task format:

    ## Task 1 — Task Name

    ### Goal

    ### Input

    ### Requirements

    ### Expected Output

    ### Extra Challenge

Optional sections:

    Hints
    Files
    Notes

--------------------------------------------------

## Shared Resources

The repository contains a shared directory used by multiple modules.

Rule:

If a resource is used by two or more modules, it must be placed in shared.

Examples:

    shared/datasets
    shared/schemas
    shared/configs

Modules should reference shared resources instead of duplicating files.