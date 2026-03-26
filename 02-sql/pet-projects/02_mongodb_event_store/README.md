# 02 MongoDB Event Store

## Project Goal

Design and query an event storage system using MongoDB.

## Scenario

Your application produces high-volume user activity and audit-style events. The platform needs fast operational reads, recent-event exploration, aggregation for simple analysis, and a retention strategy that does not turn the collection into an unbounded dump.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in `architecture.md`.

If a reference example exists later for comparison, it should live in a separate sibling folder named:

- `reference_example_mongodb_event_store`

## Starter Assets You Already Have

This guided project already includes:

- `document_model.md` with starter modeling directions
- `query_patterns.md` with the core query shapes to support
- starter notes in `config/`, `data/`, `docker/`, `src/`, and `tests/`

## Suggested Folder Roles

- `src/` for query examples, aggregation pipelines, or helper scripts
- `config/` for connection and collection assumptions
- `data/` for sample payloads and retention notes
- `tests/` for query validation or contract checks
- `docker/` for optional local MongoDB runtime notes

## Expected Deliverables

- one credible event document model
- core query patterns for operational reads
- a set of aggregation patterns
- an index strategy tied to real access paths
- a retention and lifecycle strategy

## What You Must Build

- define the event document boundary and explain why you chose it
- implement user, session, event-type, and global-latest query patterns
- implement aggregation examples for activity analysis
- propose indexes that match the query patterns
- explain how old events are retained, expired, or exported

## Project Structure

	02_mongodb_event_store/
		README.md
		architecture.md
		document_model.md
		query_patterns.md
		config/
			README.md
		data/
			README.md
		docker/
			README.md
		src/
			README.md
		tests/
			README.md

## Recommended Implementation Plan

### Step 1

Read `architecture.md`, `document_model.md`, and `query_patterns.md` to define the workload.

### Step 2

Choose the document model and justify the document boundary.

### Step 3

Implement the key operational queries.

### Step 4

Implement aggregation patterns for event analysis.

### Step 5

Add index and retention notes.

### Step 6

Validate that the model and indexes match the access patterns you documented.

## Implementation Requirements

- start from access patterns, not from a relational rewrite
- keep document growth under control
- align indexes with filters and sort order
- distinguish operational event browsing from deep analytics workloads
- document retention instead of assuming infinite collection growth

## Validation Ideas

- verify latest-events queries are index-friendly
- verify session reconstruction is feasible with the chosen model
- verify aggregation examples match the documented payload shape
- verify the retention strategy is consistent with the event workload volume

## Definition Of Done

This project is complete if:

- the event model is clear and justified
- the project supports practical read and aggregation patterns
- indexes are tied to the real query paths
- lifecycle handling is documented instead of ignored

## Suggested Self-Check

If a reference example exists later, compare only after implementing the project independently.

The main project folder should remain a guided build exercise, not a pre-solved implementation.

## Possible Improvements

- add a lakehouse export contract
- add TTL and archival variants
- compare event-per-document and session-document approaches with measured trade-offs
