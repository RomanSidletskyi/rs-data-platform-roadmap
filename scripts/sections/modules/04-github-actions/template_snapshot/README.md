# GitHub Actions

This module introduces GitHub Actions as the main automation layer for CI, CD, validation, packaging, and release workflows around data projects.

The goal is not only to learn workflow YAML syntax.

The goal is to understand GitHub Actions as an engineering boundary:

- what it should automate
- what it should not own
- how it connects repositories, runners, secrets, artifacts, and environments
- how it supports Python, Docker, dbt, and platform workflows in a realistic delivery model

## Why It Matters

Writing code is not enough.

A useful data project also needs a repeatable way to:

- run tests before merge
- package or publish build artifacts
- validate Docker images and configs
- trigger deploy steps safely
- keep team workflows consistent

GitHub Actions is one of the most practical automation tools in the modern data stack because it often becomes the first production-like CI/CD system a learner actually touches.

It is also the fastest way to practice ideas such as:

- branch and pull-request quality gates
- matrix testing across versions
- reusable workflow design
- secure secret handling
- release automation
- deployment approvals and environment protection

## Main Learning Goals

By the end of this module, you should be able to:

- explain the difference between workflows, jobs, steps, actions, runners, artifacts, and environments
- build pull-request validation workflows for Python and Docker projects
- use events, conditions, matrices, and reusable workflows intentionally
- explain where secrets, variables, and artifacts belong
- debug failed workflows using logs, contexts, and execution boundaries
- design a safe deploy pipeline instead of one giant fragile workflow
- connect GitHub Actions to later modules such as Docker, Airflow, dbt, and homelab automation

## Prerequisites

Before starting this module, it helps to have:

- basic Git and GitHub familiarity
- basic Python knowledge
- basic Docker familiarity
- some intuition about CI, tests, packaging, or deployment steps

You do not need a complex cloud account for this module.

Most learning examples can be understood locally and reasoned about from repository structure, workflow contracts, and runner behavior.

## Module Structure

04-github-actions/

learning-materials/
simple-tasks/
pet-projects/

Each part has a different role:

- learning-materials explain concepts, architecture, and realistic workflow patterns
- simple-tasks provide focused hands-on CI/CD practice
- pet-projects combine multiple workflow concerns into guided automation projects

## Learning Structure

### Learning Materials

The learning-materials block combines three perspectives:

- concept
- architecture
- cookbook

Core topics include:

- what GitHub Actions is and where it fits
- event model, jobs, runners, and execution boundaries
- YAML syntax, expressions, contexts, and conditions
- artifacts, cache, secrets, and environment design
- reusable workflows and composite actions
- CI/CD patterns for Python, Docker, and data-platform repos
- security, debugging, and common failure modes

The goal is to build workflow judgment, not only memorize keys such as `uses`, `needs`, or `if`.

### Simple Tasks

The simple tasks move from basic workflow syntax to more realistic CI/CD design.

Topics include:

- first workflow
- events, conditions, and matrix builds
- Python validation pipelines
- Docker build and release workflows
- reusable workflows and artifact hand-off
- environments, security, and controlled deploys

Every simple-task topic folder includes both:

- `README.md`
- `solution.md`

### Pet Projects

The pet projects are guided projects, not ready solutions.

They are meant to simulate realistic automation work such as:

- Python quality automation
- Docker image CI/CD
- reusable automation for a shared data project
- production-style release and deployment automation

Some guided projects have separate `reference_example_*` siblings for later comparison.

Current guided projects:

- `01_python_quality_pipeline`
- `02_docker_image_ci_cd`
- `03_data_project_reusable_automation`
- `04_production_style_release_automation`

Current solved reference examples:

- `reference_example_python_quality_pipeline`
- `reference_example_docker_image_ci_cd`
- `reference_example_data_project_reusable_automation`
- `reference_example_production_style_release_automation`

These reference examples are not the main learning path.

The intended order is:

1. attempt the guided project first
2. compare only after building your own version

## Recommended Learning Path

Use this module in the following order:

1. understand what GitHub Actions is and what it should own
2. learn the event and execution model
3. study expressions, contexts, and conditional logic
4. practice one Python CI pipeline and one Docker workflow
5. learn reusable workflows, artifacts, and environment boundaries
6. only after that move into deploy and release automation patterns

Recommended first files:

1. `learning-materials/01_github_actions_what_it_is_and_why_it_matters.md`
2. `learning-materials/02_workflows_events_jobs_and_runners.md`
3. `learning-materials/03_workflow_syntax_contexts_and_expressions.md`
4. `learning-materials/05_secrets_variables_artifacts_and_state.md`
5. `learning-materials/06_ci_cd_patterns_for_data_projects.md`

For the full map, see `learning-materials/README.md`.

## Related Modules

- 01-python
- 03-docker
- 11-airflow
- 12-dbt
- 15-raspberry-pi-homelab

## Shared Resource Philosophy

If a GitHub Actions asset becomes reusable across more than one module, it should move into `shared/` rather than remain duplicated in one project.

Relevant shared areas already present in this repository:

- `shared/environments/use-github-env.md`
- `shared/environments/who-reads-what.md`
- `shared/configs/templates/airflow/`
- `shared/configs/templates/dbt/`

This module should help the learner decide when workflow YAML belongs inside one project and when it should become a reusable shared template.

## Completion Criteria

By the end of this module, you should be able to:

- explain the GitHub Actions execution model clearly
- write a clean pull-request validation workflow
- use matrices, conditions, caches, and artifacts intentionally
- distinguish a reusable workflow from a composite action
- explain how secrets and environments should be handled safely
- debug a failed workflow without guessing blindly
- design a small but credible CI/CD pipeline for a data project

## Optional Next Step

After this module, you can connect the workflows you design here to:

- Docker packaging from [03-docker](../03-docker/README.md)
- Airflow repository automation from [11-airflow](../11-airflow/README.md)
- dbt validation and deploy flows from [12-dbt](../12-dbt/README.md)
