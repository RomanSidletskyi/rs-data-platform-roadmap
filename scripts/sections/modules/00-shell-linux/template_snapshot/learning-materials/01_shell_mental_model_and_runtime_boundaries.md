# Shell Mental Model And Runtime Boundaries

## Why This Topic Matters

The shell is the runtime boundary through which many engineering actions are launched.

Later modules will use it constantly for:

- Docker commands
- Git workflows
- CI jobs
- Airflow tasks
- remote server work

## What The Shell Is

The shell is a command interpreter.

It reads your input, expands variables and patterns, starts processes, and connects inputs and outputs.

Common shells include:

- bash
- zsh
- sh-compatible shells

## What The Shell Is Not

It is not the operating system itself.

It is not the terminal window.

It is not a programming language that should replace all other tools.

## Core Mental Model

When you run a command, the shell usually decides:

- where you are working from
- which executable to call
- which environment variables are visible
- where stdout and stderr go
- whether output should be piped or redirected

## Essential Commands

Use these first:

    pwd
    whoami
    env
    printenv
    echo "$PATH"
    which python
    type ls
    command -v git

## Good Strategy

- know your current directory before destructive actions
- know which executable you are actually calling
- inspect environment variables when behavior feels inconsistent

## Bad Strategy

- copy commands blindly without understanding current working directory
- assume PATH is the same everywhere
- treat stdout and stderr as the same thing

## Why Bad Is Bad

- commands may mutate the wrong directory
- different binaries may run than expected
- automation behaves differently on laptop, CI, and server

## Small Cookbook Example

To confirm the exact Python executable and where it came from:

    command -v python
    which python
    type python

If those disagree with your expectations, the issue is usually PATH or shell configuration.

## Key Architectural Takeaway

The shell is an execution boundary for systems work.

Understanding that boundary early makes later automation much safer.