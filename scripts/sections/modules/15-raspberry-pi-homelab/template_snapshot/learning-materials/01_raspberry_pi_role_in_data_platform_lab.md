# Raspberry Pi Role In A Data Platform Lab

## Purpose

Raspberry Pi is useful as a small remote machine for learning infrastructure and service operations.

For this repository, Raspberry Pi should be treated as:

- a Docker host
- a lightweight service runner
- a place for persistent volumes
- a remote node for experiments

It should not be treated as:

- the only place where code exists
- a replacement for git
- a replacement for cloud infrastructure
- a realistic production cluster

## Best Use Cases In This Repository

Strong fits:

- Airflow practice
- PostgreSQL for local labs
- MinIO for object-storage style learning
- Python services and ETL jobs
- reverse proxy and small monitoring stacks

Conditional fits:

- Kafka in very small setups
- dbt local workflow helpers
- tiny Spark experiments

Poor fits:

- large Spark jobs
- high-throughput Kafka clusters
- multi-node distributed systems meant to simulate production scale

## Recommended Operating Model

Keep a clear separation:

main machine:
- editing code
- writing docs
- using git
- architecture work

Raspberry Pi:
- running services
- storing Docker volumes
- keeping logs and generated data
- staying on as an always-available lab environment

## Why This Matters

Without this separation, a learning repo often turns into a mix of code, runtime state, secrets, and generated files.

That makes the repository harder to maintain and much weaker as a portfolio project.