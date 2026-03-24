# Case Study: Self-Service Analytics Platform For Domain Teams

## Scenario

A central data team has become a bottleneck.

Product, marketing, finance, and operations all depend on one queue for new models, dashboards, and access requests.

Leadership wants domain teams to move faster without losing consistency, governance, or metric trust.

## Main Problem

The platform must distribute analytical capability to domains while preserving shared standards and common governance.

## Why A Simpler Design Is Not Enough

A fully centralized analytics model worked when the business had fewer domains and a smaller backlog.

That design now fails because:

- delivery speed is too slow
- central experts become gatekeepers for every request
- domain context is lost in translation
- business teams create shadow spreadsheets and unofficial marts

## High-Level Architecture

    Shared Data Platform
        ->
    Standardized Ingestion / Modeling / Access Patterns
        ->
    Domain-Owned Data Products
        ->
    Shared Semantic Rules / Governance / Catalog
        ->
    BI, notebooks, and domain consumers

## Key Decisions

### Shared Platform, Distributed Ownership

The central team owns platform capabilities while domains own the meaning and delivery of their data products.

### Guardrails Instead Of Ticket Queues

The company replaces manual central approval for every task with templates, standards, and review boundaries.

### Catalog And Discoverability Matter

Self-service only works when users can find trustworthy assets and understand ownership.

## What Makes This Architecture Strong

- domain teams move faster close to their business context
- the central team scales through standards rather than hand-built delivery
- governance is preserved through platform constraints and review points

## What Could Go Wrong

- domains are told they own data products but lack real platform support
- standards are too weak and every domain reinvents modeling conventions
- semantic definitions drift between teams
- discoverability is poor, so self-service becomes self-confusion

## Simpler Alternative

Keep analytics centralized but create stronger intake prioritization.

That remains valid when domain maturity is low and shared governance is not yet stable enough for distributed ownership.

## Lessons Learned

- self-service analytics is an operating model, not only a tooling choice
- domain ownership works only when platform guardrails are concrete
- shared meaning, cataloging, and access patterns matter as much as compute and storage

## Read With

- `../architecture/05_serving_and_bi_architecture/README.md`
- `../architecture/06_data_governance_security/README.md`
- `../case-studies/04_multi_team_domain_data_platform.md`
- `../trade-offs/dbt-vs-sql-scripts.md`