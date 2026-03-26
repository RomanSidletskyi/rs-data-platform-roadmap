# Batch Pipeline Review Checklist

## Purpose

Use this checklist when evaluating scheduled pipelines, warehouse loads, and historical analytical flows.

## Freshness And Scheduling

- is the freshness window tied to a real business need
- are schedule dependencies explicit
- what happens when an upstream dataset arrives late

## Data Layers

- is raw input preserved before transformation
- are intermediate and curated layers clearly separated
- are downstream users blocked from unstable technical layers

## Recovery

- can the job rerun safely without duplicates
- is backfill strategy defined before incidents happen
- can partial failures be isolated instead of forcing full rebuilds

## Quality And Observability

- where do data quality checks run
- how is completeness measured
- what signals prove the batch completed correctly

## Cost Review

- is full refresh being used out of convenience only
- what becomes expensive first if volume or frequency grows