# Reference Example Delta Batch Repairable Orders Lab

This folder is a solved reference example for the guided project:

- `08-delta-lake/pet-projects/01_delta_batch_repairable_orders_lab`

## What A Strong Solution Should Demonstrate

- clear bronze, silver, and gold table responsibilities
- idempotent batch loading assumptions
- bounded repair instead of full historical rewrites when possible
- one explicit explanation of why Delta Lake is used as a reliability layer, not just a file format

## Recommended Contents

- sample configuration
- small local datasets
- transformation entry points
- tests for replay safety and repair scope
