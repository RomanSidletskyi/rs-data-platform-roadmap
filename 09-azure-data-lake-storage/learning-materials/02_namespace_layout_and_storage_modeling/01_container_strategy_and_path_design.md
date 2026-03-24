# Container Strategy And Path Design

One of the highest-leverage storage decisions is how you divide data between containers and paths.

This should never be random.

## Bad Default Pattern

A weak team often creates:

- one container for everything
- folders added opportunistically by whichever pipeline came first
- environment names mixed into random places
- no clear distinction between internal and publishable paths

This feels flexible at the beginning.

Later it becomes ungovernable.

## Better Design Principle

Use containers for large, deliberate boundaries.

Use paths for dataset and workflow organization inside those boundaries.

That usually means containers are good for separating concerns such as:

- raw landing versus curated outputs
- analytics platform versus application exports
- major trust or ownership domains
- sometimes environment isolation when required by governance

Then use paths to express:

- source system
- domain
- dataset name
- processing zone
- business date or partition keys

## Example

A stronger layout might look like this:

- `raw/retail/erp/orders/business_date=2026-03-24/`
- `curated/commerce/orders_clean/business_date=2026-03-24/`
- `publish/finance/daily_revenue/business_date=2026-03-24/`

The important feature is not the exact words.

The important feature is that the path model expresses responsibility and intent.

## Example Path Schema

One healthy way to think about path design is to define a reusable schema before pipelines are built.

For example:

```text
<container>/<zone>/<domain>/<source_or_product>/<dataset>/<partition_key>=<value>/
```

Concrete examples:

```text
raw/commerce/shopify/orders/load_date=2026-03-24/
curated/commerce/orders_clean/business_date=2026-03-24/
publish/finance/daily_revenue/business_date=2026-03-24/
```

That schema is useful because it separates several concerns cleanly:

- zone responsibility
- business ownership
- source lineage or product identity
- dataset name
- replay or partition boundary

## Real Azure Design Scenario

Assume a platform has these consumers:

- ingestion pipelines writing source-shaped ERP files
- Databricks jobs building cleaned internal datasets
- Power BI or Fabric consumers needing stable published outputs

A weaker storage design may put all of this into one container such as:

- `lake/data/...`

That feels simple, but later creates problems around:

- broad ACL inheritance
- unclear raw versus publish boundaries
- environment drift
- consumer teams discovering internal folders accidentally

A stronger design could be:

- container `raw` for source-faithful landed data
- container `curated` for internal reusable engineering outputs
- container `publish` for supported downstream interfaces

Then each container uses a stable internal path schema.

This is not the only valid design.

But it is an example of choosing containers because they express meaningful governance and operating boundaries, not because teams happened to create them over time.

## Container Trade-Offs

Too few containers can produce:

- noisy governance
- unclear isolation
- hard-to-manage permissions

Too many containers can produce:

- operational sprawl
- inconsistent standards
- duplicated patterns that differ only because teams improvised

A healthy design picks a small number of meaningful top-level boundaries, then enforces consistency below them.

## Good Fit Versus Bad Fit

Good fit for a new container:

- materially different trust boundary
- materially different lifecycle policy
- materially different human or service access pattern
- materially different environment or compliance need

Bad fit for a new container:

- a single team wants a separate folder to feel ownership
- a temporary project needs somewhere to experiment
- naming confusion is being solved by adding another top-level resource

If the real problem is weak naming or unclear ownership, adding containers may only hide the design mistake.

## Path Design Rules

Good path design is:

- stable
- readable
- domain-aware
- explicit about what is internal versus publishable
- compatible with replay and partitioning strategy

Good path design is not:

- driven by temporary project names
- full of version fragments without governance
- mixing ingestion metadata and business semantics carelessly

## Anti-Patterns To Avoid

Common storage anti-patterns include:

- `final/`, `final_v2/`, `really_final/`
- one dataset split across several differently named root folders
- using project names as long-term platform path boundaries
- environment names embedded inconsistently in the middle of paths
- landing runtime checkpoint or temporary files next to consumer-facing data

These patterns usually signal that path design followed delivery pressure rather than architecture.

## Review Questions

1. What kinds of concerns belong at the container level rather than only in paths?
2. What makes a path stable enough to become an internal or external contract?
3. When does container sprawl become a real platform problem?
