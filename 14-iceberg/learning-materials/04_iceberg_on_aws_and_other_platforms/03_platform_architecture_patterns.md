# Platform Architecture Patterns

## 1. Pattern: Spark Writes, Many Engines Read

This is one of the most common Iceberg patterns.

Shape:

- Spark owns heavy writes and transformations
- Iceberg stores table state in open storage
- other engines read for ad hoc SQL, BI, or specialized compute

This is strong because it uses Spark where it is good and still preserves an open read contract.

## 2. Pattern: Domain Contracts In Open Storage

In a mature platform, a domain team can publish a curated Iceberg table as a contract.

This is strong when:

- consumers need a stable analytical table
- ownership is clear
- evolution rules are controlled

## 3. Pattern: One Catalog, Many Teams

A central catalog can work well if:

- namespace governance is strong
- table creation rules are explicit
- platform team owns access and maintenance standards

This can become weak if:

- everyone can publish freely without governance

## 4. Anti-Pattern: Iceberg Everywhere

Iceberg is not the right answer for every output.

If teams make every intermediate or short-lived dataset an Iceberg table, they often create:

- too much metadata overhead
- unclear lifecycle ownership
- maintenance debt

## 5. Architect Rule

Use Iceberg where long-lived, governed, engine-shared tables matter.

Do not turn every file-producing step into a full platform contract.