# Source Landscape

Use this file to describe the incoming feeds before you design Snowflake objects.

Suggested starting point:

- `orders/` daily Parquet snapshots
- `shipments/` daily JSON drops with occasional schema drift
- `refunds/` daily CSV extracts from a partner system

Document for each feed:

- who owns it
- file format
- expected arrival frequency
- known schema stability or instability
- whether it is first exposed through an external table or loaded directly into a native raw table

Architectural question to answer:

- which feeds deserve immediate operational ingestion, and which should spend time in an exploratory boundary first?