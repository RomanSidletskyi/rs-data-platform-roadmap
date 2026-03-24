# Shell Scripting From Basics To Reliable Automation

## Why This Topic Matters

Shell scripts are useful for glue logic, quick automation, and ops tasks.

They are also easy to make dangerous.

## Core Building Blocks

    #!/usr/bin/env bash
    set -euo pipefail

Use variables safely:

    output_dir="logs"
    mkdir -p "$output_dir"

Use conditionals:

    if [[ -f config.yml ]]; then
      echo "config present"
    fi

## Good Strategy

- quote variables
- fail fast on unexpected errors
- keep scripts narrow in purpose
- use shell for orchestration and small file/process workflows

## Bad Strategy

- write large business logic programs in shell when Python would be clearer
- leave variables unquoted
- ignore exit codes

## Cookbook Example

Minimal log archive script:

    #!/usr/bin/env bash
    set -euo pipefail

    archive_dir="archive"
    mkdir -p "$archive_dir"
    cp app.log "$archive_dir/app_$(date +%Y%m%d_%H%M%S).log"

## Key Architectural Takeaway

Shell scripting is best as operational glue, not as a universal replacement for application logic.