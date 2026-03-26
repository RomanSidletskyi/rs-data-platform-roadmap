# Architecture

## Components

- bronze landing input
- bronze to silver task
- silver to gold task
- quality-check task
- governed gold table target

## Data Flow

1. source-near landed data is read from bronze path
2. silver normalizes and filters records
3. gold publishes daily revenue by date and country
4. quality check validates task and output assumptions

## Trade-Offs

- production job separation improves observability
- local preview logic helps contract review before workspace deployment
- gold output is intentionally small and consumer-oriented