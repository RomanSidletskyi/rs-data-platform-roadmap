#!/usr/bin/env bash

set -euo pipefail

practice_root="${PRACTICE_ROOT:-/tmp/git-practice}"
repo_name="${REPO_NAME:-git-recovery-lab}"
default_branch="${DEFAULT_BRANCH:-main}"
repo_dir="${practice_root}/${repo_name}"

rm -rf "$repo_dir"
mkdir -p "$repo_dir"
cd "$repo_dir"

git init -b "$default_branch"
printf '# Recovery Lab\n' > README.md
git add README.md
git commit -m "Initial commit"

printf 'first safe note\n' > incident.txt
git add incident.txt
git commit -m "Add first note"

printf 'second risky change\n' >> incident.txt
git add incident.txt
git commit -m "Add risky change"

git reset --soft HEAD~1

echo "Recovery scenario created at ${repo_dir}"
echo "Run: git status && git reflog && git switch -c ${RESCUE_BRANCH:-rescue/recovery}"