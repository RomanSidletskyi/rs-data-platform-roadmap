# Architecture

## Logical Flow

Source transactional tables / event tables
-> cleanup and validation
-> reusable analytical transformations
-> KPI outputs
-> reporting-ready final outputs

## Recommended Layers

### Layer 1 — Raw Source Understanding

Understand source grains and business definitions.

### Layer 2 — Cleaned / Standardized Logic

Normalize business filters such as:

- paid order definition
- valid customer definition
- valid event set

### Layer 3 — Reusable Analytical Models

Examples:

- customer revenue model
- daily revenue model
- product sales model
- funnel base model

### Layer 4 — Final Outputs

Examples:

- KPI tables
- retention outputs
- product ranking outputs
- customer segmentation outputs

## Why This Matters

Even a SQL-only analytics project should teach layered design instead of one giant unmaintainable query.
