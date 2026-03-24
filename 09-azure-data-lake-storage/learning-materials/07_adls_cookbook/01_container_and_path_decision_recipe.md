# Container And Path Decision Recipe

## Goal

Choose the smallest ADLS boundary that preserves clarity, governance, and future operability without creating storage sprawl.

## Why This Recipe Exists

Teams often ask whether a new dataset needs:

- a new storage account
- a new container
- a new top-level path
- just another subfolder

If that decision is made casually, storage sprawl or unsafe sharing follows.

## Use This Recipe When

Use this recipe when a new dataset, domain, or publish area is being introduced.

## Recipe

1. Define the owner of the dataset boundary first.
2. Decide whether the data is internal, reusable, or officially published.
3. Check whether environment, compliance, or network isolation changes materially.
4. Check whether lifecycle and access rules differ from existing boundaries.
5. Prefer the smallest boundary that still keeps those differences explicit.

## Decision Questions

Ask in this order:

1. Does this need strong environment or trust isolation?
2. Does it belong to an existing domain boundary or a new one?
3. Is it internal working data or a supported published interface?
4. Does it need separate lifecycle or access rules?

## Real Decision Flow

A practical order of reasoning is:

1. decide whether this is a new ownership boundary or only a new dataset inside an existing one
2. decide whether this dataset is internal, reusable, or officially published
3. decide whether environment isolation must happen at storage-account, container, or path level
4. decide whether lifecycle and access rules differ enough to justify a stronger storage boundary

If the answer stays inside one domain, one lifecycle class, and one trust boundary, a new top-level container is often unnecessary.

If the answer introduces a genuinely different security, ownership, or publish boundary, pushing everything into an existing path is often the bigger mistake.

## Example Scenario

Suppose a team is onboarding clickstream events.

They ask whether to create:

- a new storage account
- a new container in an existing analytics account
- or a new path under an existing raw container

Healthy reasoning might be:

- same platform and same environment as other raw ingestion data
- same broad retention class as other raw source landings
- owned by an existing digital domain team
- no special regulatory isolation requirement

That often points toward:

- existing storage account
- existing raw container
- new stable domain-aware path such as `raw/digital/web/clickstream/load_date=2026-03-24/`

Now change the scenario.

If the dataset is a regulated HR export with different access rules and strong separation requirements, a stronger top-level boundary may be justified.

## Second Scenario

Suppose a platform already has these top-level containers:

- `raw`
- `curated`
- `publish`

Now a machine-learning team wants a separate container for feature exports.

Healthy reasoning might be:

- if feature exports are still internal engineering assets with the same lifecycle and broad trust boundary as curated outputs, a new container may be unnecessary
- if they require different access, stronger isolation, or a dedicated product-style interface, a separate container or publish-style path may be justified

The point is to decide from responsibility, not from excitement about a new use case.

## Edge Case Scenario

Suppose a dashboard team starts reading from:

- `curated/analytics/final_orders/latest/`

Later, another team proposes solving the confusion by creating a brand new container named:

- `final-data`

That reaction feels decisive but may still be weak.

The problem might not be lack of containers.

The problem might be that:

- the current path never expressed ownership clearly
- the data is being treated like a published contract while still living in an internal curated area
- naming is being used to compensate for missing boundary decisions

The recipe should force the team to ask:

- does this need a new publish boundary or only a cleaner top-level published path?
- who owns the consumer contract?
- is a new container justified by lifecycle, trust, or administrative isolation, or only by current confusion?

In many cases, the stronger response is not “add one more container.”

The stronger response is:

- define the real ownership boundary
- move the supported interface into an explicit publish path
- avoid multiplying top-level storage objects without a real operating reason

## Option Comparison

When teams hesitate between storage-account, container, and path boundaries, compare them directly:

| Option | Good when | Weak when |
| --- | --- | --- |
| new storage account | environment, network, compliance, or major platform isolation truly differs | the real problem is only naming or dataset ownership |
| new container | lifecycle, trust boundary, or broad access pattern differs materially | the dataset is just one more item in an existing domain with the same rules |
| new top-level path | ownership and naming need clarity inside an existing boundary | stronger isolation or lifecycle separation is actually required |

This table is not absolute.

It is a way to avoid defaulting to whichever option feels easiest in the Azure portal.

## When Not To Use This Recipe

Do not use this recipe as a substitute for answering deeper questions such as:

- who owns the dataset definition
- who can approve schema or lifecycle change
- whether the data is internal, reusable, or published

If those are unknown, the storage decision is still premature even if the path name looks neat.

## Good Path Schema Examples

Good examples:

- `raw/finance/erp/invoices/load_date=2026-03-24/`
- `curated/commerce/orders_clean/business_date=2026-03-24/`
- `publish/finance/daily_revenue/business_date=2026-03-24/`

Weak examples:

- `new_data/`
- `finance_v2/`
- `prod-final-files/`

Good schemas reveal responsibility.

Weak schemas reveal local history and uncertainty.

## Good Fit

This recipe fits when storage boundaries are still flexible and the team wants to avoid accidental contracts.

## Bad Fit

This recipe is weak if the team skips ownership and only argues about naming style.

## Good Response Versus Weak Response

Weak response:

- put it wherever there is space

Good response:

- place it at the smallest boundary that preserves clear ownership, suitable isolation, and future operability

## Review Before Finalizing

Before creating the boundary, review:

- owner of writes
- expected consumers
- environment isolation level
- retention and cleanup policy
- whether the path is internal or contract-like

If these answers are still unclear, the storage decision is premature.

## Final Sanity Check

Before committing the boundary, ask one blunt question:

- if a new team joined tomorrow, would they understand why this boundary exists from the structure itself?

If the answer is no, the design is probably still too dependent on tribal knowledge.

Another useful blunt question is:

- are we proposing a new container because the boundary truly changed, or because the old design was vague and nobody wants to fix the naming and ownership model?

If the answer is the second one, the recipe is pointing to a design repair problem, not a storage-account explosion problem.

## Expected Output Of The Recipe

By the end of this recipe, the team should be able to say something precise like:

- this dataset stays in the existing `raw` container under `raw/digital/web/clickstream/` because ownership, lifecycle, and trust boundaries stay aligned with existing raw ingestion patterns

or:

- this dataset needs a stronger top-level boundary because it introduces a materially different environment, access, and compliance model

If the result is still only “we created another container,” the recipe was not completed properly.
