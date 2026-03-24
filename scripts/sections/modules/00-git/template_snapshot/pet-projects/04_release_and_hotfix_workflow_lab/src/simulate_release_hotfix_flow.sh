#!/usr/bin/env bash

set -euo pipefail

practice_root="${PRACTICE_ROOT:-/tmp/git-practice}"
repo_name="${REPO_NAME:-release-hotfix-lab}"
default_branch="${DEFAULT_BRANCH:-main}"
release_tag="${RELEASE_TAG:-v0.1.0}"
hotfix_branch="${HOTFIX_BRANCH:-hotfix/urgent-fix}"
repo_dir="${practice_root}/${repo_name}"

rm -rf "$repo_dir"
mkdir -p "$repo_dir"
cd "$repo_dir"

git init -b "$default_branch"
printf '# Release Lab\n' > README.md
git add README.md
git commit -m "Initial commit"

printf 'version=0.1.0\n' > release.txt
git add release.txt
git commit -m "Prepare release candidate"
git tag "$release_tag"

git switch -c "$hotfix_branch"
printf 'urgent fix\n' >> release.txt
git add release.txt
git commit -m "Apply urgent hotfix"

echo "Release and hotfix scenario created at ${repo_dir}"
echo "Try: git log --oneline --graph --decorate --all && git tag"