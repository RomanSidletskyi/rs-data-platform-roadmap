# Simple Tasks: Distributed Execution And Performance

## Task 1: Shuffle Diagnosis

Explain why the following stage is likely expensive:

- read raw events
- filter a month of data
- group by `customer_id`
- join with another large dataset

## Task 2: Skew Interpretation

One task runs far longer than all the others.

List three possible explanations and explain why "just add more hardware" may not be enough.

## Task 3: Cache Decision

You reuse a cleaned intermediate DataFrame three times in the same job.

Explain when caching may help and when writing an intermediate dataset may be the better architectural decision.

## Task 4: Slow Job Triage

Write a short triage sequence for investigating a Spark job that suddenly doubled in runtime.