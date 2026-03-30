# Catalog And Platform Decision Recipe

## Goal

Choose a practical first architecture instead of choosing by fashion.

The point is not to compare brands.

The point is to choose the simplest control plane that still matches real interoperability and governance needs.

## Decision Flow

### Case 1: AWS-centered platform

Default starting point:

- S3
- Glue catalog
- Spark or EMR for writes
- Athena or Trino for reads

Use when:

- AWS is already the real platform center

Representative first stack:

- S3 for data and metadata files
- Glue catalog
- Spark or EMR for writes
- Athena for selective reads

### Case 2: Shared REST catalog strategy

Default starting point:

- object storage
- REST-based catalog service
- Spark as primary write engine
- multiple engines as controlled readers or writers

Use when:

- platform wants explicit multi-engine metadata control plane

Good fit when:

- multiple engines need one explicit API surface
- metadata governance should be service-oriented

### Case 3: Snowflake-centered analytical platform

Question first:

- do we need Iceberg as an open contract or do native Snowflake tables solve the real need better?

If open contract is not truly needed, do not adopt Iceberg only for style.

### Case 4: Simpler single-engine analytics team

Default starting point:

- warehouse-native tables
- no Iceberg unless open-table requirements are real

Use when:

- there is no genuine multi-engine need
- one warehouse already solves the real problem well

## Decision Checklist

1. Do we truly need open-table interoperability?
2. Which engine is the primary writer?
3. Which systems must read the same contract?
4. Who owns the catalog and namespace model?
5. Do we need row-level mutations or mostly append workloads?
6. Are maintenance and retention responsibilities clear?

## Rule Of Thumb

- choose catalog and engine strategy based on real ownership and interoperability needs
- do not optimize first for marketing language like “open” or “lakehouse-native”

## Anti-Pattern

Bad reason to choose Iceberg:

- the team wants to look modern

Good reason to choose Iceberg:

- the platform genuinely needs metadata-governed open table contracts across engines