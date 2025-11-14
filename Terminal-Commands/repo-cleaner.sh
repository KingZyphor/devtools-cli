#!/usr/bin/env bash
# ==================================
# repo-cleaner.sh
# ==================================
# Info:
#   Conservative repository organizer. Performs dry-run by default.
#   Move files into conventional folders (src, docs, scripts, config, assets).
# Usage:
#   repo-cleaner.sh --dry-run   # default
#   repo-cleaner.sh --apply     # actually perform changes
# ==================================

set -euo pipefail
IFS=$'\n\t'

DEST_MAP=(
  "src|*.js *.ts *.jsx *.tsx"
  "docs|README*.md docs/*.md"
  "scripts|scripts/* bin/*"
  "config|*.yaml *.yml *.json .env*"
  "assets|*.png *.jpg *.svg *.gif"
)

DRY_RUN=true
while [ $# -gt 0 ]; do
  case "$1" in
    --apply) DRY_RUN=false; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    -h|--help) echo 'Usage: repo-cleaner.sh [--apply|--dry-run]'; exit 0 ;;
    *) shift ;;
  esac
done

printf 'Repo Cleaner - dry run: %s\n\n' "$DRY_RUN"

BASE="$(pwd)"

# Iterate mapping: create target dirs and show/perform move operations
for entry in "${DEST_MAP[@]}"; do
  dir="${entry%%|*}"
  patterns="${entry#*|}"
  mkdir -p "$dir"
  for p in $patterns; do
    for f in $BASE/$p; do
      [ -e "$f" ] || continue
      dest="$dir/$(basename "$f")"
      if [ "$DRY_RUN" = true ]; then
        printf 'DRY: Move %-60s -> %s\n' "$f" "$dest"
      else
        printf 'Move %-60s -> %s\n' "$f" "$dest"
        mv -v "$f" "$dest"
      fi
    done
  done
done

printf '\nDone. Run with --apply to perform these operations.\n'
