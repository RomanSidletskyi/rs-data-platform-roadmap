# Snowflake

## Purpose

This is a standalone, first-pass Snowflake learning module for someone starting with the platform from zero and progressing toward architecture decisions. It combines concise working references, selected detailed feature guides, and architecture-oriented material. It is intentionally separate from the Snowflake notes in `02-sql/`: those support general SQL learning; this module teaches Snowflake as a cloud data platform.

The first pass aims for broad coverage and a useful learning route. It is not a claim that every feature is documented exhaustively. Expand individual topics as questions arise during study.

## Prerequisites

- Basic SQL: `SELECT`, filtering, joins, grouping, and simple DDL
- Basic data-platform vocabulary: source, ingestion, transformation, warehouse, and consumer
- No prior Snowflake account or cloud administration experience is required

The early materials introduce Snowflake-specific concepts from the beginning. A Snowflake account is optional for the first learning pass; hands-on use can incur charges, so follow the cost and credential precautions in the materials.

## Outcomes

By the end of the first pass, you should be able to:

- explain Snowflake's storage, compute, and cloud-services model
- navigate accounts, databases, schemas, tables, warehouses, roles, stages, and integrations
- use common Snowflake SQL and recognize important type and function behavior
- choose a reasonable loading and transformation pattern for a stated freshness requirement
- inspect query behavior and reason about pruning, concurrency, scaling, and cost
- design basic access boundaries, governance controls, and recovery objectives
- identify when Snowflake features or surrounding tools are a better fit
- present a platform design with explicit assumptions, alternatives, and trade-offs

## Choose Your Route

- **New to Snowflake:** use the [Learning Paths](learning-materials/01_learning_paths.md) to follow the shared curriculum from foundations onward.
- **Experienced with Snowflake or another platform:** use the same paths, but treat foundational topics as a review and spend more time on unfamiliar capabilities, trade-offs, and diagnostics.
- **Looking up one topic:** go to the [Capability Map](learning-materials/00_snowflake_capability_map.md), the complete catalog with direct links to every learning-material file.
- **Want the detailed study plan:** use the [Snowflake Platform Learning Guide](learning-materials/snowflake_platform_learning_guide.md) for phase goals, outcomes, practice, and evidence of progress.

### One curriculum, four learning lenses

The module does not divide its content into separate Junior, Middle, Senior, and Architect syllabi. **Every level can access the full set of materials.** The levels describe the depth and kind of work to focus on:

| Learning lens | How to use the shared materials |
| --- | --- |
| Junior | Build the mental model, learn terminology, reproduce basic examples, and explain what each component does. |
| Middle | Implement reliable workflows, validate outputs, handle replay and common failures, and operate features safely. |
| Senior | Review all topics selectively; prioritize behavior, edge cases, diagnosis, measurable trade-offs, cost, and alternatives. Revisit foundational material when it is relevant to a design or incident. |
| Architect | Review the full landscape; prioritize requirements, account and workload boundaries, system-wide consequences, governance, recovery objectives, and defensible decisions. |

These are **focus recommendations, not access rules or skip lists**. A Senior learner can study a foundational topic in depth, and a Junior learner can preview advanced architecture material. For every shared topic, [Learning Paths](learning-materials/01_learning_paths.md) explains what each lens should look for. The Capability Map links to the actual files; the Learning Guide describes the sequence and evidence of learning.

## Material Types

- `reference/`: concise syntax, function, object, and operational reminders with small examples
- `deep-dives/`: focused explanations with practical cases, limitations, alternatives, and failure modes
- `architecture/`: platform context, decision criteria, consequences, trade-offs, and operating concerns
- `simple-tasks/`: short exercises that check understanding before projects
- `pet-projects/`: guided scenarios that combine capabilities into a coherent design
- `end-to-end-projects/`: working pipelines with real data, architecture decisions, alternative stacks, and solved references

The three course-navigation documents have distinct jobs and are maintained together:

1. **[Capability Map](learning-materials/00_snowflake_capability_map.md) — what exists.** The complete, topic-organized inventory. Each learning-material file is linked directly so a reader can discover or revisit it without following a prescribed sequence.
2. **[Learning Paths](learning-materials/01_learning_paths.md) — how to approach it by level.** A shared curriculum, with Junior, Middle, Senior, and Architect focus guidance for each topic. It recommends priority and depth, never exclusive content.
3. **[Snowflake Platform Learning Guide](learning-materials/snowflake_platform_learning_guide.md) — how to study it over time.** A phased course plan with goals, outcomes, practice, and checkpoints. It points back to the Map for complete file-level navigation rather than maintaining a second catalog.

When adding a learning document, link it directly from the Capability Map, place it in the appropriate shared topic/phase in Learning Paths, and include it in the Learning Guide only when it changes the study sequence or learning outcomes. Update this README if the navigation contract changes.

## Learning Materials

- [Capability Map](learning-materials/00_snowflake_capability_map.md)
- [Learning Paths](learning-materials/01_learning_paths.md)
- [Detailed Snowflake course guide](learning-materials/snowflake_platform_learning_guide.md)
- [Quick References](learning-materials/reference/README.md)
- [Deep Dives](learning-materials/deep-dives/README.md)
- [Query Performance and Optimization track](learning-materials/deep-dives/query-performance/README.md), with a matching [diagnosis and design task set](simple-tasks/10_snowflake_performance/README.md)
- [Architecture Guides](learning-materials/architecture/README.md)
- [Research backlog](../../docs/learning-backlog/README.md): article notes and candidate additions for Snowflake materials; see the [current Iceberg and production architecture notes](../../docs/learning-backlog/topics/snowflake-iceberg-production-architecture.md)

## Practice and Projects

Start the [simple task sets](simple-tasks/README.md) after the matching reference or deep-dive material. The [guided projects](pet-projects/README.md) move from a small governed warehouse to replayable ingestion and a production architecture proposal. Hands-on Snowflake account work is optional; the exercises include account-free design alternatives.

The [end-to-end projects](end-to-end-projects/README.md) are working pipelines from a real free data source to a consumer. Each one has a problem statement, architecture decisions, alternative stacks, a step-by-step build, a solved reference on Azure with an AWS variant, and a build-it-yourself brief. They require a Snowflake account; start with P01 (internal stages, no other cloud), or with P04 if you already know basic Snowflake loading.

## Cost, Credentials, and Accuracy

To get a Snowflake trial and the tools around it, use the repository [setup guide](../../shared/environments/setup-guide/README.md): [Snowflake trial account](../../shared/environments/setup-guide/accounts/snowflake.md), [Snowflake CLI with key-pair](../../shared/environments/setup-guide/02_cli_tools_and_auth.md#snowflake-cli), and the cloud accounts used by the end-to-end projects ([Azure](../../shared/environments/setup-guide/accounts/azure.md), [AWS](../../shared/environments/setup-guide/accounts/aws.md)).

Snowflake compute can incur charges while warehouses or services are active. For hands-on work, use the smallest suitable resources, configure auto-suspend, set cost controls where available, and shut down resources after a lab. Never commit passwords, tokens, private keys, account locators, or real customer data.

Feature availability and behavior can vary by edition, cloud, region, account configuration, and product release. This first-pass material calls out known applicability questions, but verify current product details in official Snowflake documentation before production use.

## Related Modules

- `02-sql/` for general SQL and database foundations
- `12-dbt/` for warehouse-native transformation engineering
- `05-confluent-kafka/` for event streaming
- `06-spark-pyspark/` and `07-databricks/` for external distributed processing
- `11-airflow/` for cross-platform orchestration