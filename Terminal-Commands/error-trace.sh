#!/usr/bin/env bash
# ==================================
# error-trace.sh
# ==================================
# Info:
#   Lightweight tracing tools to gather process information or run a command under trace.
# Usage:
#   error-trace.sh pid <PID>
#   error-trace.sh run <command...>
# ==================================

set -euo pipefail
IFS=$'\n\t'

usage() {
  cat <<'EOF'
Usage:
  error-trace.sh pid <PID>
  error-trace.sh run <command...>

Collects:
  - ps output for the PID
  - lsof open files (if available)
  - last 200 lines from logs/*
  - strace summary (if available; Linux)
EOF
}

if [ $# -lt 1 ]; then usage; fi

mode="$1"; shift

if [ "$mode" = "pid" ]; then
  pid="$1"
  printf 'Process info for PID: %s\n' "$pid"
  ps -p "$pid" -o pid,ppid,uid,user,cmd,etimes || true

  if command -v lsof >/dev/null 2>&1; then
    printf '\nOpen files (lsof):\n'
    lsof -p "$pid" | sed -n '1,200p' || true
  fi

  printf '\nRecent logs (if logs/* exists):\n'
  tail -n 200 logs/*.log 2>/dev/null || true

  if command -v strace >/dev/null 2>&1; then
    printf '\nAttempting a short strace -c (requires privileges on some systems)...\n'
    timeout 3 strace -c -p "$pid" 2>/dev/null || true
  fi

  printf '\nTrace collection completed.\n'

elif [ "$mode" = "run" ]; then
  if [ $# -lt 1 ]; then usage; fi
  printf 'Running command under trace: %s\n' "$*"
  if command -v strace >/dev/null 2>&1; then
    strace -f -o /tmp/devtools-strace.out "$@"
    printf 'strace output -> /tmp/devtools-strace.out\n'
  else
    printf 'strace not available; running command without tracing.\n'
    "$@"
  fi
else
  usage
fi
