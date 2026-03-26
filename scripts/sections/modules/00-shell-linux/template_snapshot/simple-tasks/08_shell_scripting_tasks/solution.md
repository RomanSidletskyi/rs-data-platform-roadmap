# Solution

Minimal script shape:

    #!/usr/bin/env bash
    set -euo pipefail

    mkdir -p logs
    echo "run $(date +%Y-%m-%dT%H:%M:%S)" >> logs/run.log

Backup example:

    #!/usr/bin/env bash
    set -euo pipefail

    input_file="$1"
    mkdir -p backup
    cp "$input_file" "backup/$(basename "$input_file")_$(date +%Y%m%d_%H%M%S)"

Python is usually better for:

- complex parsing
- data structures and validation
- non-trivial business logic