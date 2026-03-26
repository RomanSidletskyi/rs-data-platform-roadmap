# Unity Catalog Governance Recipe

## Goal

Apply Unity Catalog with explicit governance boundaries rather than adding objects and permissions ad hoc.

## Recipe

1. Define environment and domain boundaries first.
2. Map catalogs and schemas to those real boundaries.
3. Decide which data products are governed tables and which file assets need volumes or external locations.
4. Assign consumer and producer permissions intentionally.
5. Review whether the model supports least-privilege access and discoverability.

## Rule

Governance objects should reflect actual platform boundaries, not just whatever names seemed convenient.