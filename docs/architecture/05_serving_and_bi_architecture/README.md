# Serving and BI Architecture

## What Problem Does It Solve

This architecture prepares curated data for reporting, analytics, and dashboard consumption.

## Why It Matters

Business users need fast, trusted, easy-to-understand data models instead of raw storage tables.

## Typical Architecture

    Curated Data -> Semantic Layer -> BI Tool -> Dashboards / Reports

## When To Use It

- reporting
- dashboards
- self-service analytics
- KPI delivery

## When Not To Use It

- raw exploratory ingestion
- low-level source archival

## Interview Questions

- Why should Power BI not read raw data directly?
- What is a semantic layer?
- What is the difference between fact and dimension tables?
- Why use data marts?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand the purpose of semantic models
- [ ] I understand fact vs dimension tables
- [ ] I understand why curated layers exist
