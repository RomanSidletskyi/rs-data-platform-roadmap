# Dataset Grain Domain Boundaries And Ownership

Storage structure should reflect ownership, not only technical convenience.

If ownership is vague, storage paths become vague too.

## Why Dataset Grain Matters

A path should represent something coherent.

That means the team should know:

- what one dataset actually is
- what its grain is
- who owns it
- whether it is internal or publishable
- what changes count as breaking changes

Without that clarity, teams create storage trees that look organized but hide conceptual confusion.

## Domain Boundaries

A healthy lake is not one giant directory tree with accidental subfolders.

It is a set of deliberate dataset or domain boundaries.

Examples of domain-aware thinking:

- commerce orders data should not be mixed arbitrarily with marketing campaign events
- finance publish paths should not be implicitly owned by an upstream raw ingestion team
- one domain’s temporary backfill area should not become another team’s consumer dependency

## Ownership Questions To Ask Early

Before creating a stable path, ask:

- who owns writes to this area?
- who approves schema or partition changes?
- who can consume from this area?
- what is the retention expectation?
- is this an engineering working area or a supported output?

If the answer is “everyone” or “we will decide later,” the boundary is not ready.

## Good Versus Weak Ownership Signals

Weak signals:

- shared folder names with no clear team responsibility
- many service principals writing to the same path without a primary owner
- consumer teams reading from upstream temporary folders

Healthy signals:

- one clearly named domain or platform owner
- stable write responsibility
- explicit publish path if consumer access is supported
- change control around meaningful path boundaries

## Architecture Consequence

Storage design is one of the earliest places where domain-driven thinking can become visible.

If ownership is wrong here, governance, cataloging, and consumer contracts become fragile later.

## Review Questions

1. Why is a well-named path still weak if ownership is unclear?
2. What signs show that a directory tree is reflecting domain confusion rather than domain design?
3. When should a path be treated as a supported product boundary rather than an internal working area?
