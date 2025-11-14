#!/usr/bin/env bash
# ==================================
# sys-info.sh
# ==================================
# Info:
#   Gather basic system diagnostics useful for debugging CI or local dev.
# ==================================

set -euo pipefail
IFS=$'\n\t'

# Host info
printf '== Host ==\n'
uname -a || true

# CPU
printf '\n== CPU ==\n'
if command -v nproc >/dev/null 2>&1; then
  printf 'Cores: %s\n' "$(nproc)"
fi
if [ -f /proc/cpuinfo ]; then
  awk -F: '/model name/ {print "Model:" $2; exit}' /proc/cpuinfo || true
fi

# Memory
printf '\n== Memory ==\n'
if command -v free >/dev/null 2>&1; then
  free -h || true
fi

# Disk
printf '\n== Disk ==\n'
df -h --total 2>/dev/null | sed -n '1,6p' || df -h | sed -n '1,6p'

# Versions
printf '\n== Versions ==\n'
for c in git node npm python3 docker; do
  printf '%-10s ' "$c:"
  if command -v $c >/dev/null 2>&1; then
    $c --version 2>/dev/null || printf 'found: %s\n' "$(command -v $c)"
  else
    printf 'missing\n'
  fi
done

# Git status
printf '\n== Git status ==\n'
if git rev-parse --git-dir >/dev/null 2>&1; then
  git status --short --branch | sed -n '1,50p'
else
  printf 'Not inside a git repository.\n'
fi
