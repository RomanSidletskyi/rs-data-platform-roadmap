# Naming Conventions Partition Paths And Environment Isolation

Naming rules look boring until inconsistent names begin to break trust in the storage layer.

At that point, every team spends extra time guessing what a path means.

## Why Naming Matters

Naming conventions create:

- readability
- searchability
- consistency across teams
- safer automation
- lower onboarding friction

A storage platform without naming standards becomes harder to navigate long before it becomes technically impossible to use.

## What Naming Should Encode

A good path name often encodes some combination of:

- domain or business area
- dataset name
- source system
- zone
- partition or processing keys
- sometimes environment, if environments are not already isolated elsewhere

But naming should encode stable meaning, not temporary project history.

## Partition Paths

Partition directories should be predictable and purposeful.

Examples:

- `business_date=2026-03-24`
- `country_code=PL`
- `load_date=2026-03-24`

Good partition naming helps both humans and engines.

Bad partition naming mixes business and technical meanings carelessly or creates inconsistent patterns across datasets.

## Environment Isolation

Environment separation must be intentional.

Common options include:

- separate storage accounts per environment
- separate containers per environment
- separate root paths per environment

The right choice depends on governance, scale, network boundaries, and operational simplicity.

The wrong choice is accidental mixture.

If production and development paths live side by side without clear controls, a future incident is already forming.

## Good Versus Bad Examples

Healthier examples:

- `prod/curated/commerce/orders_clean/business_date=2026-03-24/`
- `dev/raw/crm/customers/load_date=2026-03-24/`

Weaker examples:

- `new_orders/`
- `orders_final_v2/`
- `tmp_prod_data/`

The healthier names communicate stable intent.

The weaker names communicate migration anxiety and local improvisation.

## Review Questions

1. What kinds of information should naming conventions capture consistently?
2. Why is environment isolation a platform decision rather than only a naming style?
3. What naming patterns suggest hidden platform debt?
