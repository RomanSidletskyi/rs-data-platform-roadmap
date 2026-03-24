# Solutions: Spark Cookbook

## Task 1

Useful checklist:

- what is the grain on each side?
- are the join keys semantically correct?
- can either side be filtered or projected first?
- is one side reference-like or are both sides large fact-like datasets?
- is the join at the right architectural layer?

## Task 2

Key questions:

- who reads the dataset?
- how do they filter it?
- how will backfills behave?
- will the layout create too many small files?
- are we optimizing the current write at the expense of future reads?

## Task 3

This is an architectural clue because it reflects a real business distribution that can distort partition balance, joins, and aggregations. The pipeline should be designed with that shape in mind rather than assuming even parallelism.

## Task 4

Main checks:

- identify the exact affected window
- verify source history and schema compatibility
- validate rebuilt outputs before cutover
- confirm downstream consumers understand the republish timing
- avoid writing directly into trusted outputs without checks