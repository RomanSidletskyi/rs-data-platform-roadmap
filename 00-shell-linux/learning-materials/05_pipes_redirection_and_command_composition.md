# Pipes, Redirection, And Command Composition

## Why This Topic Matters

Shell becomes powerful when commands are composed instead of used one by one.

This is the real step from “knowing commands” to “thinking in workflows”.

## Core Concepts

- `|` sends stdout of one command to stdin of another
- `>` writes stdout to a file and replaces old content
- `>>` appends stdout to a file
- `2>` writes stderr to a file
- `2>&1` merges stderr into stdout

## Core Examples

    ps aux | grep python
    grep ERROR app.log > errors.txt
    command > out.txt 2> err.txt
    command > all.txt 2>&1
    echo "done" >> history.log

## Good Strategy

- think in stages
- keep stdout for normal output and stderr for failures when scripting
- inspect command behavior before redirecting away all errors

## Bad Strategy

- redirect everything to `/dev/null` too early
- use long pipelines you cannot explain

## Why Bad Is Bad

- failures disappear
- debugging becomes guesswork

## Cookbook Example

Capture both normal and error output from a script run:

    ./run-job.sh > run-output.log 2>&1

Then inspect the last lines:

    tail -n 50 run-output.log

## Key Architectural Takeaway

Pipes and redirection let the shell act like a lightweight workflow engine.

That is why they matter so much in Linux operations and CI.