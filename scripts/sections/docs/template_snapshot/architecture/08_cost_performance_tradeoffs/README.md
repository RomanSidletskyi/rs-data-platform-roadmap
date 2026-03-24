# Cost and Performance Trade-offs

## What This Topic Is For

This topic explains how to balance performance, complexity, and cost in data platforms.

Strong architecture is rarely the fastest possible system.

It is the system that meets real requirements without unnecessary operational or financial burden.

## Core Areas

- storage strategy
- compute strategy
- partition design
- file sizing
- workload tuning

## What To Pay Attention To

- which latency targets are worth paying for
- whether distributed compute is actually needed
- how storage layout increases or reduces cost later
- whether partitioning improves reads or creates operational pain
- how small files, over-clustering, and over-refreshing inflate cost

## Good Architecture Signals

- cost drivers are visible in design discussions
- performance tuning is tied to workload shape, not habit
- expensive components exist for a reason that can be defended
- simpler alternatives are considered before scaling up the stack

## Common Mistakes

- using Spark or streaming for workloads a database or batch job could handle
- partitioning by every possible dimension and creating explosion
- optimizing dashboards against raw storage instead of serving layers
- treating cloud spend as a later clean-up problem

## Real Examples To Think Through

- small-files problem in a bronze or silver layer
- batch pipeline that became expensive because of full refresh design
- over-provisioned streaming stack for low-frequency data
- BI model that is slow because semantic and storage layers were not aligned

Worked example:

- `worked_example_overbuilt_streaming_vs_hourly_batch.md`

## Interview Questions

- Why are small files a problem?
- What is partition explosion?
- When is Spark unnecessary?
- How do you balance latency and budget?

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_overbuilt_streaming_vs_hourly_batch.md`
- `../../trade-offs/README.md`
- `../../case-studies/README.md`

## Completion Checklist

- [ ] I understand common cost drivers
- [ ] I understand common performance bottlenecks
- [ ] I understand the small files problem
