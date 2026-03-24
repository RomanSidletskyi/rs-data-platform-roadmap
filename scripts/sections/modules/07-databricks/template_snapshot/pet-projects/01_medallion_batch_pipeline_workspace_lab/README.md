# 01 Medallion Batch Pipeline Workspace Lab

## Project Goal

Design a Databricks batch pipeline that turns raw landed data into bronze, silver, and gold outputs with clear workspace and compute boundaries.

## Scenario

An analytics platform lands raw order events into cloud storage.

The team needs a Databricks workflow that:

- ingests raw data into bronze
- normalizes it into silver
- publishes one governed gold aggregate
- separates exploratory development from production execution

## Project Type

This folder is a guided project, not a ready implementation.

If you want a solved comparison after finishing your own design, use the sibling reference example:

- `07-databricks/pet-projects/reference_example_medallion_batch_pipeline_workspace_lab`

## Expected Deliverables

- bronze, silver, and gold layer definitions
- one Databricks job design with task boundaries
- compute choice justification
- note about workspace versus production job behavior

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `config/README.md`
- `data/README.md`
- `docker/README.md`
- `src/README.md`
- `tests/README.md`

## Definition Of Done

The lab explains not only how to build the medallion flow, but also how that flow should be operated in Databricks rather than kept as one interactive notebook.