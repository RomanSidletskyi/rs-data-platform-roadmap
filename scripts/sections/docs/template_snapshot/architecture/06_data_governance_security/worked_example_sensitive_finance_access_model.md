# Worked Example - Sensitive Finance Access Model

## Scenario

A company has finance data with:

- payroll-adjacent metrics
- margin details
- refunds and adjustments

Several teams need analytics, but not everyone should see the same level of detail.

## Why Governance And Security Matter Here

- the data is business-sensitive
- metric trust depends on lineage and ownership
- access mistakes can become real incidents, not just technical bugs

## Architecture Shape

    raw landing
        -> curated finance marts
        -> restricted semantic model
        -> role-based dashboard access

## What Good Looks Like

- finance domain ownership is explicit
- access follows least privilege
- sensitive tables and views are separated from general marts
- lineage explains how reported metrics were produced
- dev and prod access are not interchangeable

## What Bad Looks Like

- broad workspace access because fine-grained roles feel inconvenient
- finance data exposed through shared analytical sandboxes
- secrets embedded directly in notebooks or scripts
- no audit trail for who changed a model or dataset

## Questions To Review

- who may publish or alter finance-facing models
- who may read detailed versus aggregated views
- what audit evidence exists after an incident
- how lower environments avoid containing unsafe production-like exposure

## Key Takeaway

Governance and security are architecture decisions about ownership, exposure, and auditability, not only permission checkboxes.