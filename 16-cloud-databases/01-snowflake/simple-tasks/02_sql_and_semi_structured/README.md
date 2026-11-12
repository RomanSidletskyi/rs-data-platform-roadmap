# Task Set 02: SQL and Semi-Structured Data

## Task 1: Select a Timestamp Type

A producer sends an ISO timestamp with an offset. Explain what you must preserve and what must be agreed before selecting `TIMESTAMP_NTZ`, `TIMESTAMP_LTZ`, or `TIMESTAMP_TZ`.

## Task 2: Extract JSON Fields

Given a `VARIANT` column `payload` with `order.id`, `order.total`, and an array `items`, write a query that extracts a string order ID and numeric total.

## Task 3: Expand an Array

Write a query that returns one row per item, with order ID, SKU, quantity, and item array index. Explain how the result grain changes.

## Task 4: Handle Bad Payloads

Design checks that distinguish a missing required field, explicit JSON null, and an unparseable payload. State how each should be observed or quarantined.

## Task 5: `VARIANT` or Typed Columns?

Choose where to keep a flexible source payload and where to materialize typed columns for joins, BI, and quality checks. Explain the boundary.