#!/usr/bin/env bash

set -euo pipefail

practice_root="${PRACTICE_ROOT:-/tmp/git-practice}"
repo_name="${REPO_NAME:-feature-branch-lab}"
default_branch="${DEFAULT_BRANCH:-main}"
feature_prefix="${FEATURE_PREFIX:-feature/}"
repo_dir="${practice_root}/${repo_name}"

rm -rf "$repo_dir"
mkdir -p "$repo_dir"
cd "$repo_dir"

git init -b "$default_branch"
printf '# Feature Branch Lab\n' > README.md
git add README.md
git commit -m "Initial commit"

git switch -c "${feature_prefix}alpha"
printf 'alpha change\n' > alpha.txt
git add alpha.txt
git commit -m "Add alpha feature"

git switch "$default_branch"
git switch -c "${feature_prefix}beta"
printf 'beta change\n' > beta.txt
git add beta.txt
git commit -m "Add beta feature"

git switch "$default_branch"
echo "Practice repo created at ${repo_dir}"
echo "Try: git branch --all && git log --oneline --graph --decorate --all"