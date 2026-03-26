# Solution

Unstage example:

    git restore --staged path/to/file

Restore tracked file contents:

    git restore path/to/file

Reasoning:

- `revert` is safer for shared history because it adds an explicit inverse commit
- `reset` rewrites branch position and is riskier in collaborative history