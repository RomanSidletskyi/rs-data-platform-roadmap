# Partition Evolution

## Goal

Understand why Iceberg partitioning is more flexible than static file layouts.

## Input

A table initially partitioned by:

- event_date

Later requirement:

- add region-based partitioning

## Requirements

- explain partition evolution
- explain why repartitioning is painful in plain file layouts
- explain business benefit of flexibility

## Expected Output

A documented partition evolution example.

## Extra Challenge

- describe one bad partitioning strategy
- explain how query patterns affect partition design
