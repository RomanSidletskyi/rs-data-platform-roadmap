# Permissions, Ownership, And Execution Model

## Why This Topic Matters

Many command-line failures are really permissions or ownership failures.

Examples:

- script will not execute
- SSH key is rejected
- config cannot be read
- mounted volume has wrong owner

## Core Commands

    ls -l
    chmod +x run.sh
    chmod 644 config.yml
    chmod 755 scripts/deploy.sh
    chown user:group file.txt
    whoami
    id
    groups

## Core Mental Model

Permissions are shown as:

- owner
- group
- other

Common values:

- 644 for normal text file
- 755 for executable scripts and directories that must be traversed

## Good Strategy

- inspect with `ls -l` before guessing
- understand whether the object is a file or directory
- remember that executable scripts need both correct permissions and a valid interpreter path

## Bad Strategy

- set everything to 777
- guess random chmod values until the error disappears

## Why Bad Is Bad

- insecure defaults spread fast
- production-like systems become harder to trust

## Cookbook Example

If a script says `Permission denied`:

    ls -l script.sh
    chmod +x script.sh
    head -n 1 script.sh

The first line should usually be a valid shebang such as:

    #!/usr/bin/env bash

## Key Architectural Takeaway

Permissions are part of the runtime contract of Linux systems.