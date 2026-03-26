# Reference Example - Relational To Document Migration

This folder contains a ready comparison example for the guided migration project.

Its purpose is:

- self-checking after attempting the guided project
- showing one honest side-by-side redesign from normalized SQL to a document model
- preserving a concrete example of workload-based migration reasoning

You should attempt the guided project first:

- `02-sql/pet-projects/03_relational_to_document_migration`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- order-centric document design instead of table-to-collection copying
- side-by-side SQL and MongoDB-style query paths for the same business questions
- explicit trade-off analysis covering duplication and update complexity
- a recommendation that depends on workload, not ideology

## Folder Overview

- `data/order_document_example.json` for one concrete target document shape
- `src/sql_queries.sql` for relational access patterns
- `src/mongo_queries.js` for document-style access patterns
- `tests/query_comparison.md` for business-question comparison notes
- `tests/tradeoffs.md` for final migration reasoning

## Why This Is A Good Reference Shape

- the target model is redesigned around reads that matter
- easier reads are balanced against duplication and update fan-out
- the comparison stays concrete by using the same business questions on both sides

## How To Compare With Your Own Solution

When comparing this reference example with your own implementation, focus on:

- whether your target document really improves the dominant reads
- whether your embedding and referencing choices are justified explicitly
- whether your trade-off analysis includes write and update costs
- whether your recommendation changes when the workload changes
