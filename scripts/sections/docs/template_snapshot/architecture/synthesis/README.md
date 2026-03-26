# Architecture Synthesis Guide

This guide connects the whole architecture-learning loop into one path.

Use it when you want to move from isolated topics into full architectural reasoning.

## Full Learning Loop

1. start with a topic README in `../01_foundations/` through `../09_architecture_case_studies/`
2. read the topic `anti-patterns.md` to learn what weak design looks like
3. read the topic worked example to see one concrete scenario
4. move into `../../case-studies/` for full realistic platform examples
5. move into `../../trade-offs/` to compare competing architecture choices
6. move into `../../system-design/` to study reusable end-to-end system shapes
7. use `../reviews/` to evaluate a design with checklist questions
8. capture the decision in `../adr/`

## If You Are Studying Concepts

Start with:

- `../01_foundations/README.md`
- `../02_batch_architecture/README.md`
- `../03_streaming_architecture/README.md`

Then move into:

- `../../trade-offs/README.md`
- `../../system-design/README.md`

## If You Are Reviewing A Real Design

Start with:

- `../reviews/system-shape-review-checklist.md`

Then choose the matching review:

- batch: `../reviews/batch-pipeline-review-checklist.md`
- streaming: `../reviews/streaming-platform-review-checklist.md`
- lakehouse or BI: `../reviews/lakehouse-serving-review-checklist.md`
- governance: `../reviews/governance-security-review-checklist.md`
- reliability or cost: `../reviews/reliability-cost-review-checklist.md`

After that, write or review the closest ADR in `../adr/`.

## If You Want Real Examples First

Start with:

- `../../case-studies/README.md`

Then map each case into:

- which topic it belongs to
- which anti-pattern it avoids
- which trade-off note explains the key decision
- which system-design note describes the whole shape
- which ADR captures the main architectural choice

## What Good Synthesis Looks Like

You should be able to explain:

- the problem in plain language
- the simplest viable architecture
- why the final design is more complex than the simple version
- the main trade-off being accepted
- the main failure path and recovery path
- the ADR that captures the decision

## Read With

- `../README.md`
- `../reviews/README.md`
- `../adr/README.md`
- `../../case-studies/README.md`
- `../../trade-offs/README.md`
- `../../system-design/README.md`