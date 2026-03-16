# Batch ETL System Design

## Problem Statement

Design a batch pipeline that ingests data from source systems, stores raw input, transforms it, and prepares curated outputs for reporting.

## Typical Architecture

    Source -> Ingestion -> Raw -> Transform -> Curated -> BI

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- How do you rerun a failed job safely?
