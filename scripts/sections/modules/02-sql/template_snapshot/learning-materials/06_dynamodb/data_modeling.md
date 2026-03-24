# DynamoDB Data Modeling

## Main Mindset

Do not start with entities.

Start with access patterns.

## Typical Process

1. list read/write patterns
2. design primary key
3. design sort key
4. identify alternate access needs
5. add GSIs only where necessary

## Common Patterns

- customer timeline
- order history
- latest status per entity
- tenant-isolated data
- event streams by actor

## Common Mistakes

- trying to reproduce normalized SQL schema
- overusing scans
- weak partition keys
- not thinking about hot partitions
