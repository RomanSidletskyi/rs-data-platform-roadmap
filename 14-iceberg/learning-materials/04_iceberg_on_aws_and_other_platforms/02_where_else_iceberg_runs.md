# Where Else Iceberg Runs

## 1. Iceberg Is Not An AWS-Only Story

Iceberg is often first learned through AWS examples, but it is much broader than that.

It appears across:

- Spark ecosystems
- Flink ecosystems
- Trino and Presto-style query layers
- Databricks-adjacent or mixed lakehouse patterns
- Snowflake interoperability discussions
- managed catalog services and REST-based control planes

## 2. Compute Engines

Common compute or query engines include:

- Spark
- Flink
- Trino
- Athena
- Dremio-like engines
- Snowflake in interoperability scenarios

The key rule is:

- Iceberg is multi-engine in principle
- but exact capabilities vary by engine and version

## 3. Cloud And Platform Contexts

You see Iceberg across:

- AWS with S3 and Glue
- Azure with ADLS and Spark-based engines
- GCP with Cloud Storage and Spark or query-engine integrations
- mixed multi-cloud or platform-neutral REST catalog designs

## 4. Why “Where Else” Matters

This is important because Iceberg adoption is often really about avoiding lock-in to one compute engine.

But architecturally, “multi-engine possible” does not mean “all engines support all operations equally.”

Teams still need an interoperability matrix, not only a marketing statement.

## 5. Architect View

The more engines you add, the more important these become:

- catalog discipline
- compatibility testing
- mutation support boundaries
- maintenance ownership

Open formats reduce lock-in, but they also make compatibility governance more important.