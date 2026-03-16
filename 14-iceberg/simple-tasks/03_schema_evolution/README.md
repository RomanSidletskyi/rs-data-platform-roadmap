# Schema Evolution

## Goal

Understand how Iceberg handles schema changes safely.

## Input

A table with fields:

- order_id
- customer_id
- amount

New requirement:

- add currency
- rename amount to order_amount

## Requirements

- explain schema evolution
- explain why schema changes are risky in raw file-based systems
- describe how table formats help

## Expected Output

A short schema evolution explanation.

## Extra Challenge

- describe one backward compatibility risk
- compare schema evolution in warehouse vs lakehouse thinking
