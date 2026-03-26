# Rebase, Conflicts, And History Cleanup

## Why This Topic Matters

Rebase is useful for local history cleanup and branch refresh, but dangerous when misunderstood.

## Core Commands

    git fetch origin
    git rebase origin/main
    git rebase --continue
    git rebase --abort

## Good Strategy

- use rebase to replay your local work onto a newer base
- stop and inspect conflicts deliberately

## Bad Strategy

- rewrite shared history casually
- continue a rebase without understanding the conflict

## Key Architectural Takeaway

Rebase changes history shape. That is powerful and risky at the same time.