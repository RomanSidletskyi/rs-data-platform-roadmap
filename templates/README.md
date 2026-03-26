# Templates

This directory contains templates that define the documentation standard for key artifacts in the repository.

Its purpose is not to add another layer of formality.

Its purpose is to ensure that modules, tasks, and projects across the repository are:

- consistent
- easy to read
- easy to extend
- suitable both for learning and for portfolio use

## Why Templates Matter

As the repository grows, the same problems appear without templates:

- different modules are described in different styles
- README files miss important context
- it becomes unclear what exactly should be done in a task or project
- new sections have to be reinvented each time
- the shared logic between theory, tasks, projects, and architecture notes starts to break down

Templates reduce that chaos.

They provide a minimum quality structure that can then be adapted for a specific module or project.

## What This Directory Provides

The practical value of `templates/` is that it:

- speeds up creation of new modules and sections
- reduces the number of empty or weakly structured README files
- helps maintain a consistent quality bar across the repository
- supports the generator/snapshot approach because the expected output shape is clearer
- makes the repository more professional as both a learning system and a portfolio

## What Each Template Is For

### `learning-module-readme-template.md`

Used for the main `README.md` inside a specific technology module.

Use it when:

- you are creating a new module
- you are rebuilding an older module whose README is too weak or chaotic

What it defines:

- why the module exists
- what role the technology plays in a data platform
- expected learning outcomes
- how to work through the module
- how the module connects to other modules

What this gives you:

- the module stops being just a folder with files
- it creates a clear entry point for learning
- it becomes easier to understand why this topic sits where it does in the roadmap

### `task-readme-template.md`

Used for `README.md` files in `simple-tasks/` folders or in focused task blocks.

Use it when:

- you are creating a new block of practice tasks
- you want the tasks to train reasoning, not only theory recall

What it defines:

- the learning goal of the block
- rules for working through the tasks
- the structure of the tasks
- a required scenario or failure-mode element
- a self-check after completion

What this gives you:

- tasks do not turn into a random list of exercises
- the guided-first approach is preserved
- it becomes easier to keep a consistent level of difficulty and quality across modules

### `pet-project-readme-template.md`

Used for guided pet projects inside modules.

Use it when:

- you are creating a new pet project
- you want it to be a guided build rather than a ready solution

What it defines:

- the project goal
- a realistic scenario
- starter assets
- expected deliverables
- an implementation plan
- definition of done

What this gives you:

- the pet project has a clear execution path
- the learner knows what is already provided and what must be built independently
- the project scales more cleanly into a reference example or smoke-check flow

### `pet-project-architecture-template.md`

Used for `architecture.md` files in guided pet projects.

Use it when:

- the target structure of the solution needs to be described separately
- the README becomes overloaded with architecture details

What it defines:

- system components
- data flow
- storage, configuration, and network model
- responsibility boundaries
- trade-offs
- differences between the learning version and a production version

What this gives you:

- the project teaches not only how to build it, but why it is designed that way
- architecture thinking is separated from step-by-step execution guidance

### `reference-example-readme-template.md`

Used for solved reference examples placed next to guided projects.

Use it when:

- there is a ready reference implementation for comparison
- you need to clearly separate guided practice from the solved example

What it defines:

- the purpose of the reference example
- how to run it
- what exactly should be compared with your own solution

What this gives you:

- the learner does not confuse the learning project with the ready answer
- the reference example becomes a self-check tool instead of a copying shortcut

### `real-project-readme-template.md`

Used for README files in `real-projects/`.

Use it when:

- you are creating a cross-technology project
- you want to describe a platform-oriented implementation rather than a local exercise

What it defines:

- the multi-technology scenario
- the architecture shape
- scope and non-goals
- deliverables
- milestones
- definition of done

What this gives you:

- real projects do not collapse into a loose set of random ideas
- boundaries, phases, and architectural intent become visible
- it becomes easier to turn the project into a portfolio artifact

### `module-progress-template.md`

Used for `PROGRESS.md` files in module roots.

Use it when:

- you are creating a new module-level progress tracker
- you want one consistent shape for tracking theory, tasks, and projects

What it defines:

- module summary fields
- a `Learning Materials` section
- a `Simple Tasks` section
- a `Pet Projects` section
- standard fields for status, time, notes, and next step

What this gives you:

- progress tracking stays consistent across modules
- the learner can update theory, tasks, and projects separately
- the repository gets a common learning-tracker language instead of ad hoc notes

### `rs-data-platform-roadmap.code-workspace`

This is not a content template but a VS Code workspace file.

It lives here as a supporting artifact for working with the repository in a stable editor setup.

## How To Use Templates Correctly

The basic approach is:

1. Choose the template that matches the artifact type.
2. Copy its structure into the new file.
3. Replace placeholders only after you understand the purpose of each section.
4. Do not leave service markers like `<Module Name>` in the final file.
5. Remove sections that add no value in the specific case.
6. Add sections if the real context requires them.
7. Check that the file explains not only what something is, but why it exists and how it should be used.

## Important Rule

Templates should not be copied mechanically.

They should be used as a quality structure.

If a template is copied without adaptation, the usual symptoms are:

- filler text instead of substance
- generic statements without specifics
- sections that exist formally but explain nothing
- a README that looks complete but is not actually useful

Proper template usage means:

- keep the strong structure
- remove what is unnecessary
- add context for the specific module or project

## When To Update The Templates Themselves

Update a template when you see the same structural problem repeated in several parts of the repository.

Examples:

- many README files consistently miss a trade-offs section
- tasks across different modules do not include failure-mode thinking
- real projects describe scope and non-goals poorly
- guided projects do not clearly separate starter assets from what the learner must implement independently

In that case, it is better to improve the template once than patch dozens of files individually.

## Practical Selection Guide

If you are creating:

- a new technology module: use `learning-module-readme-template.md`
- a block of short practice tasks: use `task-readme-template.md`
- a guided project inside a module: use `pet-project-readme-template.md`
- an architecture description for a guided project: use `pet-project-architecture-template.md`
- a solved comparison folder: use `reference-example-readme-template.md`
- a larger cross-technology project: use `real-project-readme-template.md`
- a module-level progress tracker: use `module-progress-template.md`

## Summary

`templates/` defines a shared language for the whole repository.

This is where the repository captures not only document structure, but also the learning approach itself:

- guided-first
- architecture-aware
- scenario-based
- portfolio-ready

If the templates stay in good shape, the whole repository becomes easier to scale without losing quality.