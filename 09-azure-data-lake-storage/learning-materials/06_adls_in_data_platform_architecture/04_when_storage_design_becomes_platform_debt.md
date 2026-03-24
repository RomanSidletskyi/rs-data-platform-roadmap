# When Storage Design Becomes Platform Debt

Storage debt often accumulates quietly.

Unlike a failing job, it may not break immediately.

It just makes everything around it harder.

## Signs Of Storage Debt

Common signs include:

- duplicated datasets across unclear paths
- environment mixing
- weak naming discipline
- too many broad access exceptions
- publish paths that changed repeatedly over time
- consumers depending on unofficial internal folders
- operational pain caused by file-count growth and weak cleanup

## Real Debt Scenario

Consider a platform that started with a few ingestion jobs and later added:

- Databricks engineering pipelines
- SQL consumers
- Power BI or Fabric reporting
- several backfill and migration efforts

If storage rules were never tightened, the lake may now contain:

- old and new versions of the same dataset under different paths
- publish-like folders that were never formally approved
- consumer teams reading from internal curated rebuild paths
- broad permissions kept in place because cleanup feels risky

Nothing may be fully broken.

But every future migration, governance step, or contract cleanup becomes more expensive.

## Why It Becomes Platform Debt

These are not only storage inconveniences.

They increase the cost of:

- onboarding
- governance
- incident response
- migration
- platform standardization
- introducing catalogs or stronger contracts later

Storage debt is expensive because it multiplies coordination cost.

Teams no longer debate only technical layout.

They also debate:

- who depends on which unofficial path
- who is allowed to rename or delete anything
- which boundary is actually the source of truth

That is why storage debt quickly becomes platform debt.

## Healthy Response

A healthy platform periodically asks:

- which paths are still justified?
- which boundaries are unofficial but widely depended on?
- where did convenience become hidden contract?
- where should storage be simplified before more tools are layered on top?

## Good Versus Weak Response

Weak response:

- keep adding wrappers and exceptions around old path structure

Healthy response:

- identify which boundaries are still worth keeping, which should be formalized, and which should be retired before new tooling makes the debt harder to unwind

## Repair Strategy

When storage debt is visible, a useful repair order is:

1. find unofficial but high-dependency paths
2. identify which should become governed publish boundaries
3. identify which should be deprecated and migrated away
4. tighten naming, lifecycle, and access rules around the surviving boundaries

This is usually safer than trying to reorganize the whole lake at once.

## Review Questions

1. Why can unofficial path dependencies become one of the most expensive forms of platform debt?
2. Which signs suggest a storage problem is already bigger than storage?
3. Why is early cleanup cheaper than late standardization?
