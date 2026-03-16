# Python for Data Engineering

Python is one of the core languages used in modern data platforms.

This module focuses on **practical Python skills required by Data Engineers**, not just general programming knowledge.

The goal is to learn how to use Python to build:

- data ingestion scripts
- ETL pipelines
- API integrations
- data validation tools
- automation utilities
- reusable data processing components

This module is the **foundation for later modules** such as Kafka, Spark, Databricks, and Delta Lake.

## Learning Objectives

By completing this module, you should be able to:

- write clean and modular Python code
- build small ETL pipelines
- process CSV and JSON datasets
- retrieve data from APIs
- implement retries and error handling
- add logging and execution metadata
- validate datasets before ingestion
- structure Python projects properly
- use pandas for data transformations
- design small ingestion services

## Module Structure

01-python/

learning-materials/
simple-tasks/
pet-projects/

Each section serves a different purpose.

## learning-materials

Contains study notes and curated resources.

Topics include:

### Fundamentals

Core Python concepts required for engineering workflows.

Topics:

- variables and data types
- control flow
- loops
- functions
- modules

### Files and JSON

Working with files and structured data.

Topics:

- reading and writing CSV
- working with JSON
- parsing nested structures
- combining multiple files
- directory processing

### API Work

Using Python to retrieve and process external data.

Topics:

- HTTP requests
- REST APIs
- query parameters
- pagination
- retries
- rate limiting

### Testing and Logging

Writing reliable pipelines.

Topics:

- logging module
- error handling
- retry patterns
- validation checks
- basic testing

### Packaging and Environment

Organizing Python projects.

Topics:

- virtual environments
- requirements.txt
- project structure
- configuration files
- environment variables

### Data Engineering Focus

Patterns used in real data pipelines.

Topics:

- ingestion pipelines
- incremental processing
- idempotent workflows
- schema validation
- data quality checks

## simple-tasks

Small exercises designed to practice specific skills.

The tasks are structured in increasing difficulty:

beginner  
↓  
junior data engineer  
↓  
pipeline developer

These tasks focus on:

- working with files
- processing datasets
- interacting with APIs
- building small scripts
- validating and transforming data

Total tasks: **60+ exercises**

## pet-projects

Pet projects simulate real engineering tasks.

Each project includes:

- problem description
- architecture explanation
- implementation steps
- expected outputs
- improvement ideas

These projects are designed to become part of your **GitHub portfolio**.

## Pet Projects Overview

### 1. API to CSV Pipeline

Build a pipeline that collects data from a public API and stores structured CSV files.

Concepts practiced:

- API ingestion
- JSON parsing
- CSV output
- logging
- execution metadata

### 2. JSON Normalizer

Create a tool that converts nested JSON into tabular datasets.

Concepts practiced:

- JSON flattening
- schema mapping
- data cleaning

### 3. Log Parser Pipeline

Process raw application logs and produce structured analytics datasets.

Concepts practiced:

- text parsing
- regex
- structured logging
- analytics summaries

### 4. Data Quality Checker

Build a reusable validation tool for datasets.

Concepts practiced:

- null checks
- schema validation
- duplicate detection
- validation reports

### 5. Incremental Ingestion Simulator

Simulate a daily ingestion pipeline that processes new files only.

Concepts practiced:

- incremental processing
- idempotency
- file state tracking

### 6. API Data Ingestion Service

Build a modular ingestion service that collects data from configurable APIs.

Concepts practiced:

- modular Python structure
- config-driven pipelines
- retry logic
- pagination
- structured logging

### 7. Config-Driven ETL Framework

Create a mini ETL framework where pipelines are defined using configuration files.

Concepts practiced:

- reusable components
- configuration-driven pipelines
- validation layers
- execution reporting

### 8. Mini Data Platform Simulator

Simulate a small data platform using Python pipelines.

Concepts practiced:

- raw zone
- processed zone
- validation layer
- ingestion orchestration
- metadata tracking

## Recommended Workflow

1. Read learning materials
2. Complete simple tasks
3. Solve variations of tasks
4. Build pet projects
5. Refactor older code with better practices
6. Document everything in GitHub

## Completion Criteria

You should be able to:

- design small ingestion pipelines
- structure Python data projects
- process datasets reliably
- validate incoming data
- log pipeline execution
- write maintainable pipeline code

## How This Module Connects to the Rest of the Roadmap

Skills learned here are required for:

- Kafka producers and consumers
- Spark and PySpark pipelines
- Databricks workflows
- automation scripts
- data quality checks
- ingestion services

This module is the **technical foundation of the entire roadmap**.