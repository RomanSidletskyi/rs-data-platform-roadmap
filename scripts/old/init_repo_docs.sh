#!/bin/bash

set -e

echo "Initializing repository documentation..."

mkdir -p docs

########################################
# repo-map.md
########################################

cat << 'EOF' > docs/repo-map.md
# Repository Map – rs-data-platform-roadmap

This repository is a structured learning platform for Data Engineering.

The goal is to move from beginner to data platform architect by learning technologies step-by-step and building practical projects.

---

# Core Learning Modules

Each module contains:

- learning-materials
- simple-tasks
- pet-projects

## Foundation Layer

01-python  
02-sql  
03-docker  
04-github-actions  

Topics covered:

- programming
- data processing
- containerization
- CI/CD
- reproducible pipelines

---

## Data Platform Core

05-confluent-kafka  
06-spark-pyspark  
07-databricks  
08-delta-lake  
09-azure-data-lake-storage  
10-powerbi-fabric  

Topics covered:

- streaming ingestion
- distributed processing
- lakehouse architecture
- storage layers
- analytics and BI

---

## Advanced Data Engineering

11-airflow  
12-dbt  
13-flink  
14-iceberg  

Topics covered:

- workflow orchestration
- analytics engineering
- real-time stream processing
- open lakehouse table formats

---

# Module Structure

Each module follows the same structure.

Example:

07-databricks/

learning-materials/  
simple-tasks/  
pet-projects/  

---

# Real Projects

real-projects/

These combine multiple technologies.

Example projects:

01_python_sql_etl  
02_python_docker_github_actions  
03_python_kafka  
04_python_kafka_databricks  
05_python_spark_delta  
06_databricks_adls_powerbi  
07_kafka_databricks_powerbi  
08_end_to_end_data_platform  

Goal: simulate real production data platform workflows.

---

# Documentation

docs/

data-platform-map.md  
learning-sequence.md  
data-platform-projects-roadmap.md  

architecture/  
system-design/  
case-studies/  
trade-offs/  

---

# Scripts

scripts/

init_repo.sh  
init_python_api_project.sh  
fill_python_simple_tasks.sh  
fill_python_pet_projects.sh  
init_docs.sh  
add_new_modules.sh  
fill_new_modules_readmes.sh  
fill_new_modules_simple_tasks.sh  
bootstrap.sh  

EOF

########################################
# ai-context.md
########################################

cat << 'EOF' > docs/ai-context.md
# AI Context – rs-data-platform-roadmap

This repository is a learning platform for Data Engineering.

The goal is to move from beginner to data platform architect by building structured modules, tasks, and projects.

## Repository Structure

Each technology module contains:

- learning-materials
- simple-tasks
- pet-projects

Modules:

01-python  
02-sql  
03-docker  
04-github-actions  
05-confluent-kafka  
06-spark-pyspark  
07-databricks  
08-delta-lake  
09-azure-data-lake-storage  
10-powerbi-fabric  
11-airflow  
12-dbt  
13-flink  
14-iceberg  

## Additional Sections

docs/
architecture  
system-design  
case-studies  
trade-offs  

real-projects/

shared/

ai-learning/

## Scripts

scripts/

init_repo.sh  
init_python_api_project.sh  
fill_python_simple_tasks.sh  
fill_python_pet_projects.sh  
init_docs.sh  
add_new_modules.sh  
fill_new_modules_readmes.sh  
fill_new_modules_simple_tasks.sh  
bootstrap.sh  

EOF

########################################
# learning-architecture.md
########################################

cat << 'EOF' > docs/learning-architecture.md
# Learning Architecture

This repository is designed as a structured system for learning Data Engineering.

The learning model follows three levels of practice:

1. Learning Materials
2. Simple Tasks
3. Pet Projects
4. Real Projects

---

# Learning Materials

Learning materials provide theoretical understanding of each technology.

Each topic includes:

- Why the topic matters
- What concepts must be understood
- Key theory
- Common mistakes
- Recommended resources
- Interview questions
- Completion checklist

Goal:

Build conceptual understanding before implementation.

---

# Simple Tasks

Simple tasks are small focused exercises.

They help practice individual concepts quickly.

Each task includes:

- Goal
- Input
- Requirements
- Expected Output
- Extra Challenge

Goal:

Turn theoretical knowledge into practical intuition.

---

# Pet Projects

Pet projects simulate real data engineering workflows.

They introduce:

- pipeline structure
- logging
- configuration
- validation
- reproducibility

Goal:

Build portfolio-ready projects.

---

# Real Projects

Real projects combine multiple technologies together.

Examples:

Python + Kafka  
Spark + Delta  
Databricks + ADLS + PowerBI  
Kafka + Flink + Iceberg  

Goal:

Simulate production-grade data platforms.

---

# Learning Progression

The roadmap follows this progression:

Programming → Data Processing → Distributed Systems → Data Platform Architecture

Example path:

Python → SQL → Docker → Kafka → Spark → Databricks → Delta Lake → Airflow → dbt → Flink → Iceberg

---

# Final Objective

After completing the roadmap the learner should be able to:

- design batch data pipelines
- design streaming architectures
- build lakehouse platforms
- understand data platform trade-offs
- design production data workflows

EOF

echo "Repository documentation created successfully."