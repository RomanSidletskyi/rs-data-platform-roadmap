# Migration Strategy

## Step 1 - Identify Main Read Patterns

List the most important application or analytical reads.

## Step 2 - Choose Document Boundaries

Decide what belongs naturally together in one document.

## Step 3 - Replace Expensive Join Paths

Move frequently co-read data into embedded structures when practical.

## Step 4 - Decide Intentional Duplication

Duplicate only fields that create strong read benefits.

## Step 5 - Define Indexes For Real Queries

Design indexes around target access paths.

## Step 6 - Validate Growth And Update Behavior

Ensure documents do not grow unbounded and update fan-out remains acceptable.

## Final Rule

Do not translate tables into collections one-to-one without rethinking the access model.
