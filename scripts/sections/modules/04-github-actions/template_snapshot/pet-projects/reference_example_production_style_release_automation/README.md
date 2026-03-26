# Reference Example — Production-Style Release Automation

This folder is a solved reference implementation for the guided release automation project.

## What This Example Shows

- PR validation before release work
- release packaging into a traceable manifest artifact
- protected deploy boundary through a `prod` environment
- clean artifact hand-off between package and deploy jobs

## How To Read It

1. inspect the manifest builder in `src/`
2. inspect the tests in `tests/`
3. inspect `validate.yml`
4. inspect `release.yml` and notice where package and deploy are separated

## Main Lesson

Production-style automation should preserve artifact identity and make deploy boundaries visible instead of hiding everything in one step.