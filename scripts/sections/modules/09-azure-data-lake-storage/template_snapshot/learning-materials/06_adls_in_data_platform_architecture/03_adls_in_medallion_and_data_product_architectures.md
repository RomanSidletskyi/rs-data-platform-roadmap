# ADLS In Medallion And Data Product Architectures

ADLS can support both medallion-style layouts and more domain-oriented data-product thinking.

The challenge is to avoid turning either pattern into folder theater.

## ADLS In Medallion Layouts

A medallion-oriented design may use storage boundaries for:

- raw or bronze-like landing
- cleaned or silver-like reusable data
- gold or publish-like consumer outputs

That can be useful.

But the storage layout should still reflect ownership, trust level, and consumer expectations rather than only color names.

## Real Medallion Example

Consider a commerce domain with these paths:

- `raw/commerce/shopify/orders/load_date=2026-03-24/`
- `curated/commerce/orders_clean/business_date=2026-03-24/`
- `publish/commerce/daily_sales/business_date=2026-03-24/`

This can be a healthy medallion-style storage design if the boundaries really mean:

- raw preserves source fidelity and replay capability
- curated is reusable internal engineering data
- publish is the supported downstream interface

It becomes weak if the team only renamed folders while keeping:

- unclear ownership
- unstable path contracts
- consumer reads directly from internal engineering layers

## ADLS In Data Product Thinking

A data-product architecture often demands stronger emphasis on:

- explicit ownership
- supported interfaces
- published paths
- lifecycle and change discipline

In this model, storage paths may be one visible part of the product boundary, but not the whole product.

## Data Product Consequence

Data-product thinking raises the bar for what a storage path implies.

A published path should usually carry stronger expectations around:

- named ownership
- lifecycle discipline
- allowed change patterns
- consumer supportability

That does not mean every dataset becomes a formal product.

It means published storage boundaries should stop being treated as casual engineering leftovers.

## Common Mistake

A common mistake is to create medallion folders and assume architecture is now complete.

It is not.

If no one owns the boundaries, if consumer rules are unclear, or if publish paths are unstable, the architecture is still weak.

## Good Versus Weak Architecture

Weak architecture:

- `bronze`, `silver`, and `gold` exist only as folder names
- teams still disagree on who owns which layer
- consumers read from whichever layer is easiest to discover

Healthy architecture:

- each layer has a reason to exist
- ownership and consumer expectations change deliberately across layers
- publish or product-like paths are treated as stronger boundaries than internal engineering areas

## Why This Matters For The Cookbook

The cookbook decisions about:

- containers and paths
- security boundaries
- publish paths
- cleanup and retention

all become stronger when medallion and product boundaries are real rather than cosmetic.

## Review Questions

1. Why are medallion folder names not enough by themselves?
2. How does data-product thinking change expectations around ADLS paths?
3. What should storage boundaries communicate beyond simple processing stage names?
