# Git Incident Recovery Cookbook

## Scenario 1 - Lost Commit After Reset

Use:

    git reflog

Then recover by resetting or creating a branch at the old commit.

## Scenario 2 - Need One File From An Old Commit

Use:

    git restore --source COMMIT path/to/file

## Scenario 3 - Merge Broke Main

If history is shared, prefer:

    git revert MERGE_COMMIT

## Scenario 4 - Accidentally Deleted File

Use:

    git restore path/to/file

## Key Architectural Takeaway

Git recovery should be based on state inspection first, mutation second.