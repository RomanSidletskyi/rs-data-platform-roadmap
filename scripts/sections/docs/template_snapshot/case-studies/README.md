# Case Studies

This section contains architecture case studies and design breakdowns.

The goal is to learn architecture by analyzing real or realistic systems.

Use case studies after you already understand the core concepts.

They are strongest when you use them to answer:

- what problem forced the architecture shape
- what trade-off was accepted deliberately
- what simpler design would fail here
- which parts were business-specific versus generally reusable

## How To Use Case Studies

Recommended loop:

1. summarize the system in plain language
2. list the most important components
3. identify the critical trade-off or scaling pressure
4. compare the case with one simpler alternative
5. write one short decision note about what you would reuse and what you would not

## Recommended Reading Order

1. `01_batch_lakehouse_for_finance_reporting.md`
2. `02_streaming_event_backbone_for_ecommerce.md`
3. `03_semantic_serving_layer_for_executive_bi.md`
4. `04_multi_team_domain_data_platform.md`
5. `05_startup_data_stack_evolution.md`
6. `06_governance_breakdown_and_recovery.md`
7. `07_cdc_platform_for_operational_to_analytics_sync.md`
8. `08_data_quality_platform_for_trust_at_scale.md`
9. `09_self_service_analytics_platform_for_domain_teams.md`
10. `10_feature_platform_for_personalization.md`

This order moves from one business workflow to broader platform shape.

## Current Case Studies

- `01_batch_lakehouse_for_finance_reporting.md`
- `02_streaming_event_backbone_for_ecommerce.md`
- `03_semantic_serving_layer_for_executive_bi.md`
- `04_multi_team_domain_data_platform.md`
- `05_startup_data_stack_evolution.md`
- `06_governance_breakdown_and_recovery.md`
- `07_cdc_platform_for_operational_to_analytics_sync.md`
- `08_data_quality_platform_for_trust_at_scale.md`
- `09_self_service_analytics_platform_for_domain_teams.md`
- `10_feature_platform_for_personalization.md`

## Suggested Pairings

- `01_batch_lakehouse_for_finance_reporting.md` with `../system-design/batch-etl.md` and batch-vs-streaming trade-off notes
- `02_streaming_event_backbone_for_ecommerce.md` with `../system-design/kafka-ingestion.md` and Kafka-vs-batch trade-off notes
- `03_semantic_serving_layer_for_executive_bi.md` with `../system-design/lakehouse-bi.md` and serving-model trade-off notes
- `04_multi_team_domain_data_platform.md` with `../architecture/adr/README.md` and governance-related trade-off notes
- `05_startup_data_stack_evolution.md` with platform-simplification versus platform-maturity trade-off analysis
- `06_governance_breakdown_and_recovery.md` with `../architecture/06_data_governance_security/README.md` and access-control review notes
- `07_cdc_platform_for_operational_to_analytics_sync.md` with `../system-design/kafka-ingestion.md` and batch-vs-streaming decision notes
- `08_data_quality_platform_for_trust_at_scale.md` with reliability, governance, and operating-model review
- `09_self_service_analytics_platform_for_domain_teams.md` with domain ownership, catalog, and serving consistency topics
- `10_feature_platform_for_personalization.md` with hybrid architecture and low-latency serving trade-offs

## What To Extract From Every Case

- the main system shape in plain language
- the one or two design pressures that really mattered
- what made the chosen architecture stronger than a simpler one
- what would become dangerous if copied blindly into a smaller environment

## Common Reading Mistakes

- focusing only on tool names
- assuming the most complex architecture is the most correct one
- ignoring ownership boundaries and only analyzing data flow
- skipping the question of what would fail first

## Suggested Topics

- streaming event platform
- batch lakehouse platform
- analytics serving architecture
- startup data stack
- enterprise multi-team data platform
- governance failure and recovery
- CDC into analytics platform
- data quality control plane
- self-service analytics operating model
- feature platform for personalization

## Read With

- `../architecture/README.md`
- `../trade-offs/README.md`
- `../system-design/README.md`
- `case-study-template.md`

If a case study raises a design question such as batch versus streaming, domain ownership, or lakehouse versus simpler serving, move next into `../trade-offs/`.

If a case study raises a whole-system question such as "what components should exist", move next into `../system-design/`.
