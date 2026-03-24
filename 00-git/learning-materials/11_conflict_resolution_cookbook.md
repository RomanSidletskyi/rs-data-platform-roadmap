# Conflict Resolution Cookbook

## Scenario 1 - Merge Conflict

Commands:

    git merge feature-branch
    git status

Then resolve files, stage them, and continue.

## Scenario 2 - Rebase Conflict

Commands:

    git rebase main
    git status
    git rebase --continue

## Scenario 3 - Wrong Branch Commit

Useful commands:

    git switch correct-branch
    git cherry-pick COMMIT

## Scenario 4 - Detached HEAD

Useful commands:

    git status
    git switch -c rescue-branch

## Key Architectural Takeaway

Conflicts are integration information, not random punishment.