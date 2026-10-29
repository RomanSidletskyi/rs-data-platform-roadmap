# Table Operations And Maintenance

## 1. Why Operations Matter

Iceberg tables are not “set and forget.”

Over time, the table accumulates operational state that must be managed:

- snapshots
- manifests
- data files
- delete files

Without maintenance, table quality usually declines.

## 2. Typical Maintenance Areas

Teams often need to think about:

- compaction of small files
- manifest compaction or cleanup
- snapshot expiration
- orphan-file detection and cleanup

The exact commands depend on engine and platform, but the architecture principle is stable.

## 3. Why Maintenance Is An Ownership Problem

The hardest question is often not “which command do we run?”

It is:

- who is responsible for table health?

If ownership is vague, maintenance gets skipped or run dangerously.

## 4. Architect Rule

Every important Iceberg table should have an answer to:

- who writes it?
- who maintains it?
- who approves schema changes?
- who decides retention and cleanup policy?