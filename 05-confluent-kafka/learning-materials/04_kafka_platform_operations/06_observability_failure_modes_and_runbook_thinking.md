# Observability, Failure Modes, And Runbook Thinking

## Why This Topic Matters

Kafka in production needs more than working code.

It needs operational visibility and predictable response patterns.

## What Teams Need To Observe

At minimum, teams should observe:

- consumer lag
- throughput
- error rates
- rebalance frequency
- DLQ volume
- sink latency

These signals help distinguish platform issues from application issues.

## Example Failure Modes

### Producer side

- publish retries growing
- acknowledgements delayed
- broker connectivity issues

### Consumer side

- lag exploding
- sink writes failing
- repeated poison messages

### Platform side

- partition skew
- storage pressure
- unstable deployments causing rebalance storms

## Runbook Thinking

A strong Kafka team should be able to answer:

- what does a lag spike mean here?
- when should we scale consumers?
- when should we pause consumption?
- when should we redirect failures to DLQ?
- how do we replay safely after a bug fix?

That is what runbook thinking means.

## Example

Incident:

- `sales.order_events` lag grows rapidly
- DB sink latency also grows

Possible interpretation:

- Kafka is healthy
- downstream sink is the bottleneck

Without observability, teams may blame the wrong layer.

## Good Strategy

- define Kafka operational signals clearly
- connect metrics to response playbooks
- treat failure analysis as part of platform design

## Key Architectural Takeaway

Kafka maturity is visible not only in throughput, but in how clearly the team can detect, explain, and respond to failures.