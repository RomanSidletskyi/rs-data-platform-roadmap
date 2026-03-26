# Consumer Groups Explained

## Why This Topic Matters

Consumer groups are one of Kafka's most important ideas.

They explain how one event stream can feed multiple downstream systems without tightly coupling them.

## Core Idea

A consumer group is a set of consumers working together as one logical reader of a topic.

Inside one consumer group:

- each partition is consumed by only one member of that group at a time
- work is divided across members for scale

Across different consumer groups:

- each group reads the same event stream independently

That means one topic can support multiple downstream use cases at the same time.

## Example

Topic:

- `sales.order_events`

Consumer groups:

- `analytics-loader`
- `fraud-detector`
- `search-index-updater`

All three groups can read the same topic independently.

If `analytics-loader` is behind, that does not mean `fraud-detector` is behind.

Each group has its own committed offsets.

## Consumer Group Scaling

Suppose a topic has 4 partitions.

If a consumer group has:

- 1 consumer: that one consumer reads all 4 partitions
- 2 consumers: partitions are divided between them
- 4 consumers: ideally one partition each
- 6 consumers: 2 consumers sit idle because there are only 4 partitions

So consumer scaling is constrained by partition count.

That is one more reason partition planning matters.

## Rebalancing

When consumers join or leave a group, Kafka reassigns partitions.

This is called rebalancing.

Rebalancing matters because it can affect:

- throughput
- temporary pauses
- recovery behavior
- offset commit timing

Architecturally, frequent unstable consumer membership can create operational instability.

## Good Uses Of Consumer Groups

- scale one logical consumer application horizontally
- separate downstream use cases cleanly
- keep analytics, operational, and monitoring consumers independent

## Bad Assumptions

- “two consumers in the same group both receive all messages”
- “adding more consumers always increases throughput”

Both are wrong.

Within one group, consumers split partitions.

To get independent full reads, use separate consumer groups.

## Cookbook Example

Scenario:

- topic `iot.device_events`
- group `raw-lake-loader`
- group `alert-engine`

`raw-lake-loader` writes all events to analytical storage.

`alert-engine` reads the same topic to detect threshold breaches.

The two groups are independent even though they read the same events.

That is a core architectural advantage of Kafka.

## Key Architectural Takeaway

Consumer groups are how Kafka combines horizontal scaling within one use case and independent fan-out across many use cases.