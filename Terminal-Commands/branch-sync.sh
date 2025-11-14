#!/usr/bin/env bash
# ==================================
# branch-sync.sh
# ==================================
# Info:
#   Safe branch synchronizer that fetches remote, optionally rebases or merges,
#   and pushes back. Conservative by default.
# Usage:
#   branch-sync.sh <branch> [-r remote] [--rebase|--merge]
# ==================================

set -euo pipefail
IFS=$'\n\t'

usage() {
  cat <<'EOF'
Usage: branch-sync.sh <branch> [-r remote] [--rebase|--merge]

Options:
  -r <remote>     Remote name (default: origin)
  --rebase        Rebase local branch onto remote (default)
  --merge         Merge remote into local branch
EOF
  exit 1
}

BRANCH="${1:-}"
shift || true
REMOTE="origin"
STRATEGY="rebase"

while [ $# -gt 0 ]; do
  case "$1" in
    -r) REMOTE="$2"; shift 2 ;;
    --merge) STRATEGY="merge"; shift ;;
    --rebase) STRATEGY="rebase"; shift ;;
    -h|--help) usage ;;
    *) shift ;;
  esac
done

if [ -z "$BRANCH" ]; then
  printf 'ERROR: branch name required\n' >&2
  usage
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  printf 'ERROR: not inside a git repository\n' >&2
  exit 2
fi

printf 'Fetching from %s...\n' "$REMOTE"
git fetch "$REMOTE" --prune

if ! git rev-parse --verify "$REMOTE/$BRANCH" >/dev/null 2>&1; then
  printf 'Remote branch %s/%s does not exist; attempting to push local branch...\n' "$REMOTE" "$BRANCH"
  git push "$REMOTE" "$BRANCH"
  exit 0
fi

# Ensure local branch exists and check it out
if ! git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git checkout -b "$BRANCH" "$REMOTE/$BRANCH"
else
  git checkout "$BRANCH"
fi

if [ "$STRATEGY" = "rebase" ]; then
  printf 'Rebasing onto %s/%s\n' "$REMOTE" "$BRANCH"
  git rebase "$REMOTE/$BRANCH"
else
  printf 'Merging from %s/%s\n' "$REMOTE" "$BRANCH"
  git merge --ff-only "$REMOTE/$BRANCH" || git merge "$REMOTE/$BRANCH"
fi

printf 'Pushing changes to %s/%s\n' "$REMOTE" "$BRANCH"
git push "$REMOTE" "$BRANCH"
