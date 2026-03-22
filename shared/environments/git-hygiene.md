# Git Hygiene

This note defines basic git hygiene rules for this repository.

It is intentionally short and practical.

## Core Rule

Git should contain:

- code
- documentation
- templates
- small sample assets

Git should not contain:

- real secrets
- runtime state
- logs
- local databases
- machine-specific overrides
- large generated outputs unless intentionally versioned

## Use Templates, Not Real Runtime Files

Commit:

- `.env.example`
- config templates
- sample settings with fake values

Do not commit:

- `.env`
- host-local config files
- private keys
- copied credentials from notes

## Keep Runtime State Outside The Repository

For local machine usage:

- keep secrets under a local config directory outside the repo

For Raspberry Pi usage:

- keep service secrets and runtime files under `/srv/rs-data-platform/`

## Before Every Commit

Quick checks:

```bash
git status
git diff --cached
```

Questions to ask:

- am I committing a real secret?
- am I committing a generated file by accident?
- am I committing local logs or runtime state?
- is this file a template or a machine-specific value?

## Safe Pattern

Use this pattern consistently:

- repo file: `.env.example`
- local runtime file: `.env`
- repo docs explain required variables

## Cross Reference

For secret placement rules, see:

- `shared/environments/secrets-management.md`