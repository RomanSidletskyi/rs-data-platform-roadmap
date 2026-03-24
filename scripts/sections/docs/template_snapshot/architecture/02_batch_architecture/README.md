# Batch Architecture

## What This Topic Is For

Batch architecture is for systems where data can be processed on a schedule rather than continuously.

It is still one of the most important architecture patterns in analytics, internal reporting, finance workflows, and historical reconstruction.

## Typical Architecture

    Source -> Landing -> Raw -> Transform -> Curated -> BI

## When Batch Is A Strong Fit

- daily reporting
- hourly synchronization
- historical backfills
- cost-sensitive analytics that do not need immediate freshness
- workloads where recomputation and reruns matter more than sub-minute latency

## When Batch Is A Weak Fit

- fraud detection
- live monitoring
- real-time alerting
- workflows where the business action depends on immediate reaction

## What To Pay Attention To

- where raw data is preserved before transformations
- whether full refresh or incremental processing is safer
- how backfills will run without corrupting later layers
- whether pipeline dependencies are explicit
- what the acceptable freshness window really is

## Good Architecture Signals

- raw, processed, and curated layers are separated clearly
- backfill strategy exists before incidents happen
- pipeline reruns are safe and reproducible
- batch windows are based on real business need rather than habit

## Common Mistakes

- using full refresh everywhere because it is easier initially
- storing only transformed outputs and losing raw history
- pretending an hourly job is real time
- letting downstream BI read unstable intermediate data

## Real Examples To Think Through

- nightly finance reporting pipeline
- hourly CRM synchronization into an analytical warehouse
- bronze to silver to gold rebuild after a transformation bug

Worked example:

- `worked_example_daily_sales_batch_pipeline.md`

For each example, ask:

- why is batch good enough here
- what is the replay or rerun path
- where can data quality checks fail the flow safely

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- What is a backfill?
- When should you use incremental processing?

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_daily_sales_batch_pipeline.md`
- `../../system-design/README.md`
- `../../trade-offs/README.md`

## Completion Checklist

- [ ] I can explain a standard batch pipeline
- [ ] I understand raw vs curated layers
- [ ] I understand full refresh vs incremental load
