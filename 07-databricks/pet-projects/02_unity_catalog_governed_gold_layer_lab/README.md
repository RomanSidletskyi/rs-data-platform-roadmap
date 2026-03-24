# 02 Unity Catalog Governed Gold Layer Lab

## Project Goal

Design a governed Databricks gold layer with explicit Unity Catalog object choices, permissions, and analyst-facing delivery rules.

## Scenario

Several analysts need a revenue mart, but the platform team does not want them querying unstable engineering layers directly.

The project should define:

- catalog and schema placement
- gold-table contract
- consumer permissions
- warehouse-serving boundary

## Project Type

This folder is a guided project.

## Expected Deliverables

- catalog, schema, and table design
- one consumer contract for the gold layer
- permissions model for analysts versus engineers
- note about environment isolation

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `config/README.md`
- `data/README.md`
- `docker/README.md`
- `src/README.md`
- `tests/README.md`

## Definition Of Done

The lab shows how a Databricks gold product becomes governable and queryable without exposing every upstream engineering layer to consumers.