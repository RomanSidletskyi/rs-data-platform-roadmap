# Reference Example — Docker Image CI/CD

This folder is a solved reference implementation for the guided Docker CI/CD project.

## What This Example Shows

- PR-time test and Docker build validation
- post-merge image publishing to GHCR
- immutable image tagging based on commit SHA
- clean separation between validation and release

## How To Read It

1. inspect the application in `src/`
2. inspect the tests in `tests/`
3. inspect `docker/Dockerfile`
4. compare `docker-validate.yml` with `docker-release.yml`

## Main Lesson

The same repository can have one workflow for safe validation and another for controlled release without collapsing both concerns into one giant file.