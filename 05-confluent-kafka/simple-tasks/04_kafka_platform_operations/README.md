# Kafka Platform Operations Tasks

## Task 1 - Reason About Retention

### Goal

Connect storage policy to recovery capability.

### Requirements

- choose a topic such as `sales.order_events`
- define one short retention policy and one longer one
- explain which replay scenarios each policy supports or blocks

## Task 2 - Diagnose Lag

### Goal

Practice operational interpretation instead of only metric reading.

### Requirements

- describe one scenario where lag grows because of a slow sink
- describe one scenario where lag grows because of consumer instability
- explain how the operational response differs

## Task 3 - Identify Hot Partition Risk

### Goal

Spot scaling issues before they become incidents.

### Requirements

- propose one bad partition key that could create skew
- propose one better key
- explain the trade-off between ordering and distribution