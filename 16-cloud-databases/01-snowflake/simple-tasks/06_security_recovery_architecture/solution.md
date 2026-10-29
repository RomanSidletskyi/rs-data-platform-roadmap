# Solution: Task Set 06

## Task 1

A secure view can expose a controlled projection and filter. Masking and row access policies can centralize reusable protection across access paths. A curated table can create an explicit data product boundary but adds copy, freshness, and lifecycle responsibilities. Verify grants and policies across every alternate path and test with the partner role.

## Task 2

Test active-role inheritance, database and schema `USAGE`, object `SELECT`, managed-access behavior, current and future grants, policy context, and absence of broader roles. Confirm the role is assigned only to intended identities and audit the result.

## Task 3

Accidental update: Time Travel or a tested restore procedure within retention. Bad deployment: versioned code, validation, and data-aware rollback/forward fix; a code revert may not undo data changes. Source corruption: source replay or retained raw data plus reconciliation. Regional outage: supported replication/failover plus application, identity, integration, and consumer cutover. Fail-safe is not an ordinary customer-operated backup.

## Task 4

Include replication lag and promotion, roles, integrations, network connectivity, application endpoints, orchestration, secrets, consumer cutover, data validation, operator access, communication, and failback. Test actual time against the four-hour objective.

## Task 5

Answers vary. A strong proposal ties boundaries to requirements, considers both shared-account and separate-account alternatives, specifies ownership and promotion, records cost/security/recovery impacts, defines observable failure modes, and names evidence that would trigger redesign.