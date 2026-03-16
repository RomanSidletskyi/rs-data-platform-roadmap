# Query Patterns

## Required Query Patterns

### Pattern 1 — Latest Events for User

Return most recent events for one user.

### Pattern 2 — Events for One Session

Return all events belonging to one session.

### Pattern 3 — Events by Type

Return all events of one type in a time range.

### Pattern 4 — Events for a Page

Return all events associated with a specific page.

### Pattern 5 — Global Latest Events

Return globally latest events for operational inspection.

## Example

```python
list(events.find({"user_id": 10}).sort("timestamp", -1).limit(100))
```

## Important Rule

Indexes must support the actual read patterns, not hypothetical ones.

## Recommended Index Candidates

- { user_id: 1, timestamp: -1 }
- { session_id: 1, timestamp: 1 }
- { event: 1, timestamp: -1 }
- { page: 1, timestamp: -1 }
