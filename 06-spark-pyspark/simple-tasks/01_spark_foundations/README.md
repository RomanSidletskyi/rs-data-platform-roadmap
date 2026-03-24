# Simple Tasks: Spark Foundations

## Task 1: Explain The Execution Model

Write a short explanation of the difference between:

- driver
- executor
- job
- stage
- task

Your answer should explain how these parts work together in one Spark application.

## Task 2: Narrow Vs Wide

Given the following operations, classify each as mostly narrow or mostly wide and explain why:

- `filter`
- `select`
- `groupBy`
- `join`
- `withColumn`

## Task 3: Lazy Evaluation

Explain why Spark can build a long sequence of transformations before doing actual work.

Then explain why this is useful in a distributed system.

## Task 4: Tool Choice

You have a dataset of a few hundred megabytes that already lives in a warehouse and needs one small daily aggregate.

Explain whether Spark should be the default tool and justify your answer.