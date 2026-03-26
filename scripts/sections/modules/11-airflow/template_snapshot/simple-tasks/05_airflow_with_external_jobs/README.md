# Airflow with External Jobs

## Goal

Understand how Airflow orchestrates jobs outside Airflow itself.

## Input

A workflow with steps:

- trigger_spark_job
- wait_for_completion
- publish_result

## Requirements

- model the workflow as a DAG
- treat Spark as an external compute engine
- document what Airflow controls vs what Spark executes

## Expected Output

A DAG that represents orchestration of an external job.

## Extra Challenge

- add failure handling logic
- add task groups or logical grouping
