# System Shape Review Checklist

## Purpose

Use this checklist when reviewing the overall architecture shape before debating tool choices.

## Problem Fit

- what business or platform problem is the system solving
- what breaks if nothing changes
- what latency, scale, trust, or ownership pressure is actually driving the design

## Boundaries

- where is the source of truth
- which layer is responsible for transport, processing, storage, and serving
- what should stay centralized and what should stay domain-local

## Simpler Alternative

- what is the simplest design that could plausibly work
- why is that simpler design insufficient here
- is complexity being added only where it buys clear value

## Failure Review

- what will fail first under load or incident pressure
- how would operators detect the failure
- how would the team recover safely

## Decision Output

- can the chosen shape be explained in five plain sentences
- does the architecture have one main accepted trade-off that is explicit