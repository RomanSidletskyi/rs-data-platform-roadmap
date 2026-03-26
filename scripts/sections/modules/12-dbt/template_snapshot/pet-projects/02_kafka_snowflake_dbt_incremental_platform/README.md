# Project 02 — Kafka → Snowflake → dbt Incremental Platform

## Project Goal

Build a realistic event-driven analytics project where Kafka events land in Snowflake and dbt turns them into safe incremental marts.

## Scenario

Your platform receives order lifecycle events from Kafka. An ingestion job writes those events into a raw Snowflake table. The analytics layer now needs staging, deduplication, late-arrival protection, and a consumer-facing fact model that updates in micro-batches.

## Project Type

This folder is a guided project, not a ready solution.
