# Git Mental Model, Commits, Trees, And History

## Why This Topic Matters

Git is much easier when the learner understands the moving parts instead of memorizing rescue commands.

## Core Mental Model

Important pieces:

- working tree
- staging area
- commit history
- branch
- HEAD
- remote

## Essential Commands

    git init
    git status
    git add README.md
    git commit -m "Initial commit"
    git log --oneline

## Good Strategy

- check `git status` often
- understand what is unstaged, staged, and committed

## Bad Strategy

- treat Git like a save button
- commit large unrelated changes together

## Key Architectural Takeaway

Git is a state machine for repository change, not a bag of commands.