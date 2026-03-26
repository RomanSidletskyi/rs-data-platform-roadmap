# Vacuum, Retention, And Safety

## Why This Topic Matters

VACUUM is one of the most dangerous Delta Lake operations to misunderstand.

It can save storage cost, but it can also remove files needed for historical recovery if used carelessly.

## Core Mental Model

Old files may still matter for:

- time travel
- rollback
- delayed readers
- debugging historical behavior

That is why retention is not only a storage-cost setting.

It is a statement about how much historical safety the platform wants to preserve.

## Example

```sql
VACUUM silver.orders RETAIN 168 HOURS;
```

Before doing that, a mature team often asks questions such as:

- how long do we need time travel for recovery?
- can any streaming or delayed readers still depend on older files?
- how quickly do incidents usually get discovered?

Those questions matter more than the command itself.

## Why This Matters

The key question is not "how quickly can we delete old files?"

The key question is "how much recovery history does the platform actually need?"

## Good Vs Bad Retention Thinking

Healthy thinking:

- retention settings follow real recovery needs
- vacuum is coordinated with restore and time-travel expectations
- storage cleanup does not silently destroy operational safety

Weak thinking:

- vacuum is treated only as cost cleanup
- teams shorten retention aggressively without understanding reader and recovery impact
- historical repair becomes impossible because old files disappeared too early

## Practical Review Questions

1. How long after a bad write is it usually detected?
2. Which tables truly need longer historical recovery?
3. Are any delayed readers or jobs at risk if retention is shortened?
4. Is storage pressure pushing the team toward unsafe cleanup decisions?
5. Will consumers or operators know that recovery options became narrower?

## Common Anti-Patterns

- vacuuming aggressively because the table looks large
- copying retention settings between tables with very different risk profiles
- treating file cleanup as separate from reliability design

## Key Architectural Takeaway

VACUUM is a storage-lifecycle decision with reliability consequences, not just a cleanup command.
