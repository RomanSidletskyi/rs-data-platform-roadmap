# 04 Kafka To Databricks Serving Pipeline Lab

## Project Goal

Design a Databricks pipeline that turns Kafka-landed operational events into a governed serving layer for analytics consumers.

## Scenario

An event platform lands order events continuously.

Databricks should:

- normalize the landed event stream
- publish one serving-oriented gold output
- expose the output through SQL or BI-facing contracts
- keep compute, governance, and serving boundaries clear

## Project Type

This folder is a guided project.

If you want a solved comparison later, use the sibling reference example:

- `07-databricks/pet-projects/reference_example_kafka_to_databricks_serving_pipeline_lab`

## Expected Deliverables

- pipeline shape from landed events to gold serving table
- compute choice for the recurring workload
- contract for the serving output
- note about repair and replay path

## Starter Assets Already Provided

- `.env.example`
- `architecture.md`
- `config/README.md`
- `data/README.md`
- `docker/README.md`
- `src/README.md`
- `tests/README.md`

## Definition Of Done

The lab demonstrates that Databricks is not only a compute surface, but also the governed delivery platform for a consumer-facing analytics product built from event data.