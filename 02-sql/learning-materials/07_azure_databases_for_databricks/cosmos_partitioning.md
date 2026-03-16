# CosmosDB Partitioning

Partitioning is one of the most important design decisions in CosmosDB.

## Good Partition Key Should

- distribute data well
- distribute traffic well
- align with common query paths
- avoid hot logical partitions

## Example

Good candidate:

```text
/customer_id
```

if common access pattern is customer-local.

## Bad Example

```text
/status
```

if one status dominates.

## Main Cost Rule

Queries that do not align with partitioning are often more expensive and slower.
