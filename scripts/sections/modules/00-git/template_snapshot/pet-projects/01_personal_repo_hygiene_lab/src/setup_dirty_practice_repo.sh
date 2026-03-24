#!/usr/bin/env bash

set -euo pipefail

practice_root="${PRACTICE_ROOT:-/tmp/git-practice}"
repo_name="${REPO_NAME:-repo-hygiene-lab}"
default_branch="${DEFAULT_BRANCH:-main}"
repo_dir="${practice_root}/${repo_name}"

rm -rf "$repo_dir"
mkdir -p "$repo_dir"
cd "$repo_dir"

git init -b "$default_branch"
printf '# Repo Hygiene Lab\n' > README.md
git add README.md
git commit -m "Initial commit"

mkdir -p .venv __pycache__ logs
printf 'SECRET_TOKEN=replace-me\n' > .env
printf 'temporary log\n' > logs/app.log
printf 'compiled python cache\n' > __pycache__/module.pyc
printf 'draft note\n' > notes.txt

echo "Dirty practice repository created at ${repo_dir}"
echo "Next steps: git status && git diff && write a .gitignore"