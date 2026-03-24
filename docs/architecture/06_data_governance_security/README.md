# Data Governance and Security

## What This Topic Is For

This topic is about ownership, access control, compliance, and auditability across the platform.

Good architecture is not only fast and scalable.

It must also make data access understandable, restricted, and reviewable.

## Core Areas

- RBAC
- lineage
- audit logs
- secrets management
- environment separation

## What To Pay Attention To

- who owns datasets, schemas, and platform layers
- who can read, write, publish, or delete data
- how sensitive data is isolated and monitored
- whether lineage and audit trails explain changes after incidents
- whether dev, test, and prod are separated in both access and behavior

## Good Architecture Signals

- least privilege is the default instead of the cleanup phase
- ownership is visible at dataset and system level
- secret handling is externalized from code and notebooks
- sensitive paths have stronger controls than general analytical paths

## Common Mistakes

- broad shared access because role design feels inconvenient
- using manual knowledge instead of lineage and audit evidence
- mixing production and sandbox behaviors in the same storage paths
- treating governance as a documentation problem only

## Real Examples To Think Through

- curated finance mart with restricted access
- raw landing zone with stronger publish controls than read-only analytical consumption
- incident review where lineage explains which upstream change broke a downstream dashboard

Worked example:

- `worked_example_sensitive_finance_access_model.md`

## Interview Questions

- What is RBAC?
- Why is lineage important?
- How do you protect PII?
- Why separate dev, test, and prod?

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_sensitive_finance_access_model.md`
- `../../trade-offs/README.md`
- `../adr/README.md`

## Completion Checklist

- [ ] I understand RBAC
- [ ] I understand least privilege
- [ ] I understand lineage and auditability
