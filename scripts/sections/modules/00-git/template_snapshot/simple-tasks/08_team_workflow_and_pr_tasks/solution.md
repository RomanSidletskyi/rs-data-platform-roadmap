# Solution

Reasonable workflow:

1. update local main
2. create feature branch
3. commit in small reviewable steps
4. push branch to origin
5. open PR
6. merge only after review and CI pass

Good commit rules:

- one logical concern per commit
- meaningful commit messages
- avoid unrelated formatting noise
- keep PRs narrow enough to review
- avoid force-push on shared protected branches