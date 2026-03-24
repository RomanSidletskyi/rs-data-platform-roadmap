# Python Operator Pipeline

## Goal

Run Python functions as Airflow tasks.

## Input

Three Python functions:

- fetch_data()
- clean_data()
- save_data()

## Requirements

- use PythonOperator or TaskFlow API
- run functions in sequence
- pass data conceptually between steps

## Expected Output

A simple Python-based DAG.

## Extra Challenge

- separate task logic into another file
- add logging in each task
