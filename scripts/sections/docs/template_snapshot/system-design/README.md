# System Design

This section contains the canonical system design notes for common data engineering scenarios.

The goal is to practice thinking in systems, not only in scripts or tools.

Use this directory when the question is "what would the whole system look like" rather than "how does one tool work."

## How To Use This Directory

Use each design note as a decision exercise:

1. restate the problem in your own words
2. identify the latency, scale, recovery, and ownership constraints
3. explain why each component exists
4. compare at least one simpler alternative
5. connect the design to a likely repository project or module path

## What Belongs Here

- worked reference designs
- reusable design templates
- cross-technology system patterns

## What Does Not Belong Here

- architecture learning roadmaps
- module theory notes
- duplicate copies of the same designs inside another folder

## Suggested System Design Topics

- batch ETL pipeline
- Kafka ingestion platform
- lakehouse + BI architecture
- streaming analytics platform
- hybrid batch + streaming platform

## Read With

- `../architecture/README.md`
- `../trade-offs/README.md`
- `../case-studies/README.md`
- `../data-platform-map.md`

Suggested pairings:

- batch ETL pipeline with `../case-studies/01_batch_lakehouse_for_finance_reporting.md`
- Kafka ingestion platform with `../case-studies/02_streaming_event_backbone_for_ecommerce.md`
- lakehouse plus BI architecture with `../case-studies/03_semantic_serving_layer_for_executive_bi.md`
- ownership-heavy multi-layer design questions with `../case-studies/04_multi_team_domain_data_platform.md`
