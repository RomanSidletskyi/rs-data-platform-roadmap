# Filesystem Navigation And Path Reasoning

## Why This Topic Matters

Nearly every shell mistake starts with path confusion.

If the learner cannot reason about paths confidently, later work in Docker, Git, and remote operations becomes much riskier.

## Core Ideas

- absolute path starts from the root
- relative path starts from the current working directory
- `~` points to the home directory
- `.` means current directory
- `..` means parent directory

## Core Commands

    pwd
    ls
    ls -la
    cd /absolute/path
    cd relative/path
    cd ~
    realpath README.md
    find . -maxdepth 2 -type d

## Good Strategy

- run `pwd` before risky commands
- use `ls -la` often enough to see hidden files and permissions
- switch to absolute paths when the current location is uncertain

## Bad Strategy

- rely on memory instead of checking location
- assume a script always runs from the same directory
- confuse repo root with module root

## Small Cookbook Example

To inspect where you are and what is one level below:

    pwd
    find . -maxdepth 1 | sort

To get a fully resolved path:

    realpath ./README.md

## Common Failure Mode

A command such as:

    rm -rf data

is completely different depending on the current working directory.

That is why path reasoning is operational safety, not only convenience.