# Local Shell Env Loading Examples

This note is a practical companion to the broader env workflow documentation.

It focuses only on one thing:

- how to load local env files into your current shell
- how commands started from that shell can use the variables

## Main Idea

When you run:

```bash
set -a
source ~/.config/rs-data-platform/github.env
set +a
```

your current shell session reads the file and exports the variables.

After that, any command started from the same shell can use them.

## Minimal Example

Assume this file exists:

```text
~/.config/rs-data-platform/app.env
```

Content:

```bash
APP_ENV=local
PROJECT_NAME=rs-data-platform-roadmap
```

Load it:

```bash
set -a
source ~/.config/rs-data-platform/app.env
set +a
```

Verify in the same shell:

```bash
echo "$APP_ENV"
echo "$PROJECT_NAME"
```

Expected result:

```text
local
rs-data-platform-roadmap
```

## Why This Works

Flow:

```text
env file -> current shell -> child process
```

That means the shell gets the variables first, and then commands launched from that shell inherit them.

## Example 1 - GitHub Token For Curl

File:

```text
~/.config/rs-data-platform/github.env
```

Example content:

```bash
GITHUB_TOKEN=replace_me_locally
GITHUB_USERNAME=replace_me_locally
```

Load it:

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

Use it in a command:

```bash
curl -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user
```

You can also load it with the helper script:

```bash
source shared/scripts/helpers/load-env.sh github
```

## Example 2 - Postgres Variables For Python

File:

```text
~/.config/rs-data-platform/postgres.env
```

Example content:

```bash
POSTGRES_DB=mydb
POSTGRES_USER=myuser
POSTGRES_PASSWORD=replace_me_locally
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

Load it:

```bash
set -a
source ~/.config/rs-data-platform/postgres.env
set +a
```

Check what is loaded:

```bash
env | grep '^POSTGRES_'
```

Run a Python script:

```bash
python script.py
```

You can also load it with the helper script:

```bash
source shared/scripts/helpers/load-env.sh postgres
```

Inside Python, the script can read the variables from `os.environ`.

## Example 3 - Multiple Files In One Session

Load both app settings and service settings:

```bash
set -a
source ~/.config/rs-data-platform/app.env
source ~/.config/rs-data-platform/postgres.env
set +a
```

Then verify:

```bash
echo "$APP_ENV"
env | grep '^POSTGRES_'
```

## Example 4 - Proving Child Process Inheritance

Load a file:

```bash
set -a
source ~/.config/rs-data-platform/app.env
set +a
```

Check in current shell:

```bash
echo "$APP_ENV"
```

Check in child process:

```bash
sh -c 'echo "$APP_ENV"'
```

If both print the value, the inheritance worked.

## Example 5 - Wrong File Loaded

If you loaded the wrong values:

```bash
unset GITHUB_TOKEN
unset GITHUB_USERNAME
```

Or open a new terminal and load the correct file there.

## Common Real Usage Pattern

Typical workflow:

```bash
nano ~/.config/rs-data-platform/github.env
set -a
source ~/.config/rs-data-platform/github.env
set +a
if [[ -n "$GITHUB_TOKEN" ]]; then echo "GITHUB_TOKEN is set"; fi
```

## Important Limitations

- loading a file affects only the current shell session
- it does not update all open terminals
- GitHub Actions does not see these local files
- Raspberry Pi services do not see Mac env files unless you transfer values explicitly

## When To Use This File

Use this file when you want concrete examples of:

- loading one env file
- loading multiple env files
- proving that child processes can read the variables
- using the variables in commands

For the broader workflow, see:

- `shared/environments/local-env-files-workflow.md`

For the overview of which process reads which source, see:

- `shared/environments/who-reads-what.md`

For focused examples by service, see:

- `shared/environments/use-github-env.md`
- `shared/environments/use-postgres-env.md`