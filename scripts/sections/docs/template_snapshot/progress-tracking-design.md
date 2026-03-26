# Progress Tracking Design

This document defines the proposed progress-tracking system for the repository.

It is a design and alignment document first.

It does not yet create the final tracker files for every module.

## Goal

The goal is to make learning progress visible without turning the repository into a maintenance burden.

The tracker should answer these questions quickly:

- what has not been started yet
- what is currently in progress
- what is finished enough to move on from
- how much time was spent on each meaningful part
- what the next step is

## Design Principle

Track meaningful learning units, not every file.

If the tracker is too granular, it will be abandoned.

If it is too coarse, it will stop being useful.

The right default level is:

- repository level: one row per module
- module level: one row per meaningful block inside that module

## Proposed File Layout

After alignment, the system should use:

- one global tracker in `docs/learning-progress.md`
- one local tracker in each module root as `PROGRESS.md`

Examples:

- `00-shell-linux/PROGRESS.md`
- `01-python/PROGRESS.md`
- `02-sql/PROGRESS.md`
- `15-raspberry-pi-homelab/PROGRESS.md`

## Status Standard

Use only three statuses:

- `not started`
- `in progress`
- `done`

Represent them in files with checkbox-style markers:

- `[x]` = current state
- `[ ]` = not the current state

Recommended inline shape:

- `status: [x] not started | [ ] in progress | [ ] done`

Why only three:

- they are easy to read quickly
- they are easy to maintain consistently
- they avoid fake precision

### Status Meaning

`not started`

- the block has not been worked through seriously yet

`in progress`

- work has started, but the block is not complete enough to move on confidently

`done`

- the block has been worked through, key tasks were completed, and the learner can continue forward

## Checkbox Convention

Use checkbox-style status fields for both:

- module summary fields such as `overall`
- block-level fields such as `status`

Examples:

- `overall: [ ] not started | [x] in progress | [ ] done`
- `status: [ ] not started | [ ] in progress | [x] done`

This keeps the tracker visually scannable while still preserving the three-state model.

## Time Tracking Standard

Track two time fields:

- `estimated`
- `spent`

Why both matter:

- `estimated` helps plan the path ahead
- `spent` shows actual learning cost
- comparing them exposes where complexity was underestimated

Use simple human-readable units such as:

- `1h`
- `2.5h`
- `45m`

Do not track time at minute-level precision unless there is a strong reason.

## Module-Level Tracker Design

Each module `PROGRESS.md` should track:

- learning block or section name
- status
- estimated time
- spent time
- last touched date
- short note
- next step

But the file should not be one flat list.

It should be split into three major sections that match the repository structure:

- `learning-materials`
- `simple-tasks`
- `pet-projects`

That makes the tracker easier to use during real study sessions because you can update the exact area you worked on.

### Recommended Granularity

Use meaningful blocks inside each of the three module areas.

#### In `learning-materials`

Track top-level topic blocks, not every markdown file.

Good examples:

- fundamentals
- files and JSON
- API work
- testing and logging
- packaging and environment
- data engineering focus

#### In `simple-tasks`

Track task groups or topic folders.

Good examples:

- 01 variables conditions loops
- 02 functions modules
- 03 work with files CSV JSON

#### In `pet-projects`

Track guided project folders and optionally reference examples only when they matter to your learning path.

Good examples:

- 01 api to csv pipeline
- 02 json normalizer
- reference example api to csv pipeline

Do not track every single markdown chapter or every tiny helper file by default.

## Global Tracker Design

The global tracker should summarize module-level reality, not duplicate every local row.

Each module entry should include:

- module name
- overall status
- learning-materials status
- simple-tasks status
- pet-projects status
- total spent time
- last updated
- short note

The global file should help answer:

- which module to study next
- where the main bottleneck is
- how much real time each module consumed

## Recommended Markdown Shape

The default format should be easy to scan and easy to edit manually.

For this repository, block-style Markdown is a better default than wide tables.

### Global Tracker Example

```md
## 01-python

- overall: [ ] not started | [x] in progress | [ ] done
- learning-materials: [ ] not started | [ ] in progress | [x] done
- simple-tasks: [ ] not started | [x] in progress | [ ] done
- pet-projects: [x] not started | [ ] in progress | [ ] done
- spent: 18h
- last updated: 2026-03-24
- note: Strong on theory, still finishing tasks

## 02-sql

- overall: [x] not started | [ ] in progress | [ ] done
- learning-materials: [x] not started | [ ] in progress | [ ] done
- simple-tasks: [x] not started | [ ] in progress | [ ] done
- pet-projects: [x] not started | [ ] in progress | [ ] done
- spent: 0h
- last updated: -
- note: Not started yet
```

### Module Tracker Example

```md
# 01-python Progress

## Learning Materials

### Fundamentals

- status: [ ] not started | [ ] in progress | [x] done
- estimated: 4h
- spent: 5h
- last touched: 2026-03-24
- note: Finished first pass and review notes
- next step: Revisit only if later gaps appear

### Files and JSON

- status: [ ] not started | [x] in progress | [ ] done
- estimated: 3h
- spent: 2h
- last touched: 2026-03-24
- note: Theory done, tasks partly done
- next step: Finish file-handling notes and review patterns

### API Work

- status: [x] not started | [ ] in progress | [ ] done
- estimated: 5h
- spent: 0h
- last touched: -
- note: Not started
- next step: Begin learning-materials block

## Simple Tasks

### 01 Variables Conditions Loops

- status: [ ] not started | [ ] in progress | [x] done
- estimated: 2h
- spent: 2.5h
- last touched: 2026-03-24
- note: Solved and reviewed
- next step: None

### 02 Functions Modules

- status: [ ] not started | [x] in progress | [ ] done
- estimated: 2h
- spent: 1h
- last touched: 2026-03-24
- note: Started tasks, solution review still missing
- next step: Finish remaining tasks and self-check

## Pet Projects

### 01 API To CSV Pipeline

- status: [x] not started | [ ] in progress | [ ] done
- estimated: 6h
- spent: 0h
- last touched: -
- note: Waiting until API work block is stronger
- next step: Start after API work and logging sections
```

## Recommended Module File Shape

The default `PROGRESS.md` inside a module should look like this:

1. module title
2. short module summary fields
3. `Learning Materials` section
4. `Simple Tasks` section
5. `Pet Projects` section

Optional summary fields at the top:

- overall status
- total estimated
- total spent
- last updated
- current focus

## Optional Table Variant

If you later want a denser summary view, tables can still be used in the global file.

But they should be treated as an optimization for overview, not as the default authoring format.

## Completion Rule

A block should not be marked `done` only because files exist in the repository.

It should be marked `done` when the learner has actually worked through that block enough to continue without pretending.

That means:

- theory was read actively
- tasks were attempted or reviewed honestly
- project work was completed or intentionally deferred with a clear reason

For modules, the same rule applies separately to:

- learning-materials progress
- simple-tasks progress
- pet-projects progress

This prevents a module from looking finished only because one area moved faster than the others.

## Update Rules

To keep the tracker useful, updates should be lightweight.

Recommended rule:

- update the local `PROGRESS.md` when finishing a study session or closing a meaningful block
- update the global tracker when a module-level status changed materially

Do not update the global file for every tiny movement.

## Notes Standard

Notes should stay short.

Good notes:

- `Need more work on joins and aggregation grain`
- `Theory is done, tasks still weak`
- `Pet project completed, but smoke checks still not reviewed manually`

Bad notes:

- long diary-style descriptions
- repeated summaries that should live in another document

## Next Step Standard

Every in-progress row should have a concrete next step.

Good examples:

- `Finish task block 03`
- `Build pet project 01 first draft`
- `Revisit testing section and add missing notes`

This keeps the tracker actionable rather than purely descriptive.

## Roll-Up Logic

When the actual files are created later, the global tracker should use simple roll-up logic:

- if all three main module areas are `done`, overall module status can be `done`
- if any meaningful area is `in progress`, module is usually `in progress`
- if nothing has started, module is `not started`

This should remain a human judgment rule, not a strict automation rule.

## Future Automation Possibility

Later, if needed, a small script can be added to:

- create `PROGRESS.md` from a module template
- scaffold the global tracker rows from the module list
- validate that every module has a `PROGRESS.md`

But the first version should stay plain Markdown and easy to edit manually.

## Recommended First Rollout

After approval, the rollout should happen in this order:

1. create `docs/learning-progress.md`
2. create one reusable `PROGRESS.md` template structure
3. create `PROGRESS.md` in every module root
4. prefill each module with its meaningful blocks
5. leave all initial statuses as `not started` unless the user wants current progress prefilled

## Final Rule

This system should reduce ambiguity, not create admin work.

If maintaining the tracker starts taking too much effort, the granularity is too high and should be reduced.