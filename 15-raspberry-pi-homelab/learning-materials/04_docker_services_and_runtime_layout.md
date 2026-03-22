# Docker Services And Runtime Layout

## Why Docker On Raspberry Pi

Docker lets you keep service setup reproducible.

That is especially useful for this repository because many modules benefit from isolated local services.

## ARM Compatibility

Raspberry Pi typically uses ARM architecture.

This means:

- not every Docker image will work
- prefer images that explicitly support `linux/arm64`
- test one service at a time

## Recommended Directory Layout On The Host

Use a stable root such as:

    /srv/rs-data-platform/

Recommended layout:

    /srv/rs-data-platform/
    ├── repo/
    ├── runtime/
    ├── data/
    ├── logs/
    ├── backups/
    └── configs/

## Runtime Principles

Keep these separate:

- repo clone
- persistent volumes
- generated datasets
- logs
- secret-bearing config files

This separation reduces accidental git pollution and makes cleanup safer.

## Good First Services

Start with one of these:

- PostgreSQL
- MinIO
- Airflow

These services connect well to the rest of your learning roadmap.

## Compose Strategy For This Repo

Store compose definitions in the repository.

Run them on the Raspberry Pi.

That means:

- versioned infrastructure definitions
- reproducible service startup
- easier documentation

## Practical Advice

- run a single lab stack first
- avoid starting many services together until monitoring is in place
- use named folders for data persistence
- keep `.env` files outside git