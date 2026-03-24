# Navigation And Files

## Task 1 - Build A Clean Sandbox Tree

### Goal

Create a working directory tree using only shell commands.

### Requirements

- create `sandbox/`
- inside it create `logs/`, `data/raw/`, `data/processed/`, `scripts/`
- create empty files `logs/app.log`, `scripts/run.sh`, `data/raw/input.txt`
- list the final tree from the shell

### Expected Output

A deterministic directory tree created only with commands.

## Task 2 - Practice Path Reasoning

### Goal

Move between nested directories without guessing.

### Requirements

- print the current directory at each step
- move from repo root to `00-shell-linux/simple-tasks/01_navigation_and_files`
- then back to repo root using a different path style

## Task 3 - Copy, Move, And Remove Safely

### Goal

Practice non-destructive file mutation.

### Requirements

- copy `input.txt` to `input.backup.txt`
- rename `run.sh` to `bootstrap.sh`
- remove only the backup file
- verify final state with `ls -la`