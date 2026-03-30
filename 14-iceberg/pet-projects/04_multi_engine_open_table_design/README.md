# 04 Multi Engine Open Table Design

## Project Goal

Design an Iceberg platform where one engine writes the tables and multiple engines consume them through the same catalog and storage contracts.

The project should force deliberate decisions about:

- writer versus reader responsibilities
- schema evolution safety
- table contract stability across engines
- publish boundaries for open tables

## Scenario

Spark is your primary writer, but analysts also want to read the tables from Trino or Snowflake or another compatible engine.

You need to support:

- one cataloged open table contract
- one engine-specific write path
- at least one secondary read engine
- controlled schema and partition evolution

## Project Type

This folder is a guided project, not a ready solution.

You are expected to design the implementation by following this README and the supporting documents in the folder.

## Starter Assets You Already Have

This guided project already includes:

- `architecture.md`
- `requirements.md`
- `contract.md`
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## What You Must Build

- define the writer engine and at least one reader engine
- define what schema changes are safe without breaking readers
- define one publish contract for multi-engine consumption
- document at least three multi-engine anti-patterns

## Definition Of Done

This project is complete if:

- writer and reader roles are explicit
- contract stability rules are documented
- schema evolution policy is explained
- the design reads like a multi-engine platform review