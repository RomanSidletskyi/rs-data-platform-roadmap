# Repository Creation, Status, And First Commits

## Why This Topic Matters

Healthy repository work starts with small clear changes and a clean status model.

## Core Commands

    git init
    git status
    git add .
    git commit -m "Create initial project structure"
    git log --oneline --decorate

## Good Strategy

- create the repo intentionally
- make the first commit small and structural
- keep the working tree clean between logical units of work

## Bad Strategy

- initialize a repo after a lot of unrelated messy work
- include generated files immediately without ignore rules

## Cookbook Example

After `git init`, create a README and verify state:

    git status
    git add README.md
    git commit -m "Add README"
    git status

The final status should be clean.