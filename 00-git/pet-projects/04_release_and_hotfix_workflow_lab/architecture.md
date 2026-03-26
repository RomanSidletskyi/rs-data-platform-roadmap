# Architecture

## Components

- main branch
- release tags
- hotfix branch
- remote repository

## Data Flow

1. prepare release state
2. tag or cut release
3. detect production issue
4. create hotfix branch
5. validate and merge back

## Trade-Offs

- more process adds safety
- unclear branch rules create release confusion