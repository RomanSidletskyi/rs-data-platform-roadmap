# 02 Clickstream Sessionization And Skew Lab

## Project Goal

Design a Spark pipeline that sessionizes clickstream events while explicitly accounting for skew and late-arriving records.

## Scenario

A consumer platform emits clickstream events at high volume.

Some anonymous or bot-like identifiers generate disproportionate traffic, which creates skew risk during sessionization and aggregation.

The platform needs a reusable session layer for downstream product analytics.

## Project Type

This is a guided project.

You are expected to design the pipeline and justify trade-offs around:

- event-time handling
- watermark policy
- skew mitigation
- session output grain

## Expected Deliverables

- sessionization strategy
- note about event-time versus processing-time semantics
- skew review for high-volume users or devices
- target output layout for downstream analytical consumers
- replay plan for historical session recomputation

## Starter Assets Already Provided

- `.env.example`
- `src/README.md`
- `data/README.md`
- `tests/README.md`
- `config/README.md`
- `docker/README.md`
- `architecture.md`

## Definition Of Done

The lab demonstrates that sessionization is not only a window-function exercise, but a state, lateness, and data-shape design problem.