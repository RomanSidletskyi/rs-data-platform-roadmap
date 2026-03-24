# Startup Data Stack Evolution

## Background

A startup begins with:

- one product database
- a few dashboards
- one engineer handling analytics requests

Over time, the company adds:

- more product domains
- executive reporting
- marketing analytics
- finance reconciliation
- early event-driven use cases

## Problem

The architecture cannot jump straight to a full enterprise data platform.

It must evolve in stages without creating chaos in the middle.

The key problem is not only technical scale.

It is deciding when to add structure and when to keep the stack simple.

## Architecture Overview

Healthy evolution often looks like this:

### Stage 1

    product DB
        -> simple analytical extract
        -> lightweight reporting tables
        -> dashboards

### Stage 2

    product DB and source extracts
        -> raw landing
        -> curated models
        -> semantic serving
        -> dashboards and analyst workflows

### Stage 3

    multiple source systems and events
        -> shared ingestion patterns
        -> lakehouse or warehouse platform
        -> domain marts and governed serving layers
        -> wider business consumption

## Why This Shape Makes Sense

- early stages optimize for speed and clarity
- later stages add raw preservation, governance, and domain separation only when needed
- the platform grows as reporting, trust, and ownership pressures grow

## Technologies Used

Possible evolution path:

- SQL and lightweight scripts early
- warehouse or lakehouse curated layers later
- dbt, Spark, or orchestrators only when the system has enough repeated complexity to justify them

## Main Trade-Offs

Benefits:

- avoids enterprise overbuild too early
- allows stronger platform patterns to appear when pressure is real
- keeps architecture aligned to business maturity

Drawbacks:

- transitional periods create temporary inconsistency
- some early shortcuts must eventually be replaced
- governance may lag unless made explicit at the right time

## Simpler Alternative

A simpler alternative is to stay forever on direct source-to-dashboard patterns.

That works only while:

- data scope stays small
- ownership is centralized
- KPI trust pressure is low

It becomes weak when several teams and several reporting layers appear.

## What To Review

- what current pain actually justifies the next layer
- whether the team is adding tools because of real repetition or because of fashion
- where raw preservation becomes necessary
- when semantic serving becomes more important than direct querying

## What Would Be Bad Here

- jumping immediately to a full event backbone and lakehouse with no workload pressure
- keeping the startup stack forever with no raw layer, no governance, and no shared definitions
- adding tools faster than ownership and operating discipline

## Lessons Learned

- strong startup architecture is usually evolutionary, not maximalist
- the correct stack depends on timing as much as on technical possibility

## Read With

- `../architecture/01_foundations/README.md`
- `../system-design/hybrid-batch-streaming.md`
- `../trade-offs/spark-vs-pandas.md`
- `../trade-offs/airflow-vs-cron.md`