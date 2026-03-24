# Raw Landing Curated And Publish Zones

A lake becomes easier to operate when storage zones reflect trust boundaries and usage patterns.

The classic weak pattern is:

- all files in one broad directory tree
- nobody knows which paths are raw, validated, or safe for consumers

## Raw Landing Zone

The raw zone is where source-shaped data lands with minimal transformation.

Its purpose is usually:

- preserve source fidelity
- support replay
- separate ingestion from downstream modeling

Raw does not mean messy forever.

It means the zone has a different responsibility from curated and publish layers.

## Curated Zone

The curated zone is where data becomes more standardized, cleaned, and modeled for repeated engineering use.

This is usually the area where stronger guarantees appear around:

- schema consistency
- naming discipline
- dataset ownership
- reusable internal datasets

## Publish Zone

The publish zone is where supported downstream access should happen when the platform intentionally exposes stable outputs.

This is not just a nicer folder name.

It is a contract decision.

A publish path should usually be governed more carefully than internal engineering paths.

## Why Storage Zones Matter

These zones help clarify:

- where trust increases
- where consumers should and should not read
- where replay starts
- where cleanup rules differ
- where ownership changes between ingestion and consumption layers

## Good Versus Bad Practice

Bad practice:

- analysts read directly from raw landing paths
- curated paths are overwritten ad hoc without ownership rules
- publish paths are only discovered socially, not governed explicitly

Good practice:

- raw, curated, and publish areas have different responsibilities
- consumers are directed toward explicit publish boundaries
- internal engineering rework does not automatically break consumer-facing paths

## Review Questions

1. Why is a publish zone more than a naming convenience?
2. What responsibilities belong in raw versus curated zones?
3. What risks appear when consumers depend on raw or temporary working paths?
