# 05-confluent-kafka

This module teaches Kafka as the event transport and decoupling layer behind modern streaming and near-real-time data platforms.

It is not only a command guide for running a broker.

It is a structured path from first producer and consumer experiments to platform-level architecture decisions about topics, partitions, schemas, retries, replay, observability, and downstream processing.

## Why This Module Matters

Kafka is one of the most important technologies in modern data platforms because it changes how systems exchange data.

Instead of:

- polling APIs repeatedly
- copying files on fixed schedules
- tightly coupling one producer to one consumer

Kafka allows systems to:

- publish events continuously
- keep multiple consumers independent
- replay historical events when needed
- separate transport from downstream processing

That matters in real systems such as:

- clickstream pipelines
- IoT telemetry ingestion
- application event collection
- order and payment event flows
- operational monitoring and alerting
- near-real-time analytics platforms

Without a solid Kafka foundation, later modules such as Spark, Airflow, Flink, and lakehouse architecture are harder to reason about correctly.

## What This Module Is Really About

This module covers Kafka on three levels at the same time.

Level 1: fundamentals

- what Kafka is
- how topics, partitions, offsets, and consumer groups work
- how to run a local practice environment
- how producers and consumers exchange events

Level 2: engineering practice

- partition-key choice
- retry and dead-letter strategies
- duplicate handling and idempotency
- schema discipline
- local development with Docker and Python clients
- debugging lag, ordering, and offset behavior

Level 3: architecture

- where Kafka belongs in a data platform
- when Kafka is the right tool and when it is not
- how Kafka interacts with storage, stream processing, orchestration, and analytics
- how teams should think about contracts, replay, ownership, and failure handling

## What Kafka Is

Kafka is an event streaming platform built around durable append-only logs.

At a practical level, it gives you:

- producers that publish records
- topics that organize records by stream or domain
- partitions that provide scale and parallelism
- offsets that identify position in the log
- consumer groups that allow independent downstream processing

Kafka is strong when you need:

- continuous event transport
- multiple independent consumers of the same event stream
- replay capability
- loose coupling between producing and consuming systems

## What Kafka Is Not

Kafka is not:

- a relational database
- a replacement for every queue
- a full stream processing engine by itself
- an orchestration tool
- a magic exactly-once solution for all downstream systems

Common bad assumptions:

- “Kafka stores business truth forever, so we do not need proper serving storage”
- “Kafka automatically solves duplicates”
- “If we use Kafka, the architecture is now real-time by definition”
- “One topic can hold every kind of event if we just add enough fields”

## Kafka In A Data Platform

A typical data-platform flow looks like this:

		Producers / operational services
						↓
		Kafka topics
						↓
		Consumers / stream processing / connectors
						↓
		Storage or serving layer
						↓
		Analytics / dashboards / APIs / downstream systems

Kafka is the transport and decoupling layer in that picture.

It should usually own:

- event transport
- buffering between producers and consumers
- replayable event history for a configured retention window
- fan-out to multiple downstream consumers

Kafka should usually not own:

- final business serving state
- warehouse transformation logic
- long-running orchestration across systems
- batch scheduling
- BI semantics

Good boundary examples:

- Kafka transports order events
- Spark or Flink performs stream processing or enrichment
- storage layer keeps final analytical or application-ready state
- dbt transforms landed warehouse data into marts
- Airflow orchestrates larger multi-step workflows

## Why Confluent Kafka Specifically Matters Here

This module focuses on Confluent Kafka because it is one of the most common practical distributions and ecosystems around Kafka.

That means the learner should get comfortable with:

- Kafka fundamentals that apply broadly
- tooling and workflows commonly seen in Confluent-style environments
- ecosystem components such as Schema Registry and Kafka Connect

The goal is not tool-brand memorization.

The goal is to understand the operational and architectural patterns that show up in real Kafka platforms.

## Main Learning Goals

By the end of this module, the learner should be able to:

- explain Kafka as a log-based event transport system
- describe how topics, partitions, offsets, and consumer groups fit together
- run a local Kafka environment and inspect event flow
- write simple producers and consumers in Python
- reason about partition keys, ordering, and scaling
- explain at-most-once, at-least-once, and effectively-once trade-offs
- design retry and dead-letter handling for bad events
- understand why idempotent consumers matter
- explain the purpose of Schema Registry and event contracts
- explain where Kafka Connect fits and where custom consumers are better
- place Kafka correctly inside a data platform architecture
- recognize common anti-patterns before they become production problems

## Module Structure

		05-confluent-kafka/
				README.md
				learning-materials/
				simple-tasks/
				pet-projects/

## Learning Philosophy

This module is intentionally built with a strong architecture bias.

Kafka is one of those technologies that is easy to misuse if a learner only remembers commands.

So the material here should repeatedly connect:

- what Kafka does technically
- where it fits in system architecture
- how it behaves under scale and failure
- what engineering choices improve or weaken correctness

The learner should not leave this module thinking only:

- how to create a topic
- how to run a producer

The learner should leave understanding:

- why partitioning matters
- why schema discipline matters
- why duplicates and replays must be designed for
- why Kafka changes system boundaries but does not remove them

## Learning Materials

The learning materials are organized into six topic groups.

### kafka-fundamentals

This block should establish the mental model of Kafka itself.

Focus:

- brokers
- records
- topics
- partitions
- offsets
- retention
- append-only log thinking

The learner should come away understanding what Kafka stores, how readers move through the log, and why Kafka is not just “a queue with extra steps.”

### topics-partitions-offsets

This block should go deeper into the mechanics that determine correctness and scale.

Focus:

- partition strategy
- ordering guarantees
- offset management
- replay
- consumer lag
- hot partitions

This is one of the most important architecture-heavy sections, because bad partition strategy becomes a production problem very quickly.

### producers-consumers

This block should connect client behavior to system guarantees.

Focus:

- producer flow
- consumer polling model
- batching and acknowledgments
- retries
- delivery semantics
- duplicate handling
- idempotent consumer thinking

This section should make it obvious that correctness is a shared responsibility between transport layer and client design.

### schema-registry

This block should explain event contracts and schema evolution.

Focus:

- why event schemas matter
- why JSON alone is often too loose in larger systems
- compatibility rules
- versioning strategy
- contract ownership across teams

The learner should understand that streaming systems fail just as often from weak contracts as from weak infrastructure.

### kafka-connect

This block should explain where Kafka Connect belongs.

Focus:

- source connectors
- sink connectors
- operational convenience vs custom-code flexibility
- when Connect is enough
- when custom code is the better engineering choice

The learner should understand Connect as an integration layer, not as a replacement for all streaming logic.

### stream-processing

This block should show where Kafka ends and stream processing begins.

Focus:

- stateless vs stateful processing
- enrichment
- filtering
- windows and aggregations
- Kafka with Spark and Flink
- storage and serving boundaries

This is where the module starts connecting directly to later parts of the roadmap.

## Simple Tasks

The simple tasks should be used as short guided labs.

### 01_run_local_kafka

Goal:

- run Kafka locally
- identify core runtime pieces
- understand what the learner actually started

### 02_first_producer_consumer

Goal:

- write the first producer and consumer
- see records move end to end
- understand the first offset flow

### 03_json_events

Goal:

- work with real event payloads
- think about event shape and validation
- begin reasoning about contracts

### 04_retry_dead_letter_queue

Goal:

- simulate bad-event handling
- design retries carefully
- understand when and why to use a DLQ

### 05_multi_consumer_groups

Goal:

- see fan-out behavior
- understand why multiple downstream systems can consume the same stream independently
- inspect offset isolation between groups

### 06_streaming_simulation

Goal:

- build a small end-to-end event pipeline
- connect transport to downstream handling
- simulate a realistic near-real-time flow

## Pet Projects

The pet projects should be guided, production-shaped exercises rather than solved templates.

### 01_iot_streaming_lab

Focus:

- telemetry ingestion
- noisy device events
- partition strategy
- bad or late records

### 02_clickstream_pipeline

Focus:

- behavioral events
- session-like streams
- fan-out consumers
- downstream analytics needs

### 03_orders_payments_shipments_events

Focus:

- domain events
- event boundaries
- ordering and consistency issues
- retries, duplicates, and idempotency

### 04_kafka_to_postgres_pipeline

Focus:

- sink architecture
- storage integration
- consumer correctness
- replay and duplicate safety

These projects should train the learner to think like a streaming engineer, not just a local Kafka demo user.

## Recommended Learning Order

Recommended module flow:

1. Kafka fundamentals
2. topics, partitions, and offsets
3. producers and consumers
4. local hands-on producer/consumer tasks
5. retries, DLQ, and multi-consumer groups
6. schema discipline and event contracts
7. Kafka Connect and sink patterns
8. stream processing boundaries
9. architecture-heavy pet projects

This order is deliberate.

Kafka is easiest to misuse when a learner jumps from “it works locally” straight into “let's design a platform.”

The module should build the architecture thinking on top of correct fundamentals, not instead of them.

## Architecture Themes This Module Must Reinforce

There are several architecture themes that should appear repeatedly across the whole module.

### 1. Transport Is Not Final State

Kafka moves events.

It does not automatically provide the final query model needed by applications, dashboards, or warehouses.

### 2. Partitioning Is A First-Class Design Decision

Partition strategy affects:

- ordering
- throughput
- parallelism
- hot spots
- downstream correctness

This is not an implementation detail.

It is one of the core architecture choices in Kafka systems.

### 3. Offsets Are Operationally Important

Offsets are not just internal counters.

They are part of replay, debugging, lag analysis, and failure recovery.

### 4. Duplicates Must Be Expected

In real systems, duplicates are normal enough that the consumer side should be designed with idempotency in mind.

### 5. Contracts Matter

Weak schema discipline creates weak event platforms.

Transport reliability does not help if producers and consumers do not share a stable understanding of payload shape and meaning.

### 6. Kafka Does Not Replace System Design

Kafka can improve decoupling.

It does not remove the need for:

- ownership boundaries
- storage design
- observability
- backpressure thinking
- failure handling

## Common Mistakes This Module Should Help Prevent

The learner should repeatedly see and understand these mistakes:

- using Kafka when simple batch or polling would be enough
- creating topics without clear domain boundaries
- choosing poor partition keys
- assuming global ordering where only partition ordering exists
- ignoring replay requirements
- building consumers without idempotency
- sending ungoverned JSON payloads with no contract discipline
- mixing transport concerns with final analytical modeling concerns
- using Kafka retention as if it were permanent system-of-record storage
- shipping events with no DLQ or failure strategy

## Relationship To Other Modules

This module sits at the transition from foundational engineering into distributed data processing.

It connects especially well to:

- `01-python`
	- Python producers, consumers, payload validation, local tooling

- `03-docker`
	- local Kafka environments and reproducible dev setup

- `06-spark-pyspark`
	- Kafka as input to distributed processing

- `07-databricks`
	- Kafka ingestion into lakehouse-oriented processing flows

- `11-airflow`
	- orchestration boundaries around streaming-adjacent systems

- `13-flink`
	- true stream-processing and stateful event computation

## What Strong Understanding Looks Like After This Module

After finishing this module well, the learner should be able to:

- run a local Kafka workflow and explain what is happening
- reason about event transport and downstream consumers clearly
- choose a sensible partition strategy for a given workload
- explain the trade-offs of delivery guarantees without oversimplifying them
- design DLQ and retry behavior for bad messages
- explain why schema governance matters in streaming systems
- place Kafka correctly in a broader data platform architecture
- recognize when Kafka is appropriate and when it is unnecessary complexity

## Final Note

Kafka is one of the technologies that most clearly separates shallow familiarity from real engineering understanding.

At a shallow level, the learner can create a topic and send a message.

At a strong level, the learner can explain:

- why a topic exists
- how partitions are chosen
- what failure behavior looks like
- how consumers recover
- how replay works
- how contracts evolve
- how the whole system fits into a production data platform

That stronger level is the target of this module.
