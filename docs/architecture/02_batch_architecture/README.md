# Batch Architecture

## What Problem Does It Solve

Batch architecture is used when data does not need to be processed immediately and can be delivered on a schedule.

## Why It Matters

A large number of analytics systems and reporting workflows are built using batch pipelines.

## Typical Architecture

    Source -> Landing -> Raw -> Transform -> Curated -> BI

## When To Use It

- daily reporting
- hourly synchronization
- historical backfills

## When Not To Use It

- fraud detection
- live monitoring
- real-time alerting

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- What is a backfill?
- When should you use incremental processing?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I can explain a standard batch pipeline
- [ ] I understand raw vs curated layers
- [ ] I understand full refresh vs incremental load
