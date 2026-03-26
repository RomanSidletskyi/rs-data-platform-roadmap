# Solutions: Security Identity And Governance

## Task 1

RBAC controls access at broader Azure resource scopes.

ACLs refine access inside the ADLS namespace.

RBAC alone is often too broad when different teams need different rights on different dataset paths.

## Task 2

Human access is appropriate for approved inspection and operational support.

Group-based access is preferred for maintainable human authorization.

Service principals are useful for application identities when managed identity is not available.

Managed identities are usually the cleaner option for Azure-hosted workloads because secret handling is reduced.

## Task 3

Inheritance helps scale access rules across deep directory trees.

It hurts when a broad permission is inherited into sensitive areas that should have narrower controls.

## Task 4

Governance also includes naming, ownership, network boundaries, secret handling, retention, publish contracts, and auditability.

Permissions alone do not define whether storage is safely governed.

## Task 5

Broad read access encourages accidental dependence on raw or working paths and weakens the distinction between internal engineering data and supported consumer interfaces.

A healthier model gives consumers narrow read access to approved publish paths and keeps broader internal access limited to the workloads or teams that actually need it.
