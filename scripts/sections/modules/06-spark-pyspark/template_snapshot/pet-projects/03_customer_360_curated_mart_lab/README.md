# 03 Customer 360 Curated Mart Lab

## Project Goal

Build a Spark-shaped curated customer mart that unifies multiple source layers into a consumer-friendly analytics dataset.

## Scenario

The platform has several inputs:

- order history
- payment behavior
- customer reference data
- support interaction summaries

Stakeholders want a customer-level analytical mart, but the platform must define grain and ownership clearly to avoid a vague "everything table."

## Project Type

This is a guided project.

The emphasis is on modeling and architecture, not only on joins.

## Expected Deliverables

- explicit grain for the curated mart
- fact and dimension boundary explanation
- note about incremental rebuild strategy
- consumer-facing contract for key fields and freshness
- architecture note about what should not be packed into the mart

## Starter Assets Already Provided

- `.env.example`
- `src/README.md`
- `data/README.md`
- `tests/README.md`
- `config/README.md`
- `docker/README.md`
- `architecture.md`

## Definition Of Done

The lab demonstrates Spark as a modeling layer that creates a trustworthy analytical mart rather than an oversized technical join output.