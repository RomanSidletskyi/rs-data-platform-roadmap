# Storage Backups And File Management

## Main Rule

Git is for code and small reference assets.

Raspberry Pi storage is for runtime state and larger generated files.

## What Belongs On The Raspberry Pi

- Docker volumes
- database files
- object storage data
- generated parquet or CSV outputs
- logs
- backups

## What Belongs In The Repository

- compose files
- scripts
- templates
- documentation
- sample datasets small enough for git

## Storage Risks

Common Raspberry Pi risks:

- small or unreliable storage media
- SD card wear from frequent writes
- disk filling up because of logs or volumes
- accidental deletion because no backup layout exists

## Better Practice

If possible:

- use SSD instead of only microSD
- keep runtime state under one base path
- back up configs and important volumes regularly
- monitor disk usage

## Backup Levels

Good enough for learning:

- backup configs
- backup compose definitions through git
- backup critical data folders periodically

You do not need enterprise backup tooling for a learning lab.

You do need a repeatable process.

## File Management Workflow

Use one of these patterns:

- edit locally, push to git, pull on Raspberry Pi
- edit locally, sync selected files with `rsync`

Avoid making large undocumented changes directly on the Raspberry Pi.