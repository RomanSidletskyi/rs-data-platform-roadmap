# Git For Data Engineers, Infrastructure, And Platform Repositories

## Why This Topic Matters

Git behavior is shaped by repository type.

## Common Repository Types

- application code repo
- infrastructure repo
- workflow repo
- dbt repo
- mono-repo with mixed assets

## Special Risks In Data And Platform Repos

- generated artifacts
- credentials and environment files
- large datasets
- automation side effects

## Key Architectural Takeaway

Git is often the control plane for platform change. That means repository discipline affects deploy safety.