# Lakehouse And Serving Review Checklist

## Purpose

Use this checklist when reviewing medallion-style platforms, curated marts, and BI-serving architecture.

## Layer Clarity

- do bronze, silver, and gold have distinct responsibilities
- is raw preservation meaningful or just renamed staging
- are semantic models separated from storage mechanics

## Consumer Fit

- which consumers read gold or semantic outputs
- are dashboards shielded from raw and technical layers
- do serving models reflect analytical questions instead of ingestion shape

## Governance And Contracts

- where do business definitions become stable
- who owns the curated layer and semantic metrics
- how are breaking changes prevented or reviewed

## Operational Review

- how are broken transformations repaired
- what happens if silver logic was wrong for three days
- which table-format features are operationally critical here

## Cost Review

- are file layout and partitioning designed for real query patterns
- is the semantic layer aligned with performance needs