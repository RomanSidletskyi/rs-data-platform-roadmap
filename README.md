# Data Platform Roadmap

A structured, portfolio-oriented repository for learning data engineering and data platform architecture from fundamentals to system design.

This repository is not only a collection of notes.

It is designed as a working learning system with:

- technology modules
- focused practice tasks
- guided pet projects
- cross-technology real projects
- architecture and trade-off documentation
- AI-assisted workflows for learning, debugging, review, and design

## What This Repository Is

Use this repository to move through three layers of growth:

1. learn one tool well
2. combine several tools into realistic pipelines
3. reason about platform boundaries, contracts, trade-offs, and operating models

The target is not just tool familiarity.

The target is stronger engineering judgment.

## Current Scope

The current active and curated path is:

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
- `11-airflow/`
- `12-dbt/`
- `15-raspberry-pi-homelab/`

Planned placeholders already present in the repository, but intentionally outside the active curated path, are:

- `10-powerbi-fabric/`
- `13-flink/`
- `14-iceberg/`

That means the repository already contains the long-term roadmap structure, but only part of it is currently maintained as active learning scope.

## Standard Module Shape

Each technology module follows the same base structure:

- `README.md` - module overview, goals, navigation, and study path
- `learning-materials/` - theory, architecture, cookbooks, and curated resources
- `simple-tasks/` - focused practice grouped by topic
- `pet-projects/` - guided projects and reference examples
- `PROGRESS.md` - personal module-level learning tracker

The intended learning loop is:

1. study concepts and architecture
2. solve focused tasks
3. build the guided pet projects
4. revisit the module with stronger standards later

## Start Here

If you are entering the repository for the first time, use this route:

1. `00-shell-linux/`
2. `00-git/`
3. `docs/learning-sequence.md`
4. `docs/data-platform-map.md`
5. `01-python/`
6. `02-sql/`

If your goal is repository-level orientation before touching a single module, start with:

1. `docs/README.md`
2. `docs/learning-sequence.md`
3. `docs/learning-architecture.md`
4. `docs/data-platform-map.md`
5. `docs/data-platform-projects-roadmap.md`

## Learning Path

### Phase 0 - Foundational Workflow

- `00-shell-linux/`
- `00-git/`

Focus:

- shell confidence
- repository literacy
- file, process, and environment handling
- recovery and workflow basics before higher-level tooling

### Phase 1 - Engineering Basics

- `01-python/`
- `02-sql/`
- `03-docker/`
- `04-github-actions/`

Focus:

- implementation
- query thinking
- reproducible runtimes
- CI discipline

Example outcome:

- a Python data workflow built, containerized, and validated in CI

### Support Module - Homelab Runtime

- `15-raspberry-pi-homelab/`

Focus:

- remote Docker runtime
- self-hosted lab operations
- persistent services and lightweight infrastructure practice

Recommended timing:

- after `03-docker/`
- before or alongside `11-airflow/` if you want a remote lab environment

### Phase 2 - Data Processing

- `05-confluent-kafka/`
- `06-spark-pyspark/`

Focus:

- event ingestion
- distributed processing
- batch versus streaming thinking

### Phase 3 - Lakehouse Foundations

- `07-databricks/`
- `08-delta-lake/`
- `09-azure-data-lake-storage/`

Recommended internal order:

1. `07-databricks/`
2. `08-delta-lake/`
3. `09-azure-data-lake-storage/`

Reason:

- Databricks frames the compute and workspace layer
- Delta Lake frames the table and reliability layer
- ADLS frames the storage and namespace layer

### Phase 4 - Orchestration And Transformation

- `11-airflow/`
- `12-dbt/`

Focus:

- orchestration
- dependencies and scheduling
- SQL transformation modeling
- tests, lineage, and documentation

### Planned Future Scope

- `10-powerbi-fabric/` for analytics delivery
- `13-flink/` for stateful streaming
- `14-iceberg/` for open table format and multi-engine patterns

## Top-Level Areas

- `docs/` - repository map, learning sequence, architecture study, trade-offs, case studies, and AI chat context packs
- `shared/` - reusable datasets, schemas, configs, docker assets, testing fixtures, and reference resources reused across modules
- `ai-learning/` - AI workflows, prompting guides, tool notes, communication practice, and architecture-thinking exercises
- `real-projects/` - sequential cross-technology projects that combine several modules into realistic portfolio work
- `scripts/` - repository generation and validation automation
- `templates/` - reusable templates for modules, progress tracking, and related documentation

## How The Pieces Fit Together

Use modules for local depth.

Use `docs/` for architecture context and sequencing.

Use `shared/` when an asset should be reused instead of copied.

Use `real-projects/` when one module is no longer enough and you need full integration work.

Use `ai-learning/` to improve how you study, debug, review, write, and design.

## Real Projects

The `real-projects/` directory is the integration layer of the repository.

Current path:

1. `01_python_sql_etl/`
2. `02_python_docker_github_actions/`
3. `03_python_kafka/`
4. `04_python_kafka_databricks/`
5. `05_python_spark_delta/`
6. `06_databricks_adls_powerbi/`
7. `07_kafka_databricks_powerbi/`
8. `08_end_to_end_data_platform/`

These projects are intentionally sequential:

- early projects combine two or three layers
- later projects force broader platform thinking

For planning context, use `docs/data-platform-projects-roadmap.md`.

## AI Learning Layer

The `ai-learning/` section is not a loose prompt collection.

It is a structured operating layer for:

- learning faster without becoming shallow
- debugging more systematically
- reviewing code more critically
- comparing architectures and trade-offs
- improving technical writing and spoken explanations
- using AI as a disciplined engineering amplifier rather than a substitute

If you want to enter that section directly, start with:

1. `ai-learning/README.md`
2. `ai-learning/workflows/how-to-learn-faster.md`
3. `ai-learning/workflows/ai-pair-programming.md`
4. `ai-learning/workflows/ai-for-project-design.md`

## Progress Tracking

Progress is tracked at two levels:

- repository-wide overview in `docs/learning-progress.md`
- module-level detail in each module `PROGRESS.md`

These progress files are learner-managed state.

They are intentionally separate from the generator-backed source-of-truth snapshots used by the scripts system.

## Scripts And Automation

The repository has a section-based scripts system under `scripts/`.

It supports two automation layers:

- generator-backed modules under `scripts/sections/modules/`
- generator-backed repository sections under `scripts/sections/`

Current script-backed sections include:

- `docs`
- `shared`
- `ai-learning`
- `real-projects`

Current generator-backed modules include:

- `00-shell-linux`
- `00-git`
- `01-python`
- `02-sql`
- `03-docker`
- `04-github-actions`
- `05-confluent-kafka`
- `06-spark-pyspark`
- `07-databricks`
- `08-delta-lake`
- `09-azure-data-lake-storage`
- `11-airflow`
- `12-dbt`
- `15-raspberry-pi-homelab`

Useful entrypoints:

- `./scripts/bootstrap_section.sh all`
- `./scripts/check_repo.sh`
- `./scripts/check_repo.sh foundational`
- `./scripts/check_repo.sh modules`
- `./scripts/refresh_template_snapshots.sh`

For deeper operational detail, use `scripts/README.md`.

## Working Principles

- prefer architecture understanding over isolated syntax memorization
- prefer guided, reviewable progress over huge prebuilt dumps of content
- preserve one clear source of truth for generated sections and modules
- keep roadmap placeholders visible, but separate them from active curated scope
- use AI to compress friction, not to outsource understanding

## Recommended Next Step

Choose one of these entry paths:

1. start the core path at `00-shell-linux/`
2. open `docs/README.md` for repository-level orientation
3. open `real-projects/README.md` if your goal is integration work
4. open `ai-learning/README.md` if your goal is better AI-assisted learning and engineering workflows