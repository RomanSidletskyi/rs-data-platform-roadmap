# ADR Example

## Scenario

Choose a table-layer format for a Spark-first data platform.

## Weak Version

### Title

Use Delta Lake

### Body

We should use Delta Lake because it is popular and works well with Spark.

It seems like the best option for the platform.

## Why This Is Weak

- it does not define the constraints
- alternatives are not compared fairly
- the decision sounds like preference instead of reasoning
- no downside or revisit condition is stated

## Strong Version

### Title

Choose Delta Lake as the primary table layer for the Spark-first platform

### Context

The platform needs reliable ACID-style table updates, schema evolution support, and predictable operational patterns for Spark workloads.

The first platform phase is Spark-first rather than engine-agnostic.

### Constraints

- primary processing engine is Spark
- the team needs merge and update support for incremental pipelines
- operational simplicity matters more than theoretical multi-engine portability in phase one
- the table layer must support recoverability and clear data mutation semantics

### Options

Option A: plain Parquet plus custom metadata handling

- simpler raw format
- weak support for transactional updates
- pushes operational complexity into custom conventions and tooling

Option B: Delta Lake

- strong fit for Spark workloads
- native support for merge, schema evolution, and time travel
- tighter coupling to Spark-centric ecosystem decisions

### Decision

Choose Delta Lake as the primary managed table layer for phase one.

### Trade-offs

- we gain operational clarity and faster delivery for Spark pipelines
- we accept reduced engine neutrality compared with a more portable table strategy
- if the platform later becomes heavily multi-engine, we may need a clearer abstraction boundary or migration plan

### Consequences

- platform guidance, examples, and pipeline templates will standardize on Delta
- future architecture reviews should revisit this decision if cross-engine requirements become dominant

## Why This Is Strong

- it ties the decision to explicit phase-one constraints
- it does not pretend the chosen option is free of cost
- it leaves a clear trigger for revisiting the decision later