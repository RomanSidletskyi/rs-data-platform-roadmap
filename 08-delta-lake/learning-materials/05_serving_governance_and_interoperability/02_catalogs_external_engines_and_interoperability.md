# Catalogs, External Engines, And Interoperability

## Why This Topic Matters

A Delta table often lives inside a wider ecosystem.

That means the table may be read by:

- Spark jobs
- Databricks SQL
- catalog-managed consumers
- other engines that understand the format and governance path

## Practical Concern

Interoperability is strongest when teams are clear about:

- which catalog governs the asset
- which engines are supported readers
- which access path is official

If those answers are unclear, teams often end up with multiple unofficial ways to read the same table and no clear consumer boundary.

## Example

Imagine a Delta table that can be accessed by:

- Spark code through a catalog table name
- Databricks SQL through a governed warehouse
- another engine through an approved interoperability path

That can be healthy, but only if the platform is explicit about:

- which path is recommended for which consumer
- which catalog metadata is authoritative
- whether external engines see the same governed contract

Example SQL access path:

```sql
SELECT order_date, store_id, net_revenue
FROM analytics.daily_store_sales
WHERE order_date >= current_date() - INTERVAL 7 DAYS;
```

The query is simple. The hard part is ensuring that the asset behind it is governed consistently across all supported readers.

## Good Vs Bad Interoperability

Healthy interoperability:

- supported readers are known
- one catalog path is the official contract
- schema and access expectations are governed

Weak interoperability:

- users discover alternate paths informally
- external readers bypass intended governance boundaries
- different engines effectively observe different contract assumptions

## Questions To Ask

1. Which access path should consumers use first?
2. Which engines are actually supported, not just technically possible?
3. Does the catalog remain the source of truth for the asset?
4. Will an external engine reader see the same contract assumptions?
5. Who owns interoperability breakage if one engine behaves differently?

## Key Architectural Takeaway

A Delta table is more valuable when its governance and access path are clear across the wider lakehouse, not only inside one notebook.
