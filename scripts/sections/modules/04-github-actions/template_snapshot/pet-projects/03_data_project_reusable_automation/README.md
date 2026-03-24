# 03 Data Project Reusable Automation

## Goal

Design reusable GitHub Actions automation for a multi-repository data project.

## Scenario

Several data repositories repeat the same validation pattern: Python checks, SQL validation, packaging, and artifact publishing. You want one reusable design instead of copy-pasted workflows.

## What You Should Build

- one reusable workflow for shared validation
- one local caller workflow in the repository
- optional composite action for a smaller repeated step bundle
- artifact hand-off between stages where appropriate

## Recommended Deliverables

- `.github/workflows/reusable-validate.yml`
- `.github/workflows/ci.yml`
- optional composite action folder
- short design note: reusable workflow vs composite action

## Completion Criteria

- repeated logic is centralized
- repository-specific logic stays local
- the design remains understandable for teams that inherit the repo later