# Governance Breakdown And Recovery

## Background

A company has grown quickly and now has:

- several analytical teams
- shared storage layers
- many dashboards
- weakly controlled access

An incident reveals that a sensitive dataset was exposed too broadly and several downstream metrics cannot be traced to a stable owner.

## Problem

The platform is technically functioning, but governance quality is low.

The company must recover trust by clarifying:

- ownership
- access rules
- auditability
- lineage and change responsibility

## Architecture Overview

Recovery typically requires:

    shared raw and curated layers
        -> explicit ownership mapping
        -> role-based access redesign
        -> lineage and audit improvement
        -> restricted serving paths for sensitive domains

This is not a new pipeline problem.

It is a platform-boundary and operating-model problem.

## Why This Shape Makes Sense

- architecture trust depends on more than pipelines and dashboards
- platform growth requires explicit ownership and access boundaries
- recovery must focus on systemic controls, not only patching one incident

## Technologies Used

Possible technology shape:

- access-control layers in storage and BI platforms
- lineage tooling
- audit logs
- curated restricted marts or semantic models for sensitive data

## Main Trade-Offs

Benefits:

- stronger access control
- clearer accountability
- more reliable incident review
- better distinction between general analytical use and restricted domains

Drawbacks:

- more process and role definition
- migration effort for legacy broad-access patterns
- some analyst convenience is reduced in exchange for control

## Simpler Alternative

A simpler alternative is to keep broad access and rely on team knowledge and careful behavior.

That becomes weak as soon as:

- team count grows
- sensitive data spreads
- metric ownership becomes unclear
- audits or incidents require evidence instead of memory

## What To Review

- who owns each sensitive dataset or serving layer
- who can read, publish, or change each layer
- what audit trail exists for model and access changes
- where broad access was used as a substitute for design

## What Would Be Bad Here

- treating governance as documentation only
- fixing one dataset while keeping weak access patterns everywhere else
- leaving sensitive and general-use marts mixed together
- assuming technical lineage can replace ownership responsibility

## Lessons Learned

- governance failures are architecture failures, not only compliance failures
- trust recovery requires clearer boundaries, ownership, and restricted serving design

## Read With

- `../architecture/06_data_governance_security/README.md`
- `../architecture/09_architecture_case_studies/worked_example_how_to_read_a_famous_architecture.md`
- `../trade-offs/airflow-vs-cron.md`
- `../trade-offs/dbt-vs-sql-scripts.md`