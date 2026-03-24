# Task Dependencies

## Goal

Understand how tasks depend on each other in Airflow.

## Input

Pipeline steps:

- extract
- validate
- transform
- load

## Requirements

- define four tasks
- set dependencies correctly
- ensure `transform` starts only after `validate`

## Expected Output

A DAG graph showing correct task order.

## Extra Challenge

- add one parallel task branch
- add a final summary task
