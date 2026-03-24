# Processes, Jobs, Signals, And Runtime Debugging

## Why This Topic Matters

Systems work means dealing with running processes, stuck processes, and processes that died too early.

## Core Commands

    ps aux
    pgrep python
    top
    jobs
    bg
    fg
    kill PID
    kill -9 PID

## Core Mental Model

- a process is a running program
- a job is shell-level tracking for background work in the current session
- signals are a way to ask a process to stop or react

## Good Strategy

- inspect before killing
- prefer normal termination before force-kill
- understand whether the process belongs to your shell, another user, or a service manager

## Bad Strategy

- jump straight to `kill -9`
- grep process lists without checking for false positives

## Cookbook Example

Find a process and stop it gracefully:

    pgrep -fl python
    kill 12345

If it refuses to stop and you understand the risk:

    kill -9 12345

## Common Failure Mode

The command:

    ps aux | grep python

also shows the grep process itself.

That is why `pgrep -fl python` is often cleaner.