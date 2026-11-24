# Snowflake E2E and Production Project Sources

Цей список призначений для наскрізних project ideas і великих production-shaped сценаріїв. Посилання тут є натхненням або case study, а не автоматичним планом дублювати проєкт.

## IoT Multi-Engine

### 13 End-to-End Snowflake Projects, Idea #6

[ProjectPro](https://www.projectpro.io/article/snowflake-projects/1168) · page updated 2026-05-05 · `triaged`

Ідея #6 описує Azure Event Hubs → Databricks/Spark → Snowflake для IoT telemetry. Користь для roadmap: спільний multi-engine data path, streaming, Snowflake ingestion і питання про table/catalog ownership.

**Увага:** це маркетинговий опис ідеї, не технічна специфікація. У ньому є загальні заяви про мільйони подій/real-time; затримки, throughput, сервіси, вартість та підтримку треба визначати й перевіряти окремо.

**Зв'язок із roadmap:** P12 IoT multi-engine уже запланований у [Snowflake E2E catalog](../../../../16-cloud-databases/01-snowflake/end-to-end-projects/README.md). Використовувати цю статтю як source idea для P12, не створювати другий аналогічний проєкт.

**Architecture reference:** [Snowflake streaming architecture across industries](https://www.snowflake.com/en/blog/modern-data-streaming-pipeline-architectures-industry-use-cases/) — vendor reference architecture, не самодостатній hands-on E2E.

## Пов'язане навчання

- [P12 E2E handoff](../../../../16-cloud-databases/01-snowflake/end-to-end-projects/HANDOFF.md) — поточний стан і робочий процес.
- [Iceberg multi-engine architecture note](../../architectures/snowflake/iceberg-multi-engine.md).