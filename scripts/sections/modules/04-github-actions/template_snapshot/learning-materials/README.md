# 04 GitHub Actions - Learning Materials Index

This folder is designed as a full learning path for someone who is new to GitHub Actions and needs both operational confidence and architectural judgment.

The goal is not to memorize YAML keys.

The goal is to understand:

- what GitHub Actions is responsible for
- what it should not be responsible for
- how workflow execution actually works
- how CI, release, and deploy boundaries should be designed
- how GitHub Actions fits into a broader data-platform architecture

## How To Use This Folder

Read the files in order.

The sequence is intentionally layered:

1. mental model first
2. execution model second
3. syntax and evaluation rules third
4. reuse and repository structure next
5. state, security, and artifact ownership after that
6. CI/CD and release architecture after the basics are stable
7. debugging, anti-patterns, and cross-platform integration at the end

If you skip the early files and jump straight into YAML snippets, the later files will feel harder than they actually are.

## Recommended Full Path

### Phase 1 - Understand The Tool

Start with:

- `01_github_actions_what_it_is_and_why_it_matters.md`
- `02_workflows_events_jobs_and_runners.md`

What you should know after Phase 1:

- what GitHub Actions is
- what a workflow, event, job, step, action, and runner are
- where GitHub Actions sits in repository architecture
- why it is usually a CI/CD control layer rather than a runtime platform

### Phase 2 - Learn The Language Of Workflows

Continue with:

- `03_workflow_syntax_contexts_and_expressions.md`
- `04_reusable_workflows_composite_actions_and_repo_structure.md`

What you should know after Phase 2:

- how `on`, `jobs`, `steps`, `needs`, `if`, and `matrix` work
- where values come from during execution
- the difference between GitHub expressions and shell interpolation
- when to use reusable workflows versus composite actions

### Phase 3 - Learn State, Ownership, And Security

Then study:

- `05_secrets_variables_artifacts_and_state.md`

What you should know after Phase 3:

- which values belong in `secrets`, `vars`, `env`, artifacts, or cache
- who owns configuration and sensitive values
- why CI/CD systems become dangerous when state ownership is unclear

### Phase 4 - Design Real Delivery Pipelines

Then move to:

- `06_ci_cd_patterns_for_data_projects.md`
- `07_release_automation_environments_and_deploy_strategy.md`

What you should know after Phase 4:

- how to split PR validation, build, release, and deploy paths
- how to use environments and approvals intentionally
- why immutable promotion matters more than just "making deploy pass"

### Phase 5 - Learn Failure Analysis And System Fit

Finish with:

- `08_debugging_security_and_common_failures.md`
- `09_github_actions_for_python_docker_and_data_platforms.md`
- `10_end_to_end_architecture_thinking_for_github_actions.md`

What you should know after Phase 5:

- how to debug workflow failures without guessing
- what common security and permissions mistakes look like
- how GitHub Actions integrates with Python, Docker, dbt, Airflow, and broader data-platform repos
- how to reason about end-to-end automation boundaries before writing workflow YAML

## What "Architecture Thinking" Means In This Module

In this module, architecture thinking means being able to answer questions like:

- should this run on pull request, on push, on schedule, or manually
- should this be one job or several jobs
- should this value be a variable, secret, artifact, or cache
- should this automation live in a workflow, a composite action, or a different tool entirely
- should this repository validate, package, deploy, or only trigger another system
- where is the safe boundary between CI and production mutation

That is the difference between copying YAML and actually designing automation.

## Suggested Study Loop

Use this loop for each topic:

1. read the learning file
2. summarize the mental model in your own words
3. inspect one example workflow and identify trigger, jobs, runner, and outputs
4. complete the matching simple task
5. return to the learning material and re-read the sections that now feel more concrete

## A Good Outcome For This Module

By the end of this folder, you should be able to:

- read a workflow file without panic
- design a clean CI workflow for a Python project
- separate validation, packaging, and deployment concerns
- reason about artifacts, secrets, and environments
- explain when GitHub Actions is the right tool and when another system should own the work

That is the standard this module is aiming for.