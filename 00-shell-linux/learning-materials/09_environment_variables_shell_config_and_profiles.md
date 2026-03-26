# Environment Variables, Shell Config, And Profiles

## Why This Topic Matters

Many “it works on one machine but not another” problems are environment problems.

## Core Commands

    env
    printenv
    export APP_ENV=dev
    echo "$PATH"
    source ~/.zshrc
    alias ll='ls -la'

## Core Concepts

- environment variable is key-value process context
- PATH controls command lookup order
- shell profiles such as `.zshrc` shape interactive sessions

## Good Strategy

- inspect PATH when the wrong binary runs
- keep project-specific settings explicit
- understand the difference between one session and persistent shell config

## Bad Strategy

- keep important configuration only in your personal shell file without documentation
- mutate PATH repeatedly without understanding order

## Cookbook Example

To temporarily add a tools directory for the current shell:

    export PATH="$HOME/bin:$PATH"

To reload shell config after editing it:

    source ~/.zshrc

## Key Architectural Takeaway

Environment variables are part of runtime architecture, not just convenience settings.