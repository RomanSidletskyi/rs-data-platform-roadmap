# Learning Resources - Batch Architecture

## How To Use These Resources

Use batch resources to compare good scheduled-system design with fake real-time thinking.

After each article, note:

- what data freshness the design assumes
- where raw data is preserved
- how rerun, backfill, and incremental loading work

## What To Search For

- batch processing architecture
- incremental loading patterns
- full refresh vs incremental trade-offs
- backfill strategies
- medallion-style batch pipelines

## Best Resource Types

- engineering blog posts about warehouse or lakehouse batch rebuilds
- articles on safe backfill and replay patterns
- architecture notes on raw, staging, and curated layer separation

## Real Examples To Pair With Reading

- nightly finance reporting
- hourly ingestion into a warehouse or lakehouse
- rebuilding historical outputs after transformation bugs

## Books

- Designing Data-Intensive Applications
- Fundamentals of Data Engineering
