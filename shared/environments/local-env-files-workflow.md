# Local Env Files Workflow

This note explains how to work with local env files for this repository.

It covers:

- where the files live
- how to open them
- how to read them
- how to add new variables
- how to load them into your shell
- how to verify that the values are available

## Recommended Local Directory

On the main machine, use:

```text
~/.config/rs-data-platform/
```

Example structure:

```text
~/.config/rs-data-platform/
├── github.env
├── airflow.env
├── minio.env
├── postgres.env
├── azure.env
└── app.env
```

## What One File Looks Like

Example:

```bash
GITHUB_TOKEN=replace_me_locally
GITHUB_USERNAME=replace_me_locally
```

Rule:

- one variable per line
- no quotes unless really needed
- no spaces around `=`

Good:

```bash
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

Bad:

```bash
POSTGRES_HOST = localhost
POSTGRES PORT=5432
```

## How To Open And Edit A File

Using terminal editor:

```bash
nano ~/.config/rs-data-platform/github.env
```

Or on macOS with TextEdit:

```bash
open -a TextEdit ~/.config/rs-data-platform/github.env
```

Or in VS Code:

```bash
code ~/.config/rs-data-platform/github.env
```

## How To Read A File

Show the whole file:

```bash
cat ~/.config/rs-data-platform/github.env
```

Show with line numbers:

```bash
nl -ba ~/.config/rs-data-platform/github.env
```

Find one variable:

```bash
grep GITHUB_TOKEN ~/.config/rs-data-platform/github.env
```

## How To Add A New Variable

Open the file and add a new line manually.

Example for `app.env`:

```bash
nano ~/.config/rs-data-platform/app.env
```

Then add:

```bash
DEFAULT_REGION=westeurope
```

You can also append from terminal:

```bash
printf '\nDEFAULT_REGION=westeurope\n' >> ~/.config/rs-data-platform/app.env
```

## How To Replace A Placeholder Value

Example file:

```bash
GITHUB_TOKEN=replace_me_locally
```

Change it to:

```bash
GITHUB_TOKEN=ghp_your_real_token_here
```

Do not add comments on the same line as the secret value.

Good:

```bash
GITHUB_TOKEN=ghp_your_real_token_here
```

Bad:

```bash
GITHUB_TOKEN=ghp_your_real_token_here  # my main token
```

## How To Load One Env File Into The Current Shell

Use:

```bash
set -a
source ~/.config/rs-data-platform/github.env
set +a
```

That exports all variables from the file into the current shell session.

## Why Any Command Can See The Variables After `source`

When you run:

```bash
set -a
source ~/.config/rs-data-platform/github.env
set +a
```

the shell reads the file line by line and creates exported environment variables inside the current shell session.

After that, any command started from the same shell inherits those variables.

That means commands such as:

- `python`
- `curl`
- `gh`
- `docker compose`
- shell scripts

can all see the variables, as long as they are started from that same shell session.

Important:

- this does not change every terminal on your machine
- this affects only the current shell session and the processes started from it

## Small Mental Model

Flow:

```text
env file -> current shell -> child process started from that shell
```

Example:

```text
~/.config/rs-data-platform/github.env
	-> zsh session
	-> curl / python / gh
```

## How To Load Multiple Env Files

Example:

```bash
set -a
source ~/.config/rs-data-platform/app.env
source ~/.config/rs-data-platform/postgres.env
set +a
```

This is useful when one script needs both general app settings and service credentials.

## How To Verify That Variables Were Loaded

Check one variable:

```bash
echo "$GITHUB_TOKEN"
```

Check another:

```bash
echo "$POSTGRES_HOST"
```

List only matching env vars:

```bash
env | grep '^POSTGRES_'
```

## How To Verify The Inheritance Behavior

Example:

```bash
set -a
source ~/.config/rs-data-platform/app.env
set +a
env | grep '^APP_ENV='
sh -c 'echo "$APP_ENV"'
```

What this shows:

- `env | grep` proves the variable exists in the current shell environment
- `sh -c` proves a child process started from that shell can also read it

## Safe Verification Pattern

For secrets, prefer checking presence rather than printing the whole value.

Example:

```bash
if [[ -n "$GITHUB_TOKEN" ]]; then echo "GITHUB_TOKEN is set"; fi
```

This is safer than printing a real token to the terminal.

## How To Use The Variables In Commands

Example with a Python script:

```bash
set -a
source ~/.config/rs-data-platform/postgres.env
set +a
python script.py
```

Example with one-off command:

```bash
set -a
source ~/.config/rs-data-platform/github.env
set +a
curl -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user
```

## How To Unset Variables

If you loaded the wrong values into the current shell:

```bash
unset GITHUB_TOKEN
unset GITHUB_USERNAME
```

Or simply open a new terminal session.

## Common Mistakes

Mistake:
spaces around `=`

Mistake:
putting multiple variables on one line

Mistake:
using comments on the same line as secret values

Mistake:
forgetting `set -a` before `source`

Mistake:
expecting the variables to persist in every new terminal automatically

## Practical Example For Your Current Setup

Edit GitHub values:

```bash
nano ~/.config/rs-data-platform/github.env
```

Load them:

```bash
set -a
source ~/.config/rs-data-platform/github.env
set +a
```

Verify safely:

```bash
if [[ -n "$GITHUB_TOKEN" ]]; then echo "GITHUB_TOKEN is set"; fi
echo "$GITHUB_USERNAME"
```

Edit Postgres values:

```bash
nano ~/.config/rs-data-platform/postgres.env
```

Load them:

```bash
set -a
source ~/.config/rs-data-platform/postgres.env
set +a
```

Verify:

```bash
env | grep '^POSTGRES_'
```

## When To Use This File

Use this file when you need to know:

- how to create local env files
- how to edit them safely
- how to read them
- how to load them into the shell

For secret placement rules, see:

- `shared/environments/secrets-management.md`

For git rules, see:

- `shared/environments/git-hygiene.md`

For a focused set of shell-loading examples, see:

- `shared/environments/local-shell-env-loading-examples.md`