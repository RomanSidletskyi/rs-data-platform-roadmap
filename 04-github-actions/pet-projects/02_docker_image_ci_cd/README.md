# 02 Docker Image CI/CD

## Goal

Build a GitHub Actions pipeline that validates and publishes a Docker image with explicit promotion boundaries.

## Scenario

You maintain a containerized service. Pull requests should prove the image can be built. Merges to `main` should publish a traceable image tag.

## What You Should Build

- PR workflow for Docker build validation
- publish workflow for main branch updates
- tag strategy with immutable identifiers
- a clear separation between validation and release

## Recommended Deliverables

- `.github/workflows/docker-validate.yml`
- `.github/workflows/docker-release.yml`
- `Dockerfile`
- a short tag strategy note

## Completion Criteria

- broken Docker changes fail before merge
- published images are traceable to a commit
- the workflow can be reasoned about without hidden release logic