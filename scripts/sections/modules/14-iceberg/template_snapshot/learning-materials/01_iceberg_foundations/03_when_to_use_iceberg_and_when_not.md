# When To Use Iceberg And When Not

## 1. Use Iceberg When

Iceberg is a strong fit when:

- multiple engines must read the same table contract
- table history matters
- schema evolution needs to be explicit and safe
- partition layout should evolve without rewriting consumer logic
- object storage is the durable data layer
- teams need a formal metadata control plane above files

Good examples:

- lakehouse curated zones shared by Spark, Trino, Athena, or Snowflake-like engines
- long-lived analytical contracts in open storage
- datasets that need time travel or snapshot-based rollback reasoning

## 2. Use It Carefully When

Iceberg can be valid but not automatically necessary when:

- only one engine consumes the data today
- platform ownership is still immature
- the team wants table-format features but has no operational discipline yet

In those cases, Iceberg may still help, but it can also expose weak operating models faster.

## 3. Do Not Use It By Default When

Iceberg is often the wrong default when:

- a warehouse-native table solves the problem better
- the data is short-lived staging output
- the team does not need multi-engine interoperability
- the overhead of metadata and catalog operations is not justified
- the platform cannot clearly own maintenance and catalog governance

If the real need is only:

- fast internal analytics in one warehouse

then native warehouse tables may be simpler and better.

## 4. Common Wrong Reasons To Adopt It

Bad reasons include:

- “open format sounds future-proof”
- “everyone is talking about lakehouse”
- “we might need another engine someday”
- “it feels more advanced than parquet folders”

These are not architecture reasons.

## 5. Architect Heuristic

Ask these questions:

1. Do we need a real table control plane above files?
2. Do multiple engines really need to share it?
3. Who owns the catalog, maintenance, and recovery model?
4. Are we solving a present problem or collecting fashionable complexity?

If those answers are weak, the Iceberg decision is weak.