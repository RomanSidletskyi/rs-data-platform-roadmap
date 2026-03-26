# Architecture - 03 Log Parser Pipeline

## Components

- raw log files
- log parser
- structured event records
- malformed line handling
- summary output layer

## Data Flow

1. read log files
2. parse each line into fields
3. separate valid and invalid lines
4. write structured events
5. generate summary outputs

## Trade-Offs

- one strict format is easier to reason about
- looser parsing may keep more records but risks ambiguous output

## What Would Change In Production

- multiple parser variants
- partitioned outputs
- alert thresholds for error spikes