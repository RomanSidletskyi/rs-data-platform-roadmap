# Solution

Typical command flow:

    mkdir git-practice && cd git-practice
    git init
    printf '# Practice Repo\n' > README.md
    git status
    git add README.md
    git commit -m "Add README"
    git log --oneline

Then repeat with one more file and verify clean status using `git status`.