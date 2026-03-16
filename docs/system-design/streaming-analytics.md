# Streaming Analytics System Design

## Problem Statement

Design a system that receives events continuously, processes them in near real time, and exposes analytics outputs.

## Typical Architecture

    Producers -> Kafka -> Stream Processing -> Analytical Storage -> Dashboard / Alerts

## Interview Questions

- Why is checkpointing important?
- How do you handle late or duplicate events?
- When is near real-time worth the complexity?
