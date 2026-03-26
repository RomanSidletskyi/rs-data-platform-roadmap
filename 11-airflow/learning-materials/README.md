# 11-airflow Learning Materials Index

This folder already contains both core materials and supplemental notes.

The goal of this index is to make the learning block easier to navigate without removing any existing content.

## How To Read This Folder

Treat the numbered top-level files as the primary learning path.

Use older topic folders and extra notes as supporting references, not as the first reading path.

The learning block in this module combines:

- concept files
- architecture files
- cookbook files

That mix is intentional.

Airflow is easy to misuse if you only learn syntax and operators.
It becomes much easier to understand when you study:

- what Airflow is
- what Airflow is not
- what it should orchestrate
- what should stay outside the DAG layer
- how good workflow boundaries are designed

## Recommended Primary Path

### Phase 1 - Concept And Mental Model

Start here:

- `01_airflow_overview.md`
- `03_airflow_components_and_internal_mechanics.md`
- `05_airflow_execution_model_and_task_runtime.md`

What this phase should give you:

- a correct mental model of Airflow
- understanding of scheduler, workers, tasks, DAG runs, and runtime behavior
- understanding of orchestration vs compute

### Phase 2 - Architecture And Design

Continue with:

- `04_airflow_architecture_and_pipeline_design.md`
- `10_airflow_environment_and_deployment_architecture.md`
- `09_airflow_scaling_performance_and_cost_optimization.md`

What this phase should give you:

- DAG design judgment
- system boundary thinking
- failure isolation reasoning
- production architecture intuition

### Phase 3 - Cookbook And Applied Patterns

Then study:

- `06_airflow_pipeline_cookbook_postgres_api_s3_dbt.md`
- `13_airflow_operators_and_hooks.md`
- `07_airflow_monitoring_observability_and_alerting.md`
- `08_airflow_cicd_testing_and_release_management.md`

What this phase should give you:

- practical examples of Airflow in realistic pipelines
- monitoring and operational patterns
- CI/CD and release management context

### Phase 4 - Production Maturity

Finally use:

- `11_airflow_production_incidents_and_war_stories.md`
- `12_airflow_dbt_spark_lakehouse_architecture/`

What this phase should give you:

- production failure awareness
- broader architecture context with dbt and Spark

## Remaining Supplemental Materials

After consolidating the most useful legacy notes into the numbered primary path, only a small amount of supplemental material remains.

### 1. Deep-Dive Material That Still Adds Distinct Value

- `03_airflow_internals_deep_dive.md`

This file overlaps partially with the numbered path, but it still adds distinct value because it goes deeper into scheduler loop, metadata DB behavior, executors, and pressure points.

Recommended use:

- read it after the primary concept and architecture files
- use it when you want stronger system-level understanding of Airflow internals

### 2. Asset-Based Learning Package

- `02_airflow_installation_and_deployment/`

This is better treated as a package, not as a normal note folder, because it contains:

- multiple markdown guides
- `docker-compose.yml`
- `Makefile`
- example `dags/`
- `requirements.txt`

So this one should probably stay a folder unless its assets are moved elsewhere.

At this point, the numbered files should be treated as canonical.

## Reading Strategy

Do not try to memorize every Airflow feature at once.

Use this loop:

1. read one concept or architecture file
2. inspect one cookbook-style example
3. complete the matching simple task
4. return to architecture after seeing the practical shape

This module works best when theory, code shape, and system reasoning reinforce each other.