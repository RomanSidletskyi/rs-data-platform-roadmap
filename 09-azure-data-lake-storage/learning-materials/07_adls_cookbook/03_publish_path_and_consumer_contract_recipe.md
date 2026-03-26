# Publish Path And Consumer Contract Recipe

## Goal

Create a storage boundary that downstream users can rely on without coupling them to unstable internal engineering paths.

## Why This Recipe Exists

Many consumer incidents begin when an unofficial engineering path quietly becomes a production dependency.

## Use This Recipe When

Use this recipe when an output is about to be shared with analysts, dashboards, applications, or other teams.

## Recipe

1. Decide whether the current path is internal or truly publishable.
2. Name the owning team and supported consumer group.
3. Define the grain, refresh rhythm, and lifecycle expectation.
4. Create a cleaner publish boundary if the current path still reflects engineering work in progress.
5. Review whether schema and file-shape changes need explicit contract review.

## Decision Questions

1. Is this path internal or officially supported?
2. Who owns schema and lifecycle changes?
3. What is the stable grain or refresh expectation?
4. Can this path move without downstream breakage?
5. Does a safer publish boundary need to be created first?

## Example Scenario

Suppose a finance dashboard currently reads from:

- `curated/finance/revenue_model/tmp_daily_output/`

The data itself may look correct.

But the path is a weak consumer boundary because it signals:

- temporary intent
- engineering ownership rather than publish ownership
- likely instability in lifecycle or schema behavior

A stronger response is to create an explicit publish path such as:

- `publish/finance/daily_revenue/business_date=2026-03-24/`

Then define:

- expected grain
- refresh rhythm
- change owner
- whether old snapshots are retained or replaced

## Second Scenario

Suppose a machine-learning feature team wants product analysts to read from a curated feature export path.

The path may be technically queryable.

That is not enough.

The recipe should force the team to ask:

- is this feature export meant to be a stable interface or only an internal model input?
- who approves changes in file shape or partitioning?
- should analysts instead receive a cleaner publish path derived from the same data?

If those questions are skipped, the consumer contract is weak even if the data is correct.

## Edge Case Scenario

Suppose a team says:

- the dashboard already works
- the curated path is queryable
- we can document that path in Slack for now

The current path is:

- `curated/finance/revenue_model/hotfix_output_v2/`

This is exactly the kind of situation where consumer incidents start later.

The path is weak because it signals:

- hotfix or temporary intent
- internal engineering ownership
- likely instability in schema, lifecycle, or replacement behavior

The recipe should not accept “but it works today” as enough.

It should force the team to ask:

- is this path intended to survive the next pipeline refactor?
- will consumers know whether the output is append-only, snapshot-like, or temporary?
- who reviews breaking schema changes if this becomes a real dependency?

The stronger response is to create a real publish boundary before the path becomes an accidental contract.

That is often slower in the current sprint and much cheaper over the next six months.

## Published Path Checklist

Before calling a path published, clarify:

- is the directory stable enough to survive internal pipeline refactors?
- is ownership named at the team level rather than only the individual engineer level?
- does the consumer know whether the path is append-only, snapshot-like, or replaced in place?
- is there a safer published alias or top-level boundary if the current one is too engineering-shaped?

If these answers are weak, the path is probably still an internal engineering area.

## Concrete Good And Bad Examples

Healthier publish paths:

- `publish/finance/daily_revenue/business_date=2026-03-24/`
- `publish/commerce/customer_360/snapshot_date=2026-03-24/`

Weaker consumer paths:

- `curated/finance/tmp_revenue_fix/`
- `silver/customer_360_rebuild_v3/`
- `analytics/test-output/`

The healthier names signal support and intent.

The weaker names signal internal work in progress.

## Good Fit

This recipe fits when the team wants to distinguish supported outputs from internal storage layout.

## Bad Fit

This recipe is weak if the team tries to promise contracts through unstable temporary paths.

## Good Response Versus Weak Response

Weak response:

- tell consumers which folder we currently use

Good response:

- create and govern a deliberate publish path with clear ownership and change expectations

## Expected Output Of The Recipe

The final output should sound like:

- `publish/finance/daily_revenue/` is the supported consumer path, owned by the finance data team, refreshed daily, and treated as the only stable storage boundary for dashboard consumers

That is much stronger than saying:

- consumers can use the current curated folder for now

## Healthy Publish Checklist

Before exposing a path, verify:

- the path name does not look temporary
- the owning team is explicit
- the refresh pattern is understood
- schema and file-shape changes have a review expectation
- consumers are not coupled to internal runtime folders or checkpoint areas

If these are missing, the path may still be valid technically but weak operationally.

## When Not To Publish A Path Yet

Do not publish a path yet if:

- the schema is still changing without review discipline
- the path name still reflects migration or temporary project language
- the owning team is not ready to support consumer questions
- the storage layout is optimized for internal compute retries rather than stable access

It is better to delay publication than to create a weak contract that consumers will later depend on.

## Final Review Questions

1. If the pipeline is refactored next month, can this publish path remain stable?
2. Would a new consumer understand the boundary from the path and documentation alone?
3. Are consumers relying on this path because it is supported or only because it was discoverable?
4. Are we delaying a proper publish boundary because the internal path happens to work today?
