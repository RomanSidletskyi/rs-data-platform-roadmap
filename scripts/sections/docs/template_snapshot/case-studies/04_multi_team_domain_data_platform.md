# Multi-Team Domain Data Platform

## Background

A growing company now has several platform-facing teams:

- core product engineering
- analytics engineering
- data platform
- finance analytics
- experimentation or growth analytics

The company needs a shared data platform without collapsing every concern into one giant system owned by one team.

## Problem

As teams grow, the platform must handle:

- domain ownership
- shared ingestion and storage standards
- curated data products for different consumers
- controlled access and governance
- architectural consistency without central bottlenecks

## Architecture Overview

Typical shape:

    domain systems and events
        -> shared ingestion patterns
        -> raw landing and storage contracts
        -> domain-oriented transformation layers
        -> curated marts and serving models
        -> team-specific analytical products

Shared platform capabilities usually include:

- storage standards
- orchestration patterns
- governance and access model
- observability and reliability standards

Domain teams still own business meaning.

## Why This Shape Makes Sense

- one platform team should not become owner of all business semantics
- shared infrastructure reduces duplication
- domain ownership keeps contracts and metrics understandable
- curated downstream products can vary by audience while raw and intermediate standards remain stable

## Technologies Used

Possible technology shape:

- shared lakehouse or warehouse platform
- Airflow or another orchestrator
- dbt, Spark, or Databricks transformations
- event streams for some domains
- BI or semantic-serving layers for consumption

## Main Trade-Offs

Benefits:

- clearer boundaries between infrastructure and business meaning
- shared standards without forcing one giant canonical model everywhere
- better scalability of team structure as the company grows

Drawbacks:

- governance becomes a real architecture concern
- platform standards require coordination and documentation
- domain-aligned products may create more assets than a fully centralized model

## Simpler Alternative

A simpler alternative is one centralized analytics stack owned by one team.

That may work early, but becomes weak when:

- too many teams depend on one backlog
- business semantics diverge by domain
- ownership and metric changes become unclear

## What To Look At In Review

- which layers are shared platform responsibility versus domain responsibility
- whether storage and naming contracts are explicit
- how sensitive data and domain access are controlled
- whether one team has become an accidental bottleneck for everyone else

## What Would Be Bad Here

- one global data model with weak domain ownership
- platform team responsible for all business semantics
- duplicated team-specific pipelines with no shared standards
- no governance around naming, publish, and serving boundaries

## Lessons Learned

- multi-team data platforms work best when shared infrastructure and domain ownership are both explicit
- architecture quality depends as much on ownership shape as on technical stack choice

## Read With

- `../architecture/06_data_governance_security/README.md`
- `../architecture/07_scalability_reliability/README.md`
- `../architecture/adr/README.md`
- `../trade-offs/dbt-vs-sql-scripts.md`