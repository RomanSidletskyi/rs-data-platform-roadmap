# Permissions, Secrets, And Identity Boundaries

## Why This Topic Matters

Managed data platforms fail quietly when identity and secret boundaries are weak.

The code still runs, but ownership and auditability degrade over time.

## Permissions

Permissions should reflect:

- who owns a data product
- who consumes it
- who administers the platform boundary

They should not exist as one giant shared-access default because the team wants less friction.

## Secrets

Secrets matter because pipelines still need credentials, tokens, and storage access references.

Weak secret handling often leads to:

- notebook-local hidden assumptions
- manual environment setup no one can reproduce
- copied credentials across workspaces

## Identity Boundaries

Identity matters at several levels:

- human users
- service principals or automation identities
- storage access identities
- BI or downstream consumer identities

Healthy platforms explain clearly which identity is acting at each step.

## Good Strategy

- map permissions to ownership and consumption boundaries
- keep secrets in governed platform mechanisms rather than embedded notebook state
- make human and service identity flows explicit

## Key Architectural Takeaway

Databricks governance is only as trustworthy as the identity and secret boundaries behind the visible workspace features.