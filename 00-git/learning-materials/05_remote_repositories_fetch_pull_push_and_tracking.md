# Remote Repositories, Fetch, Pull, Push, And Tracking

## Why This Topic Matters

Collaboration begins when local history meets remote history.

## Core Commands

    git remote -v
    git fetch origin
    git pull origin main
    git push origin feature/my-branch
    git branch -vv

## Good Strategy

- understand `fetch` before using `pull`
- know which branch tracks which remote branch

## Bad Strategy

- use `git pull` everywhere without understanding what changed
- push to the wrong branch because tracking state is unclear

## Key Architectural Takeaway

Remote synchronization is state integration, not just “sending code to GitHub”.