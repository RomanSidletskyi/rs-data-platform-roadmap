
cat <<'EOF' > "$MODULE/pet-projects/02_mongodb_event_store/README.md" <<'EOF'
# 02 MongoDB Event Store

## Project Goal

Design and query an event storage system using MongoDB.

## Project Context

You need to store high-volume user activity or application events in MongoDB and support operational and near-analytical query patterns.

Example domains:

- clickstream
- audit events
- application activity logs
- user interaction history

## What This Project Teaches

- event document modeling
- query design for event stores
- MongoDB indexing for operational reads
- aggregation for event analysis
- retention and lifecycle thinking

## Example Event

```json
{
  "event_id": 1,
  "user_id": 10,
  "session_id": "s_100",
  "event": "click",
  "timestamp": "2025-01-01T12:00:00Z",
  "page": "/products/1",
  "device": "mobile"
}
```

---

## Deliverable 1 — Event Document Model

### Goal

Design the MongoDB document shape for events.

### Input

Business domain:

- user activity
- sessions
- page views
- clicks
- conversions

### Requirements

- define core event fields
- decide whether each event is one document
- explain document boundaries
- explain whether session-level embedding is used or not

### Expected Output

- proposed event schema
- example event document
- modeling explanation

### Extra Challenge

Design two variants:
- event-per-document
- session document with embedded events

and compare them.

---

## Deliverable 2 — Query Patterns

### Goal

Support core operational query patterns.

### Input

Collection:

- events

### Requirements

Support patterns such as:

- latest events for user
- all events in one session
- all click events in time range
- events for one page
- events for one event type
- latest events globally

### Expected Output

A documented query pattern section with example MongoDB queries or Python examples.

### Extra Challenge

Add pagination and discuss its limitations for large-scale event browsing.

---

## Deliverable 3 — Aggregation Patterns

### Goal

Use MongoDB aggregation to analyze events.

### Input

Collection:

- events

### Requirements

Implement examples such as:

- event count by type
- top pages
- events by day
- events by device
- active users by day

### Expected Output

A documented aggregation section with reusable pipelines.

### Extra Challenge

Add a session-level aggregation such as:
- average events per session
- session count per day

---

## Deliverable 4 — Index Design

### Goal

Design indexes that support real event access patterns.

### Input

Core fields:

- user_id
- session_id
- timestamp
- event
- page

### Requirements

- propose indexes for common reads
- explain compound index ordering
- explain write overhead trade-offs

### Expected Output

A documented index strategy section.

### Extra Challenge

Add TTL indexing strategy for old events.

---

## Deliverable 5 — Retention and Lifecycle Strategy

### Goal

Define how old event data should be retained and managed.

### Input

Event workload assumptions.

### Requirements

- define retention rule
- explain whether TTL is appropriate
- explain archival/export path if needed

### Expected Output

A lifecycle strategy section.

### Extra Challenge

Describe how events would be exported into a lakehouse or analytics system.

---

## Suggested Folder Structure

- README.md
- architecture.md
- document_model.md
- query_patterns.md

You may also add:

- aggregation_examples.py
- index_notes.md
- lifecycle.md

## Final Result

After completing this project, the learner should understand how MongoDB can support an event-oriented operational workload and where its limits appear for large-scale analytics.
