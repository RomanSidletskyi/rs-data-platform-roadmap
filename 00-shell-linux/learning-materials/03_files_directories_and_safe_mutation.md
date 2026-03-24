# Files, Directories, And Safe Mutation

## Why This Topic Matters

Engineers constantly create, copy, move, rename, and remove files.

Unsafe mutation habits cause:

- accidental data loss
- broken scripts
- corrupted working trees
- wrong deploy artifacts

## Core Commands

    mkdir -p logs/archive
    touch notes.txt
    cp config.yml config.backup.yml
    cp -R src backup-src
    mv old-name new-name
    rm temp.txt
    rm -r old-folder
    ln -s target shortcut

## Good Strategy

- use `mkdir -p` for idempotent directory creation
- copy before mass mutation when recovery matters
- inspect path and target before `mv` or `rm`
- prefer explicit paths over ambiguous short names in destructive commands

## Bad Strategy

- use `rm -rf` as a first reflex
- move files around without checking what already exists at destination
- overwrite backups silently

## Why Bad Is Bad

- recovery may become impossible
- debugging becomes slower because original state is gone

## Cookbook Example

Safe mini-backup before changing a config directory:

    mkdir -p backups
    cp -R config "backups/config_$(date +%Y%m%d_%H%M%S)"

This does not make shell perfectly safe, but it creates a recovery path.

## Key Architectural Takeaway

File mutation is infrastructure change at a small scale.

Treat it with the same respect as code and config changes.