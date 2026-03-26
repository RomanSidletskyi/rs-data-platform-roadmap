# Architecture

## Components

- long-retention raw history for replay and audit
- curated datasets with retention based on rebuild cost
- publish datasets with consumer-protection rules
- temporary and backfill paths with stricter cleanup windows
- one monitoring routine that identifies stale storage patterns

## Data Flow

1. raw keeps source-aligned history for recovery and traceability
2. curated keeps trusted outputs long enough to support rebuild economics
3. publish protects consumer stability and should not disappear unexpectedly
4. temporary paths are reviewed and removed on shorter cycles

## Trade-Offs

- keeping everything forever increases cost and clutter
- deleting too aggressively can destroy replay or audit capability
- cleanup is only safe when path purpose and downstream dependence are explicit
