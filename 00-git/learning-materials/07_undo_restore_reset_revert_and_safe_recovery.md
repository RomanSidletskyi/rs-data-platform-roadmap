# Undo, Restore, Reset, Revert, And Safe Recovery

## Why This Topic Matters

Every Git learner eventually needs recovery.

## Core Commands

    git restore path/to/file
    git restore --staged path/to/file
    git reset --soft HEAD~1
    git reset --mixed HEAD~1
    git revert HEAD
    git reflog

## Recovery Logic

- use `restore` for working tree or staged state repair
- use `revert` when history is already shared and needs a safe reverse commit
- use `reset` only when you understand its effect on staging and history

## Dangerous Command

    git reset --hard

This can destroy uncommitted work.

## Key Architectural Takeaway

Recovery is safer when you identify exactly which layer is wrong: working tree, staging area, or commit history.