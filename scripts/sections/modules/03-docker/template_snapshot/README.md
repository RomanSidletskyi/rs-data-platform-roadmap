# 03-docker

This module introduces Docker as a core engineering tool for building reproducible local environments, packaging applications, and modeling small multi-service systems.

The goal is not only to learn Docker commands, but to understand how containers, images, volumes, networks, and Compose fit into real data engineering workflows.

This module is intentionally independent from any specific runtime target. You can study it locally, on a Linux VM, or later move the same stacks to a remote host such as a Raspberry Pi.

## Why This Module Matters

Docker is one of the most practical skills in modern data engineering because it helps you:

- package applications predictably
- isolate dependencies
- reproduce environments across machines
- run local databases and platform services quickly
- model a small system before moving to cloud or orchestration tools

For a data engineer, Docker is often the shortest path to running and understanding tools such as:

- Postgres
- MinIO
- Airflow
- Kafka
- dbt support services

## Main Learning Goals

By the end of this module, you should be able to:

- explain the difference between an image and a container
- run and manage containers confidently
- work with ports, volumes, and networks
- write basic but clean Dockerfiles
- build your own images for Python applications
- run multi-container systems with Docker Compose
- inspect logs and debug common container problems
- use Docker as a foundation for local data engineering stacks

## Prerequisites

Before starting this module, it is helpful to have:

- basic command line familiarity
- basic Python knowledge
- a basic understanding of configuration files and environment variables

Raspberry Pi is not required for this module. It can be used later as an optional runtime target after the Docker foundations are in place.

## Module Structure

03-docker/

learning-materials/
simple-tasks/
pet-projects/

Each part has a separate role:

- learning-materials explain concepts, mechanisms, trade-offs, and architecture
- simple-tasks provide focused hands-on practice
- pet-projects combine multiple ideas into realistic engineering scenarios

## Learning Path

The recommended order is:

1. understand what Docker is and why it exists
2. learn how images and containers differ
3. practice ports, storage, and networking
4. write Dockerfiles for your own code
5. move from one container to multi-service Compose setups
6. learn debugging and operational basics
7. apply everything to small local data engineering stacks

## Learning Materials

### 01 What Is Docker And Why It Matters

Why containerization exists, what problem it solves, and how it differs from virtual machines.

### 02 Images, Containers, And Registry

How Docker artifacts are built, stored, versioned, and executed.

### 03 Ports, Volumes, And Networks

How containers communicate, expose services, and persist data.

### 04 Dockerfile Basics

How to package your own application into a reusable image.

### 05 Docker Compose Basics

How to model a small local system with multiple services.

### 06 Docker For Data Engineering

How Docker supports local databases, object storage, ETL jobs, and development stacks.

### 07 Debugging And Best Practices

How to inspect containers, fix common failures, and think more like an operator.

## Simple Tasks

The simple tasks are grouped by topic and follow the same format:

- Goal
- Input
- Requirements
- Expected Output
- Extra Challenge

Each task folder also includes a solution.md file for later self-checking and reuse as a practical reference.

The task flow moves from basic container operations to debugging and finally to Docker in data engineering scenarios.

## Pet Projects

The pet projects are designed to simulate realistic engineering work rather than isolated command practice.

In this module, the main pet-project folders are guided projects. The learner is expected to build them by following the README, architecture notes, starter assets, and definition of done.

When useful, a separate `reference_example_*` folder can exist next to a guided project. That reference folder is not the main assignment. It is a comparison artifact for later self-checking and for designing future pet modules more consistently.

### Guided Projects Vs Reference Examples

Use the pet projects in this order:

1. open the guided project folder
2. read the scenario, implementation plan, and definition of done
3. build the solution yourself
4. only after that compare your result with the matching `reference_example_*` folder if it exists

This keeps the project as a real learning exercise instead of turning it into a copy-paste walkthrough.

They progress through four levels:

1. packaging a single Python batch job
2. running an ETL process with Postgres in Compose
3. modeling a small multi-service application stack
4. building a local data-platform-style foundation stack

Each project should help build both practical implementation skill and architectural understanding.

## How This Module Connects To Other Modules

This module supports and connects to multiple parts of the roadmap:

- 01-python, because Python applications often need to be packaged and run reproducibly
- 02-sql, because Docker makes local database practice easier
- 05-confluent-kafka, because Kafka stacks are commonly run in Docker during learning
- 11-airflow, because local Airflow environments are often started with Docker Compose
- 12-dbt, because Docker can provide a repeatable dbt runtime
- 15-raspberry-pi-homelab, because the stacks built here can later be moved to a remote runtime target

## Recommended Workflow

Use this module in the following way:

1. read one learning-materials topic
2. complete the matching simple-tasks topic
3. keep notes about common failures and fixes
4. move to the next topic only after the commands and concepts are clear
5. complete at least one pet project after the core topics
6. only then move the same stack to another machine if needed

## Completion Criteria

You can consider this module complete when you can:

- write a Dockerfile for a small Python application
- build and run your own image
- explain image, container, volume, and network responsibilities
- run a multi-service stack with Compose
- debug a broken container using logs, exec, and inspect
- explain where Docker fits in a local data platform workflow

## Optional Next Step

After this module, you can run the same containers and Compose stacks on another Linux host or continue with [15-raspberry-pi-homelab](../15-raspberry-pi-homelab/README.md) as a practical runtime environment.
