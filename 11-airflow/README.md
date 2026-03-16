# Airflow

This module introduces workflow orchestration for data platforms.

The goal is to understand how pipelines are scheduled, monitored, retried, and connected into multi-step workflows.

## Why It Matters

Writing a pipeline is not enough in production.

You also need to control:

- when it runs
- what runs before and after it
- how failures are handled
- how reruns are managed
- how teams observe workflow health

Airflow is one of the most common orchestration tools in data engineering.

## What You Will Learn

- DAG basics
- task dependencies
- scheduling
- retries
- operators
- orchestration vs execution
- Airflow with Spark and external jobs
- production workflow patterns

## Learning Structure

### Learning Materials

- airflow basics
- DAG design
- scheduling and retries
- operators and hooks
- Airflow with Spark
- production patterns

### Simple Tasks

- first DAG
- task dependencies
- scheduling and retries
- Python operator pipeline
- Airflow with external jobs
- basic monitoring

### Pet Projects

- batch pipeline orchestration
- API to lakehouse orchestration
- multi-step data workflow
- production-style Airflow project

## Related Modules

- 01-python
- 06-spark-pyspark
- 07-databricks
- 12-dbt
- 16-observability

## Completion Criteria

By the end of this module, you should be able to:

- explain what orchestration is
- build a simple DAG
- define task dependencies
- configure retries and schedules
- explain the difference between orchestration and compute
