# Security Boundary Recipe

## Goal

Grant the right ADLS access to the right identity at the right scope without turning convenience into long-term governance debt.

## Why This Recipe Exists

Teams regularly over-permission storage because precise boundaries were never designed.

## Use This Recipe When

Use this recipe when a new team, pipeline, or consumer needs access to ADLS.

## Recipe

1. Identify the runtime or user identity.
2. Decide whether the need is administrative, read-only, or write-capable.
3. Identify the narrowest stable path boundary that matches the need.
4. Decide whether RBAC, ACLs, or both are required.
5. Check whether inheritance helps or silently broadens risk.
6. Record why this scope exists before granting it.

## Decision Questions

1. Which identity should act?
2. What is the narrowest meaningful path scope?
3. Is this read, write, or administrative access?
4. Should permissions be inherited or explicitly scoped lower?
5. Is this operationally temporary or long-lived?

## Scenario Example

Assume a Databricks job needs write access to one raw ingestion subtree:

- `raw/crm/dynamics/customers/`

At the same time, analysts should only read this published subtree:

- `publish/finance/customer_revenue/`

Weak response:

- grant both groups wide read or write access at the container level so tickets stop arriving

Healthy response:

- give the Databricks runtime identity narrow write access to the raw subtree
- give the analytics group read access only to the publish subtree
- keep administrative storage-account management separate from dataset read and write scope

This works only if the directory structure already expresses meaningful boundaries.

## Second Scenario

Suppose a temporary migration team requests broad write access because several datasets are being reorganized.

Weak response:

- grant write access across `curated/` because the migration touches many paths

Healthier response:

- define the exact migration subtrees
- grant temporary scoped access to those subtrees only
- set an explicit cleanup review after the migration ends

Without that discipline, temporary migration access often becomes permanent governance debt.

## Edge Case Scenario

Suppose analysts complain that publish data is incomplete for debugging, so the platform team grants them broad read access across:

- `raw/`
- `curated/`
- `publish/`

At the same time, one shared service principal is allowed to write across several unrelated domains because it is “easier for operations.”

This may reduce short-term access tickets, but it creates several long-term risks:

- consumers start discovering and depending on internal working paths
- least privilege disappears because read scope no longer matches consumer purpose
- one shared automation identity becomes hard to audit and harder to retire
- future incidents are harder to reason about because too many actors can touch too many areas

The recipe should slow the team down and ask:

- which exact debugging need is missing from the publish boundary?
- does a better published interface need to be created instead of broadening access?
- can automation identities be split by domain or workflow instead of shared across the lake?

The stronger response is usually:

- improve the publish contract where needed
- keep analyst reads narrow and intentional
- keep writer identities path-scoped and workload-specific

## Practical Azure Reasoning

Use this rule of thumb:

- RBAC for broad Azure resource responsibilities
- ACLs for directory and dataset-level data access
- group-based access for humans where possible
- managed identity or dedicated service principal for automation depending on runtime model

This is not about memorizing one perfect Azure permission combination.

It is about matching the access mechanism to the actual boundary.

## Practical Review Flow

Use this sequence when granting access:

1. identify the runtime or user identity
2. identify whether the need is administrative, read-only, or write-capable
3. identify the narrowest stable path boundary
4. decide whether inheritance helps or creates risk
5. document why that scope exists

If step 3 cannot be answered cleanly, the real issue is probably bad path design, not only a permission request.

## Example Access Shapes

Healthy examples:

- a managed identity writes only to `raw/commerce/shopify/orders/`
- a finance analyst group reads only from `publish/finance/daily_revenue/`
- a platform admin group manages storage-account-wide settings without becoming the default data consumer identity

Weak examples:

- one service principal writes to raw, curated, and publish trees across many domains
- analysts are given container-wide access because published paths were never designed
- inherited write access from a broad parent path accidentally reaches consumer-facing folders

## Good Fit

This recipe fits when the team wants least privilege without breaking real workflows.

## Bad Fit

This recipe is weak when path structure is already chaotic and no one can identify ownership.

## Good Response Versus Weak Response

Weak response:

- grant broad access to the container because debugging is easier

Good response:

- choose the right identity first, then grant the smallest stable boundary that supports the intended workflow

## Expected Output Of The Recipe

The team should be able to produce a sentence like:

- managed identity `orders-ingest-prod` gets write access only to `raw/commerce/shopify/orders/`, while analysts retain read access only to `publish/finance/daily_revenue/`

If the output is only “access granted,” the recipe is not strong enough.

## When This Recipe Breaks Down

This recipe breaks down when:

- emergency exceptions become normal governance
- ownership is so unclear that nobody knows which parent path is authoritative
- storage and platform teams use different mental models of what the lake boundaries actually mean

At that point, permission cleanup alone will not solve the problem.

The storage model itself needs repair.

## Failure Modes To Watch

Warning signs include:

- many exceptions granted directly to individual users
- one shared automation identity writing across unrelated domains
- raw and publish paths inheriting the same broad writer group
- emergency troubleshooting access never being removed

Those patterns usually mean access design is reacting to incidents instead of guiding the platform.

## Final Review Questions

1. Is this identity still the correct one for the workload?
2. Is the granted scope narrower than the actual ownership boundary?
3. Will future teams understand why this access exists?
4. Is any temporary exception now behaving like a permanent rule?
5. Are we widening access because the boundary is well designed, or because the published interface is still too weak to support legitimate consumer needs?
