# Staging, Diff, And History Inspection Cookbook

## Why This Topic Matters

Git becomes useful when the learner can inspect state before changing it.

## Core Commands

    git diff
    git diff --staged
    git show HEAD
    git log --stat
    git log --oneline --graph --decorate
    git blame README.md
    git reflog

## Typical Questions And Commands

What changed but is not staged yet:

    git diff

What is already staged:

    git diff --staged

What happened in the last commit:

    git show HEAD

Who changed a specific line:

    git blame path/to/file

What recent HEAD moves happened:

    git reflog

## Good Strategy

- inspect before commit
- inspect before rebase
- inspect before undo

## Key Architectural Takeaway

Diff literacy is core engineering literacy in Git-based systems.