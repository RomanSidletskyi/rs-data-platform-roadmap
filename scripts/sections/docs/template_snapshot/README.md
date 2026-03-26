# Docs

This directory is the repository-level navigation and architecture layer.

It exists to answer questions that individual technology modules should not answer alone:

- what order to study the modules in
- how the modules fit into a full data platform
- which cross-technology projects to build
- how to think about architecture, trade-offs, and system design beyond one tool
- how to start new AI-assisted sessions with the right repository context

This directory should behave like an information architecture, not like a loose pile of notes.

If a document belongs to repository planning, architecture study, decision practice, or AI session setup, that role should be obvious from the navigation.

## Core Reading Path

Start here when you want the repository-level map rather than one module:

1. `learning-sequence.md`
2. `learning-architecture.md`
3. `data-platform-map.md`
4. `data-platform-projects-roadmap.md`
5. `progress-tracking-design.md`

## Top-Level Zones

Use `docs/` through these four zones:

### 1. Repository Planning

Use these files when the question is "what should I study or build next":

- `learning-sequence.md`
- `learning-architecture.md`
- `data-platform-projects-roadmap.md`
- `learning-progress.md`
- `progress-tracking-design.md`

### 2. Platform Architecture Knowledge

Use these directories when the question is "how do platform layers, responsibilities, and trade-offs fit together":

- `data-platform-map.md`
- `architecture/`
- `system-design/`
- `trade-offs/`
- `case-studies/`

Inside `architecture/`, the learning loop is now deeper:

- topic READMEs for core concepts
- `anti-patterns.md` files for bad design recognition
- worked examples for one concrete scenario per topic
- `reviews/` for checklist-driven architecture review
- `adr/` for captured architecture decisions
- `synthesis/` for the full end-to-end learning path

### 3. Decision And Review Support

Use these when the goal is to turn architecture thinking into explicit comparison and review:

- `system-design/`
- `trade-offs/`
- `case-studies/`
- `architecture/reviews/`
- `architecture/adr/`

### 4. AI Session Context

Use this when you want to start a new AI session with stable repository framing:

- `ai-templates_for_new_chat/`

## Directory Map

- `architecture/`:
  platform architecture topics, anti-patterns, worked examples, review checklists, ADRs, and synthesis guide
- `system-design/`:
  canonical system-design notes, templates, and worked patterns
- `case-studies/`:
  structured case-study space for end-to-end platform scenarios
- `trade-offs/`:
  templates and examples for decision analysis
- `ai-templates_for_new_chat/`:
  context packs and prompting rules for starting productive AI sessions in this repository
- `learning-sequence.md`, `learning-architecture.md`, `data-platform-map.md`, `data-platform-projects-roadmap.md`:
  repository-level planning and orientation documents
- `progress-tracking-design.md`:
  proposed standard for module-level and repository-level learning progress tracking

## Canonical Rules

- `docs/system-design/` is the canonical system-design location
- `docs/architecture/` is the canonical architecture-learning location
- `docs/architecture/reviews/` is the canonical architecture-review checklist location
- `docs/architecture/adr/` is the canonical architecture-decision location
- top-level planning files stay at `docs/` root so repository-wide links remain stable

If two directories explain the same system-design patterns, the structure is wrong and should be simplified.

## How To Use Docs With Modules

Use module folders for depth in one technology.

Use `docs/` when you need to:

- connect several modules into one platform idea
- decide what to study next
- frame a pet project or real project as architecture, not only implementation
- capture trade-offs and design rationale

Recommended cross-layer loop:

1. use a module for local implementation depth
2. use `docs/data-platform-map.md` for platform context
3. use `docs/architecture/` to understand the design layer
4. use topic anti-patterns and worked examples to test your understanding
5. use `docs/case-studies/`, `docs/system-design/`, or `docs/trade-offs/` to structure the decision
6. use `docs/architecture/reviews/` to review the design critically
7. use `docs/architecture/adr/` or project notes to capture the chosen direction

## Strong Architecture Study Route

If your goal is architecture thinking rather than tool memorization, use this route:

1. `architecture/README.md`
2. one topic README in `architecture/`
3. that topic's `anti-patterns.md`
4. that topic's worked example
5. `case-studies/README.md`
6. `trade-offs/README.md`
7. `system-design/README.md`
8. `architecture/reviews/README.md`
9. `architecture/adr/template.md`
10. `architecture/synthesis/README.md`

## Current Scope Versus Future Scope

This repository currently has finished and actively curated modules through:

- `15-raspberry-pi-homelab`

Some roadmap notes in this directory also mention future platform layers such as data quality, observability, cloud architecture, and infrastructure as code.

Those are forward-looking roadmap placeholders, not current repository modules.

## Working Rule

If a document here stops matching the real repository structure, update the document.

These files are meant to be the operating map of the repository, not historical notes.