# Solution

Typical flow:

    git fetch origin
    git rebase origin/main

If a conflict happens:

1. inspect `git status`
2. edit conflicted files
3. `git add` resolved files
4. `git rebase --continue`

Abort path:

    git rebase --abort