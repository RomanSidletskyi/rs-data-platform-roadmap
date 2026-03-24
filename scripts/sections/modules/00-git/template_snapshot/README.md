# 00-git

This module teaches Git as the history, integration, and recovery system behind daily engineering work.

It is not just a command reference.

It is a practical path from first commits to production-minded repository workflows used in code, infrastructure, CI, and platform repositories.

## Why This Module Matters

Most later modules in the roadmap assume the learner can already:

- create and maintain clean branches
- inspect diffs and history confidently
- recover from mistakes without panic
- work with remotes and synchronize safely
- resolve conflicts deliberately
- follow a reviewable pull-request workflow

Without that foundation, collaboration and release automation become much riskier.

## Main Learning Goals

By the end of this module, the learner should be able to:

- explain the mental model behind working tree, staging area, commit, branch, HEAD, and remote
- inspect repository state and history without guessing
- use staging, diffs, and small commits intentionally
- manage branches, merges, rebases, and pull workflows safely
- recover from common mistakes using restore, reset, revert, and reflog
- design sane ignore rules and repository hygiene standards
- understand how Git supports PR review, CI, hotfixes, and release workflows
- think about Git as the control plane for engineering change

## Module Structure

    00-git/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

## Learning Philosophy

This module is also cookbook-heavy.

The learner should be able to stay inside the repository and still learn the workflows needed for normal professional Git usage.

That means the materials connect:

- what a Git concept is
- how it looks in real repository work
- which mistakes are dangerous
- how to recover when the history or working tree becomes messy

## Learning Materials

The learning block covers:

- Git mental model and object boundaries
- repository creation and early commit workflow
- staging, diff, history inspection, blame, and reflog
- branches, merges, remotes, and synchronization
- rebase and conflict reasoning
- undo and recovery patterns
- ignore rules and repository hygiene
- commit quality and PR workflow
- Git for data, infra, and platform repositories
- incident and conflict cookbooks

For the full path, see learning-materials/README.md.

## Simple Tasks

The simple tasks focus on doing Git work by hand:

- initialize a repository and build first history
- inspect unstaged and staged diffs
- branch and merge safely
- fetch, pull, push, and fix remote divergence
- rebase and resolve conflicts
- undo mistakes and recover state
- write ignore rules and clean repository outputs
- simulate PR-oriented workflows

Each task topic contains README.md and solution.md.

## Pet Projects

The guided projects simulate realistic repository operations work:

- personal repository hygiene lab
- team feature branch workflow lab
- incident recovery Git lab
- release and hotfix workflow lab

These are designed to teach confidence under repository stress, not only happy-path commits.

## Recommended Order Inside The Module

1. learn the mental model
2. practice local repo basics and diffs
3. add branches and remotes
4. learn rebase, conflicts, and safe undo
5. move into PR workflow and release reasoning
6. finish with incident-recovery scenarios

## Why This Comes After Shell/Linux

Git is easier when the learner already understands:

- paths and files
- text inspection
- environment variables
- remote shell and SSH
- command composition

Shell literacy reduces confusion around what Git is doing in the working tree.

## Related Modules

- 00-shell-linux
- 04-github-actions
- 11-airflow
- 12-dbt

## Completion Criteria

The module is complete when the learner can:

- explain repository state clearly
- create clean, reviewable commit history
- recover from common mistakes without destructive guessing
- resolve conflicts intentionally
- work with team workflows using branches, PRs, and remotes safely

## Final Note

This module should make Git feel like an understandable engineering system rather than a set of memorized rescue commands.