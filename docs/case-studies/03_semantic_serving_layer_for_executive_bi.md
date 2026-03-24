# Semantic Serving Layer For Executive BI

## Background

Leadership and business teams need dashboards for:

- revenue
- margin
- active customers
- conversion rates
- regional trends

They need numbers that are fast, trusted, and explained consistently across reports.

## Problem

Raw and intermediate tables are too technical for broad business use.

Without a serving layer, the organization gets:

- conflicting KPI definitions
- unstable dashboards
- performance issues
- repeated business logic in report-level SQL

## Architecture Overview

Typical shape:

    curated gold tables
        -> semantic model
        -> BI dashboards
        -> self-service filtered exploration

The serving layer sits between transformed analytical storage and business consumption.

## Why This Shape Makes Sense

- executives need business definitions, not ingestion logic
- one semantic layer reduces metric duplication
- BI tools perform better against serving-friendly models
- fact and dimension design can match real analytical questions

## Technologies Used

Possible technology shape:

- gold marts in a warehouse or lakehouse
- semantic layer in Power BI, Fabric, Looker, or similar
- governed KPI definitions and report models

## Main Trade-Offs

Benefits:

- consistent KPI definitions
- better dashboard performance
- lower risk of raw-data misuse
- stronger separation between engineering logic and business consumption

Drawbacks:

- semantic modeling requires explicit governance
- changes to business definitions must be managed carefully
- some flexibility is lost compared with direct raw-table access

## Simpler Alternative

A simpler alternative is letting BI users query transformed tables directly.

That may work in small teams, but it becomes weak when:

- the number of reports grows
- KPI definitions must stay aligned
- business logic becomes hard to reproduce consistently

## What To Look At In Review

- who owns KPI definitions
- whether fact and dimension design fits analytical questions
- whether business-serving tables are distinct from technical processing tables
- what freshness the audience actually needs

## What Would Be Bad Here

- dashboards query bronze or silver data directly
- each report redefines revenue or margin independently
- semantic layer mirrors source schemas instead of business concepts
- BI becomes the place where data engineering logic lives

## Lessons Learned

- serving architecture is a product layer for business trust, not a cosmetic BI step
- semantic consistency is one of the main architecture concerns once dashboards become important business interfaces

## Read With

- `../architecture/05_serving_and_bi_architecture/README.md`
- `../system-design/lakehouse-bi.md`
- `../trade-offs/dbt-vs-sql-scripts.md`