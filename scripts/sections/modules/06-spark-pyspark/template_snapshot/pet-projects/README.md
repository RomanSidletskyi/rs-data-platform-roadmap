# Spark Pet Projects

These projects should simulate production-shaped Spark work rather than isolated API drills.

They should combine:

- distributed transformation logic
- file and table layout reasoning
- performance and skew awareness
- architectural placement of Spark between ingestion and serving layers

Planned direction for this module:

- a batch ETL project over raw files
- a partition-aware transformation pipeline
- a Spark job that turns raw data into curated analytical outputs
- a larger architecture-shaped project that connects Spark with storage and orchestration context

As with the Kafka module, the strongest version of this section should follow a guided-project-first pattern and add selective sibling reference examples where comparison is especially valuable.

## Project Map

1. `01_batch_orders_etl_lakehouse_lab`
2. `02_clickstream_sessionization_and_skew_lab`
3. `03_customer_360_curated_mart_lab`
4. `04_kafka_to_spark_lakehouse_pipeline_lab`

## Sibling Reference Examples

- `reference_example_batch_orders_etl_lakehouse_lab`
- `reference_example_kafka_to_spark_lakehouse_pipeline_lab`

## How To Use These Projects

- read the project README first
- inspect the architecture note before writing code
- use the starter assets to understand target output shape and review logic
- document trade-offs around partitioning, model grain, and replay behavior

## Recommended Project Sequence

1. `01_batch_orders_etl_lakehouse_lab`
	Use after foundations plus DataFrames/read-write chapters.
2. `02_clickstream_sessionization_and_skew_lab`
	Use after performance, shuffle, skew, and watermark chapters.
3. `03_customer_360_curated_mart_lab`
	Use after modeling, grain, dimensions, and consumer-contract chapters.
4. `04_kafka_to_spark_lakehouse_pipeline_lab`
	Use after structured streaming, multi-hop, and architecture chapters.

## Guided Labs Versus Reference Examples

- guided labs are for doing the design and implementation work yourself
- reference examples are for comparison after you already have an opinion about the architecture and code shape
- do not start from the reference projects unless the goal is review rather than learning-by-building

## Expected Outcome

By the end of these labs, the learner should be able to place Spark inside a real data platform and reason not only about transformations, but also about model boundaries, output layout, and recovery paths.