# Iceberg

This module introduces Apache Iceberg as an open lakehouse table format.

The goal is to understand how modern table formats improve reliability, schema evolution, partition management, and multi-engine interoperability.

## Why It Matters

Plain files are not enough for many production analytics systems.

Modern table formats help with:

- schema evolution
- partition evolution
- historical table versions
- reliable reads and writes
- interoperability between engines

Iceberg is especially important for open lakehouse architectures.

## What You Will Learn

- Iceberg basics
- table format concepts
- schema evolution
- partition evolution
- time travel concepts
- Iceberg with Spark
- Iceberg with Flink
- trade-offs of open lakehouse design

## Learning Structure

### Learning Materials

- Iceberg basics
- table format concepts
- partitioning and evolution
- Iceberg with Spark
- Iceberg with Flink
- lakehouse trade-offs

### Simple Tasks

- first Iceberg table
- partition evolution
- schema evolution
- time travel intro
- Spark with Iceberg
- streaming to Iceberg concepts

### Pet Projects

- Iceberg lakehouse lab
- Spark Iceberg pipeline
- Flink Iceberg streaming case
- open lakehouse project

## Related Modules

- 06-spark-pyspark
- 07-databricks
- 08-delta-lake
- 09-azure-data-lake-storage
- 13-flink

## Completion Criteria

By the end of this module, you should be able to:

- explain what Iceberg solves
- compare Iceberg with plain files at a high level
- explain schema and partition evolution
- describe why table formats matter in lakehouse systems
- explain why multi-engine support is important
