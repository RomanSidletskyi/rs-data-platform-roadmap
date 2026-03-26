# Reading Text And Working With Large Files

## Why This Topic Matters

Large logs and config files are normal in engineering work.

Opening everything in an editor is often slower than necessary.

## Core Commands

    cat README.md
    less README.md
    head -n 20 app.log
    tail -n 50 app.log
    tail -f app.log
    wc -l app.log
    nl -ba config.yml | head -n 30

## Good Strategy

- use `head` and `tail` for quick inspection
- use `less` for interactive reading
- use `tail -f` only when you truly need a live stream

## Bad Strategy

- spam `cat` on huge logs
- copy giant files into the terminal unnecessarily

## Cookbook Example

To inspect the newest error area of a log:

    tail -n 100 app.log | less

To count how large a text file is before deciding how to inspect it:

    wc -l app.log

## Common Failure Mode

People often look only at the very top of a log when the relevant failure is near the bottom.

That is why `tail` is often more useful than `cat` in operational work.