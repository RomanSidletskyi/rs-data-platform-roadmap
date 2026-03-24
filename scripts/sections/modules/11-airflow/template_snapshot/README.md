# Airflow

This module introduces workflow orchestration for data platforms.

The goal is to understand how pipelines are scheduled, monitored, retried, and connected into multi-step workflows.

The goal is also to understand Airflow at an architectural level:

- what Airflow should own
- what Airflow should not own
- how DAG design affects reliability and scalability
- how orchestration connects to Spark, dbt, APIs, and warehouse workflows

## Why It Matters

Writing a pipeline is not enough in production.

You also need to control:

- when it runs
- what runs before and after it
- how failures are handled
- how reruns are managed
- how teams observe workflow health

Airflow is one of the most common orchestration tools in data engineering.

It is valuable not only because it can run tasks on a schedule, but because it forces you to think about:

- execution boundaries
- failure isolation
- retry safety
- dependency design
- operational visibility

## What You Will Learn

- DAG basics
- task dependencies
- scheduling
- retries
- operators
- orchestration vs execution
- Airflow with Spark and external jobs
- production workflow patterns

By the end of the module, the learner should not only be able to write DAGs, but also explain why a pipeline is shaped the way it is.

## Prerequisites

Before starting this module, it helps to have:

- basic Python knowledge
- basic SQL understanding
- basic Docker familiarity for local Airflow environments
- some intuition about ETL or data workflow steps

Docker knowledge is especially useful because many local Airflow setups are started through Compose.

## Module Structure

11-airflow/

learning-materials/
simple-tasks/
pet-projects/

Each part has a separate role:

- learning-materials explain concepts, architecture, production patterns, and cookbook examples
- simple-tasks provide focused DAG and orchestration practice
- pet-projects combine orchestration concepts into realistic multi-step workflows

## Learning Structure

### Learning Materials

The learning-materials block in this module intentionally combines three perspectives:

- concept
- architecture
- cookbook

Core examples:

- Airflow overview and mental model
- architecture and pipeline design
- execution model and task runtime
- operators and hooks cookbook
- monitoring, alerting, and observability
- CI/CD and release management
- scaling, cost, and production incidents
- practical pipeline cookbook with Postgres, API, S3, and dbt

There are also older or supplemental folders in `learning-materials/`.

They should be treated as supporting references, while the numbered files provide the clearest primary path.

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

Two guided projects already have separate reference examples for later self-checking:

- `pet-projects/reference_example_api_to_lakehouse_orchestration`
- `pet-projects/reference_example_production_style_airflow_project`

These reference examples are not the main learning path.

The intended order remains:

1. attempt the guided project first
2. compare with the reference example only after building your own version

## Recommended Learning Path

Use this module in the following order:

1. start with the overview and architecture files
2. continue with execution model, scheduling, and retries
3. study one cookbook-style example after the core concepts are clear
4. complete the matching simple-task topics
5. build at least one pet project only after the orchestration boundaries make sense

Recommended first files:

1. `learning-materials/01_airflow_overview.md`
2. `learning-materials/04_airflow_architecture_and_pipeline_design.md`
3. `learning-materials/05_airflow_execution_model_and_task_runtime.md`
4. `learning-materials/06_airflow_pipeline_cookbook_postgres_api_s3_dbt.md`
5. `learning-materials/13_airflow_operators_and_hooks.md`

For a fuller map of the learning block, see `learning-materials/README.md`.

## Related Modules

- 01-python
- 03-docker
- 06-spark-pyspark
- 07-databricks
- 12-dbt
- 16-observability

## Shared Resource Philosophy

If an Airflow asset becomes reusable across multiple modules, it should move into `shared/` instead of being duplicated inside one project only.

Current Airflow shared target structure:

- `shared/configs/templates/airflow/` for reusable runtime config examples
- `shared/testing/mock-data/airflow/` for reusable payload samples
- `shared/testing/expected-outputs/airflow/` for reusable publish or marker contracts

## Completion Criteria

By the end of this module, you should be able to:

- explain what orchestration is
- build a simple DAG
- define task dependencies
- configure retries and schedules
- explain the difference between orchestration and compute
- explain why heavy business logic should not live inside DAG files
- describe a good DAG boundary and a bad DAG boundary
- connect Airflow to external systems such as dbt, Spark, APIs, and storage layers
