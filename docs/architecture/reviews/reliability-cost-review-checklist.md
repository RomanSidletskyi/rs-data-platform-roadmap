# Reliability And Cost Review Checklist

## Purpose

Use this checklist when reviewing system resilience and whether the operating cost matches the real business value.

## Reliability

- what happens after partial failure or restart
- which failures retry and which should isolate bad data
- can the system recover without manual destructive cleanup

## Bottlenecks

- what is the first likely bottleneck: compute, network, storage, sink, or coordination
- is scaling aimed at the bottleneck or at the most visible component only
- how does partitioning affect throughput and correctness

## Cost Drivers

- which workloads refresh too often for their real value
- where are small files, over-partitioning, or over-provisioned compute likely
- which expensive component has the weakest justification

## Trade-Off Decision

- what cost is being accepted deliberately
- what simpler and cheaper design could still satisfy the requirement