# Flink Vs Spark Structured Streaming

## Decision

Choose the streaming compute engine for stateful near-real-time processing.

## Context

This decision appears when event processing grows beyond simple consumer scripts.

## Decision Criteria

- importance of continuous event-time processing
- existing platform ecosystem
- stateful streaming depth
- batch and streaming unification needs

## Option A

### Benefits

- strong fit for continuous event-time and stateful streaming workloads
- good when streaming is a central platform concern

### Drawbacks

- may be unnecessary if the platform already centers around another compute engine
- introduces another engine to operate and govern

## Option B

### Benefits

- strong fit when Spark already anchors the broader data platform
- useful when batch and streaming should live close together operationally

### Drawbacks

- the team must still judge whether it fits the required streaming depth
- may be chosen for ecosystem convenience even when workload shape points elsewhere

## Recommendation

Choose Flink when continuous streaming semantics and long-lived stateful processing are the real center of gravity.

Choose Spark Structured Streaming when the broader platform already depends on Spark heavily and the streaming workload fits that operating model well.

## Revisit Trigger

Revisit when streaming workload shape, state complexity, or platform-engine standardization changes.