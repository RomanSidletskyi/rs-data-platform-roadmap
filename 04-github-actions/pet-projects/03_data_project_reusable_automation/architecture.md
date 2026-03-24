# Architecture

## Problem Boundary

This project models organizational scale, not just a single repository pipeline.

## Suggested Split

- reusable workflow for full validation graph
- composite action only for small reusable mechanics
- local workflow as the repository-facing entry point

## Example Boundary

Reusable workflow owns:

- setup
- validation jobs
- artifact upload

Repository workflow owns:

- triggers
- repo-specific inputs
- environment-specific branching

## Risks To Avoid

- turning every small repetition into a reusable workflow
- hiding repository-specific decisions inside a shared automation layer