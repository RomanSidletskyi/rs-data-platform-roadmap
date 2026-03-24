# Solution

Typical commands:

    git switch -c feature/add-notes
    git add notes.md
    git commit -m "Add notes"
    git switch main
    git merge feature/add-notes

Fast-forward happens when main has not advanced independently since the feature branch split.