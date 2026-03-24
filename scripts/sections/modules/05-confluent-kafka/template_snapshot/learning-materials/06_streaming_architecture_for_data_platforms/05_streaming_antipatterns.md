# Streaming Antipatterns

## Why This Topic Matters

Architectural maturity also means recognizing misuse patterns early.

Kafka itself is rarely the main failure. More often, teams impose weak boundaries, poor ownership, and unrealistic expectations on a streaming architecture and then blame the platform.

## Antipattern 1: Kafka As A Magic Bus

Belief:

- once we put data into Kafka, the architecture is automatically scalable and decoupled

Reality:

- weak contracts, bad keys, poor ownership, and fragile sinks still break systems

Infrastructure adoption is not architecture completion.

## Antipattern 2: Generic Event Payloads

Belief:

- flexible payloads make the system adaptable

Reality:

- vague semantics push complexity downstream and destroy governance

Generic payloads usually lead to consumer-specific parsing logic everywhere.

## Antipattern 3: No Replay Planning

Belief:

- replay is nice to have and can be handled later

Reality:

- recovery becomes painful if retention, idempotency, and sink design were not planned upfront

Replay claims without tested procedures are mostly wishful thinking.

## Antipattern 4: Kafka For Everything

Belief:

- every integration should use Kafka

Reality:

- some problems are simpler with direct APIs, databases, or batch tooling

Overuse creates operational cost without architectural gain.

## Antipattern 5: Cluster Ownership Without Topic Ownership

Belief:

- platform team owns Kafka, so ownership is solved

Reality:

- infrastructure ownership does not define domain semantics or contract responsibility

Healthy brokers do not guarantee healthy contracts.

## Antipattern 6: Oversized Canonical Topics

Belief:

- one central topic will simplify the platform

Reality:

- giant mixed contracts create governance bottlenecks and semantic ambiguity

This usually leads to over-broad schemas and painful evolution.

## Antipattern 7: Publishing Guesses About Other Domains

Belief:

- one producer can help everyone by embedding facts from several domains

Reality:

- domain boundaries blur and competing truths spread downstream

One service becomes accidental owner of concepts it does not govern.

## Antipattern 8: Treating Raw CDC As Universal Business Contract

Belief:

- if CDC is near real-time, it is good enough for all consumers

Reality:

- raw table changes often expose storage details rather than stable domain meaning

CDC is powerful, but it often needs a curation layer.

## Antipattern 9: Consumer Sprawl Without Platform Shape

Belief:

- many small consumers automatically mean flexible architecture

Reality:

- unmanaged consumer fleets create duplicated logic, inconsistent retries, and weak recovery posture

At some point the platform needs stronger shared patterns.

## Key Architectural Takeaway

Many Kafka failures come from architecture misuse, not from Kafka itself.