# Costs, Small Files, And Failure Modes

## 1. Small Files Are One Of The Biggest Real Problems

Small files hurt Iceberg because they increase:

- planning overhead
- manifest growth
- scan inefficiency
- maintenance load

This is not unique to Iceberg, but Iceberg makes the metadata consequences more visible.

## 2. Cost Is Not Only Storage Cost

When teams discuss cost, they often think only about object storage.

But Iceberg cost also includes:

- metadata operations
- compute used for planning and maintenance
- retry and conflict overhead
- operational debugging effort

## 3. Common Failure Modes

Common Iceberg failure modes include:

- commit conflicts under concurrent writers
- bloated manifests
- stale or broken catalog configuration
- uncontrolled schema evolution
- mutation-heavy workloads that the platform handles poorly

## 4. Why Failure Analysis Must Be Layered

When an Iceberg table fails, the cause may be in:

- object storage layout
- metadata structure
- catalog behavior
- engine compatibility
- maintenance neglect

This is why debugging Iceberg is a systems problem, not only a SQL problem.