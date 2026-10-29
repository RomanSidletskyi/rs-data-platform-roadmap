# Architecture

## Target Shape

One strong target design is:

1. Spark as the primary writer
2. one shared catalog for table resolution
3. at least one secondary engine as read-only consumer
4. explicit curated publish layer instead of exposing unstable intermediate tables
5. schema and partition evolution reviewed against reader compatibility

## Why This Shape Works

- the writer contract is controlled
- readers share the same metadata plane
- publish boundaries are deliberate
- open table does not mean uncontrolled table evolution

## Anti-Patterns This Design Avoids

1. letting every engine write the same high-value table without policy
2. treating open table format as permission to change contracts casually
3. exposing raw intermediate tables to all consumers as if they were stable products