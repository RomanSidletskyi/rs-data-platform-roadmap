# Architecture — Kafka To Snowflake To dbt Incremental Platform

## Components

- Kafka event producer
- ingestion job or connector that lands events in Snowflake
- raw Snowflake event table with technical metadata and payload
- dbt staging, intermediate, and incremental marts
- optional downstream BI or reporting consumers
