# Data Platform Roadmap

A structured, portfolio-oriented roadmap for learning modern data engineering and data platform architecture step by step.

This repository is designed to help build practical skills through:

- learning materials
- simple practice tasks
- portfolio-ready pet projects
- real-world multi-technology projects
- AI-assisted learning workflows

## Goal

The goal of this repository is to grow from foundational skills to production-oriented data platform thinking.

It covers the knowledge required to work with:

- shell / Linux
- Git
- Python
- SQL
- Docker
- Raspberry Pi / Homelab environments
- GitHub Actions
- Confluent / Kafka
- Spark / PySpark
- Databricks
- Delta Lake
- Azure Data Lake Storage
- Power BI / Microsoft Fabric

Over time, this repository will evolve into a complete learning system and portfolio for Data Engineering and Data Platform Architecture.

## Repository Structure

Each technology module follows the same structure:

- `README.md` — module overview, goals, and learning resources
- `learning-materials/` — theory notes, curated resources, and study guides
- `simple-tasks/` — focused exercises covering specific topics
- `pet-projects/` — larger portfolio projects with more realistic implementation

In addition, the repository includes:

- `docs/` — roadmap, study strategy, portfolio guidance, and architecture principles
- `templates/` — reusable README templates for modules, tasks, and projects
- `shared/` — datasets, diagrams, utilities, and glossary
- `ai-learning/` — AI workflows, prompts, and exercises for faster learning
- `real-projects/` — end-to-end projects combining multiple technologies

## Learning Approach

This repository is based on a practical progression:

1. Learn core concepts
2. Solve small focused tasks
3. Build pet projects
4. Combine technologies in real-world scenarios
5. Document everything as part of a professional portfolio

The focus is not only on learning tools, but also on learning how to think like a data engineer.

## Modules

### Core Technology Modules

- `00-shell-linux/`
- `00-git/`
- `01-python/`
- `02-sql/`
- `03-docker/`
- `04-github-actions/`
- `05-confluent-kafka/`
- `06-spark-pyspark/`
- `07-databricks/`
- `08-delta-lake/`
- `09-azure-data-lake-storage/`
- `10-powerbi-fabric/`
- `11-airflow/`
- `12-dbt/`
- `13-flink/`
- `14-iceberg/`
- `15-raspberry-pi-homelab/`

### Cross-Technology Projects

Located in `real-projects/`, these projects combine multiple tools into realistic scenarios.

Examples:

- Python + SQL ETL pipeline
- Python + Docker + GitHub Actions automation
- Python + Kafka streaming pipeline
- Python + Kafka + Databricks processing flow
- Python + Spark + Delta batch pipeline
- Databricks + ADLS + Power BI analytics solution
- Kafka + Databricks + Power BI near real-time platform
- End-to-end data platform architecture project

## AI-Assisted Learning

The `ai-learning/` section is included to accelerate learning in a practical way.

It contains:

- prompting guides
- debugging workflows
- architecture design prompts
- AI code review practices
- tool-specific notes for ChatGPT, GitHub Copilot, Cursor, and others

The goal is to use AI as:

- a mentor
- a reviewer
- a pair programmer
- a debugging assistant
- an architecture thinking partner

## Portfolio Mindset

This repository is also a long-term portfolio project.

Each module and project should gradually include:

- clear problem statements
- implementation notes
- architecture diagrams
- assumptions and trade-offs
- improvements and next steps

That way, the repository becomes more than a study folder — it becomes evidence of engineering growth.

## Recommended Way to Use This Repository

- Start with `00-shell-linux/`
- Then study `00-git/`
- Continue with `01-python/`
- Move to `02-sql/`
- Study `03-docker/` before `15-raspberry-pi-homelab/`
- Build a strong foundation before starting streaming and lakehouse topics
- Complete simple tasks before pet projects
- Document what you learn in each module
- Revisit old modules and improve them over time

## Long-Term Vision

This repository is intended to become a complete personal data platform learning system, including:

- foundational engineering skills
- batch and streaming pipelines
- lakehouse architecture
- analytics and BI delivery
- portfolio-ready real-world projects
- architecture-level thinking

## Status

This repository is under active development and will expand over time with:

- new technologies
- new project ideas
- more advanced architecture scenarios
- better documentation
- stronger portfolio cases

## Generator-Backed Modules

Some finished modules are now maintained through a snapshot-based generator pattern under `scripts/sections/modules/<module>/`.

In these modules, `template_snapshot/` is treated as the source of truth and the `fill_*` scripts copy curated content from it during bootstrap.

Current generator-backed modules:

- `00-shell-linux/`
- `00-git/`
- `02-sql/`
- `03-docker/`
- `04-github-actions/`
- `11-airflow/`
- `12-dbt/`
- `15-raspberry-pi-homelab/`

The foundational modules also have a lightweight repository workflow for starter-asset validation:

- `.github/workflows/foundational-starter-assets.yml`

It bootstraps `00-shell-linux/` and `00-git/` and checks that their bundled starter assets remain runnable after generator changes.

The same foundational validation can be run locally with:

- `./scripts/check_foundational_starter_assets.sh`

There is also a repository-wide generator integrity workflow:

- `.github/workflows/generator-backed-modules.yml`

It bootstraps every generator-backed module and fails if the regenerated module no longer matches its `template_snapshot/` source.

The same validation can be run locally with:

- `./scripts/check_generator_backed_modules.sh`

For a single repository smoke-check entrypoint, run:

- `./scripts/run_repo_smoke_checks.sh`