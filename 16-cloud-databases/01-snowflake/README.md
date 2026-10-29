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

- **New to Snowflake:** follow [Learning Paths](learning-materials/01_learning_paths.md), starting with the beginner path.
- **Experienced with another cloud database:** start with the [Capability Map](learning-materials/00_snowflake_capability_map.md), then open the references or deep dives for unfamiliar capabilities.
- **Working on an architecture decision:** use the architecture guides and their decision checklists; the capability map points to the relevant topics.

## Material Types

- `reference/`: concise syntax, function, object, and operational reminders with small examples
- `deep-dives/`: focused explanations with practical cases, limitations, alternatives, and failure modes
- `architecture/`: platform context, decision criteria, consequences, trade-offs, and operating concerns
- `simple-tasks/`: short exercises that check understanding before projects
- `pet-projects/`: guided scenarios that combine capabilities into a coherent design

The capability map is the inventory and navigation layer. Not every capability needs a deep dive. Its entry states the recommended depth and links to the material that exists.

## Learning Materials

- [Capability Map](learning-materials/00_snowflake_capability_map.md)
- [Learning Paths](learning-materials/01_learning_paths.md)
- [Detailed Snowflake course guide](learning-materials/snowflake_platform_learning_guide.md)
- [Quick References](learning-materials/reference/README.md)
- [Deep Dives](learning-materials/deep-dives/README.md)
- [Architecture Guides](learning-materials/architecture/README.md)

## Practice and Projects

Start the [simple task sets](simple-tasks/README.md) after the matching reference or deep-dive material. The [guided projects](pet-projects/README.md) move from a small governed warehouse to replayable ingestion and a production architecture proposal. Hands-on Snowflake account work is optional; the exercises include account-free design alternatives.

## Cost, Credentials, and Accuracy

Snowflake compute can incur charges while warehouses or services are active. For hands-on work, use the smallest suitable resources, configure auto-suspend, set cost controls where available, and shut down resources after a lab. Never commit passwords, tokens, private keys, account locators, or real customer data.

Feature availability and behavior can vary by edition, cloud, region, account configuration, and product release. This first-pass material calls out known applicability questions, but verify current product details in official Snowflake documentation before production use.

## Related Modules

- `02-sql/` for general SQL and database foundations
- `12-dbt/` for warehouse-native transformation engineering
- `05-confluent-kafka/` for event streaming
- `06-spark-pyspark/` and `07-databricks/` for external distributed processing
- `11-airflow/` for cross-platform orchestration