# Hot Partitions And Scaling Limits

## Why This Topic Matters

Kafka scales well, but not automatically in every shape.

A common reason for unexpected bottlenecks is the hot partition problem.

## What A Hot Partition Is

A hot partition receives disproportionately more traffic than others.

This creates uneven load and weakens both throughput and consumer balance.

## Common Causes

- low-cardinality keys
- one entity producing massive traffic
- partition strategy chosen without traffic analysis

## Example

Topic:

- `user_activity_events`

Key:

- `country_code`

If most traffic comes from one country, one partition may become much busier than the others.

This reduces the effective benefit of having many partitions.

## Another Example

Topic:

- `payments.events`

Key:

- `merchant_id`

If one merchant is far larger than the rest, it may dominate one partition and become the system bottleneck.

## Architectural Consequence

Teams often assume:

- more partitions means more scale

That is incomplete.

Real scale also depends on:

- good key distribution
- workload shape
- sink capacity
- consumer concurrency

## Good Strategy

- choose keys with both correctness and traffic distribution in mind
- evaluate skew explicitly
- understand that partition count alone does not solve poor key design

## Bad Strategy

- choose a key only for business readability
- ignore load distribution until production incidents happen

## Key Architectural Takeaway

Kafka scaling is constrained not just by broker resources, but by how traffic maps onto partitions.