# Use GitHub Env

This note shows how to use your local GitHub env file from the shell.

Expected file:

```text
~/.config/rs-data-platform/github.env
```

Example content:

```bash
GITHUB_TOKEN=replace_me_locally
GITHUB_USERNAME=replace_me_locally
```

## Option 1 - Load Manually

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

Use with curl:

```bash
curl -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user
```

Use with GitHub CLI:

```bash
gh auth status
```

## Option 2 - Load With Helper Script

From the repository root:

```bash
source shared/scripts/helpers/load-env.sh github
```

Then verify:

```bash
if [[ -n "$GITHUB_TOKEN" ]]; then echo "GITHUB_TOKEN is set"; fi
echo "$GITHUB_USERNAME"
```

## Common Pattern

```bash
cd /Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap
source shared/scripts/helpers/load-env.sh github
curl -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user
```

## Important Note

This works only in the current shell session and commands started from it.

GitHub Actions does not read this local file.