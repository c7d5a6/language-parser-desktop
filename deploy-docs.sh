#!/usr/bin/env bash

set -euo pipefail

BRANCH="gh-pages"
DOCS_DIR="docs/.vuepress/dist"
NODE_OPTIONS_VALUE="--max_old_space_size=8192"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required but not installed."
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm is required but not installed."
  exit 1
fi

if [[ ! -d ".git" ]]; then
  echo "Error: run this script from the repository root."
  exit 1
fi

echo "Installing dependencies..."
npm ci --legacy-peer-deps

echo "Building docs..."
NODE_OPTIONS="$NODE_OPTIONS_VALUE" npm run docs:build
touch "$DOCS_DIR/.nojekyll"

tmp_dir="$(mktemp -d)"
cleanup() {
  if git worktree list --porcelain | rg -Fq "$tmp_dir"; then
    git worktree remove "$tmp_dir" --force
  fi
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git worktree add "$tmp_dir" "$BRANCH"
elif git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
  git fetch origin "$BRANCH:$BRANCH"
  git worktree add "$tmp_dir" "$BRANCH"
else
  git worktree add -b "$BRANCH" "$tmp_dir"
fi

echo "Syncing built docs to $BRANCH..."
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude ".git" "$DOCS_DIR/" "$tmp_dir/"
else
  rm -rf "$tmp_dir"/*
  cp -a "$DOCS_DIR"/. "$tmp_dir"/
fi

pushd "$tmp_dir" >/dev/null

if [[ -z "$(git status --porcelain)" ]]; then
  echo "No changes to deploy."
  popd >/dev/null
  exit 0
fi

git add -A
git commit -m "Deploy docs: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
git push origin "HEAD:$BRANCH"

popd >/dev/null

echo "Docs deployed to branch '$BRANCH' from '$DOCS_DIR'."
