# Governance And Security Review Checklist

## Purpose

Use this checklist when reviewing ownership, access, secrets, compliance boundaries, and auditability.

## Ownership

- who owns each critical dataset or serving layer
- who approves schema or access changes
- is accountability visible in normal operation, not only during incidents

## Access Control

- is least privilege the default
- who can read, publish, modify, or delete sensitive data
- are sandbox and production paths isolated clearly

## Auditability

- what evidence exists after an incident
- can lineage explain why a downstream table changed
- are secret-management and access events reviewable

## Risk Review

- where could broad shared access create hidden risk
- what manual process should become platform enforcement
- what data product would cause the highest damage if misconfigured