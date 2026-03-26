# gitignore, Repository Hygiene, And Binary Risk

## Why This Topic Matters

Repository quality is not only about code. It is also about what should not be committed.

## Typical Ignore Targets

- virtual environments
- build artifacts
- logs
- secrets
- large generated files

## Core Example

    .venv/
    __pycache__/
    *.log
    .env

## Good Strategy

- add ignore rules early
- keep large generated outputs out of the repository unless they are intentional fixtures

## Bad Strategy

- commit secrets, notebooks with outputs, binaries, or large generated data casually

## Key Architectural Takeaway

Repository hygiene is a reliability and security concern, not only a cleanliness preference.