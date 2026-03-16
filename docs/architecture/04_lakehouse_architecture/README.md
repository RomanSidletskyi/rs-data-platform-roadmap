# Lakehouse Architecture

## What Problem Does It Solve

Lakehouse architecture combines scalable low-cost storage with reliable table features for analytics.

## Why It Matters

Modern platforms need open storage, scalable compute, and curated BI-friendly layers.

## Typical Architecture

    Ingestion -> Bronze -> Silver -> Gold -> BI / ML / Serving

## When To Use It

- analytics platforms
- multi-stage transformations
- historical retention
- large-scale processing

## When Not To Use It

- tiny local workflows
- simple single-table reporting

## Interview Questions

- What is a lakehouse?
- Why use Delta Lake instead of plain Parquet?
- What is medallion architecture?
- Why separate bronze, silver, and gold?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand what a lakehouse solves
- [ ] I understand bronze, silver, and gold layers
- [ ] I understand why table formats matter
