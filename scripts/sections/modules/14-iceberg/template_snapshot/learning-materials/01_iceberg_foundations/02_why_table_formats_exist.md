# Why Table Formats Exist Above Files

## 1. The Problem With Plain Files

Plain files are simple and cheap, but table state becomes ambiguous very quickly.

If you only have Parquet files in folders, engines still need answers to questions like:

- which files are valid right now?
- which schema version should readers use?
- what changed between two versions of the table?
- can one writer commit safely while another writer is working?

Without a table format, those answers are often encoded in fragile conventions.

## 2. Directory Convention Is Not A Real Table Model

Many early lake designs use conventions such as:

- `s3://bucket/table/date=2026-03-27/`
- overwrite one partition by replacing files in that path
- trust every engine to interpret the layout identically

This breaks down because:

- layout logic becomes part of application code
- schema changes become implicit and hard to validate
- atomicity becomes weak
- readers can see partially updated state

## 3. What Table Formats Add

Table formats like Iceberg add:

- explicit metadata
- versioned snapshots
- consistent file membership
- evolution rules separate from directory layout
- a contract that multiple engines can interpret the same way

That is the difference between:

- files as storage objects
- a table as a governed dataset

## 4. Why This Matters For Lakehouse Architecture

A lakehouse usually wants:

- open storage
- shared compute across engines
- reliable table state

Iceberg exists because object storage alone gives the first item, but not the other two.

## 5. The Deeper Trade-Off

Table formats add operational complexity.

You gain:

- reliability
- evolution
- history
- interoperability

You also accept:

- metadata maintenance
- catalog choice
- more complex debugging
- engine compatibility boundaries

So the correct question is not “Is Iceberg modern?”

The correct question is:

- do we have a real table-state problem that plain files no longer solve safely?