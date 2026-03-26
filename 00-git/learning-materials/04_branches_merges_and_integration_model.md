# Branches, Merges, And Integration Model

## Why This Topic Matters

Branches are lines of work. Merges are integration events.

## Core Commands

    git branch
    git switch main
    git switch -c feature/add-readme
    git merge feature/add-readme

## Good Strategy

- keep branches focused
- merge coherent work, not unrelated leftovers

## Bad Strategy

- keep long-lived messy branches without syncing
- treat merge conflicts as accidental surprises instead of integration signals

## Key Architectural Takeaway

Branches reduce risk by isolating work. Merges reintroduce integration risk in a controlled way.