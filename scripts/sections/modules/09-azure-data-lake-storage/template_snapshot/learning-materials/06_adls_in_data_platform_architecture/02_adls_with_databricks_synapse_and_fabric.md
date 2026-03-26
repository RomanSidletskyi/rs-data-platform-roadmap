# ADLS With Databricks Synapse And Fabric

ADLS often sits below several compute and analytics surfaces in the same organization.

That makes architecture boundaries more important, not less.

## ADLS With Databricks

In Databricks-oriented architectures, ADLS is commonly the external storage foundation under lakehouse workloads.

Important questions include:

- which paths are internal engineering data versus governed outputs?
- how is access delegated to compute?
- what path boundaries align with medallion or domain design?

Practical example:

- Databricks jobs may write raw and curated engineering layers into ADLS-backed paths
- those paths may still be poor direct consumer interfaces if they are optimized for engineering replay rather than stable access

That means a successful Databricks pipeline does not automatically produce a good published storage boundary.

## ADLS With Synapse

Synapse may interact with ADLS in more SQL-oriented and integrated analytics flows.

This can increase the need for clarity around:

- which storage paths are query-friendly
- which paths are operationally internal
- how published data is exposed consistently

If Synapse or a SQL-oriented consumer reads directly from unstable engineering paths, storage design becomes part of query instability.

The path may exist.

That does not mean it should be treated as a contract.

## ADLS With Fabric

Fabric or similar analytics layers may further abstract storage away from some users.

That does not remove the need for good storage design underneath.

It just means bad storage decisions may stay hidden until scale, governance, or interoperability pressure reveals them.

This is a dangerous success pattern.

The abstraction makes the platform feel simpler for consumers while the underlying lake accumulates ambiguous paths, duplicated outputs, or weak ownership boundaries.

Later, when another tool or team needs to share the same storage, those hidden weaknesses become visible quickly.

## Cross-Platform Scenario

Consider this setup:

- Databricks writes internal curated paths
- Synapse analysts discover and query some of those paths directly
- Fabric reports later rely on a different exported view of the same data

If no publish boundary was designed intentionally, three problems often appear:

- duplicated logic about which path is authoritative
- consumers depending on internal engineering structure
- storage cleanup becoming politically difficult because every folder might break someone

The underlying storage problem is really a boundary-design problem.

## Architecture Rule

Compute and analytics layers should consume ADLS through intentional boundaries.

They should not all improvise their own storage conventions independently.

## Healthy Versus Weak Architecture

Weak architecture:

- every compute surface creates its own favorite path conventions on the same lake

Healthy architecture:

- the lake has shared storage rules, shared publish expectations, and tool-specific access patterns that still respect common ownership and contract boundaries

## Review Questions

1. Why does shared use of ADLS across multiple platforms increase the need for path governance?
2. What storage questions should be answered before several compute layers read the same lake?
3. Why can abstraction in upper layers hide bad storage design temporarily but not permanently?
