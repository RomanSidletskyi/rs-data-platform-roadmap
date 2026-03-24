# Workspace Operating Model And Team Boundaries

## Why This Topic Matters

Databricks is a shared platform in many organizations.

Shared platforms only stay healthy when ownership boundaries are real.

## Core Questions

The platform should be able to answer:

- who owns the workspace boundary?
- who owns compute standards?
- who owns curated data products?
- who approves changes to production jobs?
- who responds to incidents?

If those questions are vague, the platform remains operationally immature no matter how advanced the tooling looks.

## Weak Pattern

- everyone can create compute however they want
- ownership of data products is not documented
- production jobs depend on personal workspace state

## Healthy Pattern

- platform team owns standards and guardrails
- domain teams own data products
- production execution paths are explicit and versioned

## Good Strategy

- separate platform administration from domain data ownership
- make production ownership visible
- avoid building a shared workspace around informal trust alone

## Key Architectural Takeaway

Databricks is most sustainable when shared workspace use is backed by explicit ownership of standards, jobs, and data products.