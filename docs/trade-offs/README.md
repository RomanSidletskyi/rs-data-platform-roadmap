# Trade-Offs

This section is dedicated to one of the most important architecture skills:

understanding trade-offs.

Architecture is not choosing the best tool in general.
Architecture is choosing the best fit for a specific situation.

Use this directory when you need to force a decision into explicit criteria instead of vague preference.

## How To Use Trade-Off Notes

For each trade-off, write or analyze:

1. the real scenario
2. the decision criteria
3. what each option makes easier
4. what each option makes harder
5. the trigger that would make you revisit the decision

Good trade-off analysis should make rejected options look reasonable before it explains why they lost.

## Suggested Trade-Off Notes

- Kafka vs batch ingestion
- Spark vs pandas
- Delta vs Iceberg
- dbt vs SQL scripts
- Airflow vs cron
- Flink vs Spark Structured Streaming

## Current Notes

- `kafka-vs-batch-ingestion.md`
- `spark-vs-pandas.md`
- `delta-vs-iceberg.md`
- `dbt-vs-sql-scripts.md`
- `airflow-vs-cron.md`
- `flink-vs-spark-structured-streaming.md`

## Read With

- `../architecture/README.md`
- `../system-design/README.md`
- `../case-studies/README.md`
- `../architecture/adr/README.md`

Suggested pairings:

- Kafka vs batch ingestion with `../case-studies/02_streaming_event_backbone_for_ecommerce.md`
- Spark vs pandas with early-stage evolution questions in `../case-studies/05_startup_data_stack_evolution.md`
- dbt vs SQL scripts with layered serving and mart questions in `../case-studies/03_semantic_serving_layer_for_executive_bi.md`
- platform maturity and governance trade-offs with `../case-studies/04_multi_team_domain_data_platform.md` and `../case-studies/06_governance_breakdown_and_recovery.md`
