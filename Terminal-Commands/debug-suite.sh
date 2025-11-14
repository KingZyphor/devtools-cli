#!/usr/bin/env bash
# ==================================
# debug-suite.sh
# ==================================
# Info:
#   Multi-purpose debugging helper: view logs, check ports, verify dependencies, inspect processes.
# Owner:
#   KingZyphor — sole owner of this CLI and its derivatives unless otherwise specified.
# ==================================

set -euo pipefail
IFS=$'\n\t'

usage() {
  cat <<'EOF'
Usage: debug-suite.sh <command> [args...]

Commands:
  logs [path]        Tail the last 200 lines of logs/* or specified file
  port <port>        Show which process (if any) is listening on a TCP port
  deps               Verify presence of common dev tools (git,node,npm,python3,docker)
  ps [pattern]       Show processes matching a pattern (or top processes if omitted)
  env                Show common environment variables that affect web apps
  -h|--help          Show this help
EOF
}

cmd="${1:-help}"; shift || true

case "$cmd" in
  logs)
    file="${1:-logs/*.log}"
    # ==================================
    # Tail logs safely (no failure when no logs present)
    # ==================================
    if ls $file >/dev/null 2>&1; then
      tail -n 200 $file || true
    else
      printf 'No logs found for: %s\n' "$file"
    fi
    ;;
  port)
    if [ -z "${1:-}" ]; then
      printf 'Provide a port number (e.g. debug-suite.sh port 3000)\n' >&2
      exit 2
    fi
    port="$1"
    if command -v lsof >/dev/null 2>&1; then
      lsof -nP -iTCP:"$port" -sTCP:LISTEN || printf 'Port %s not in use\n' "$port"
    elif command -v ss >/dev/null 2>&1; then
      ss -ltnp | grep -E "[:.]$port\\b" || printf 'Port %s not in use (ss output empty)\n' "$port"
    else
      printf 'Neither lsof nor ss available to inspect ports.\n' >&2
      exit 2
    fi
    ;;
  deps)
    printf 'Checking dependencies...\n'
    for c in git node npm python3 docker docker-compose shellcheck; do
      if command -v "$c" >/dev/null 2>&1; then
        printf '%-15s OK\n' "$c"
      else
        printf '%-15s MISSING\n' "$c"
      fi
    done
    ;;
  ps)
    pattern="${1:-}"
    if [ -z "$pattern" ]; then
      ps aux | head -n 40
    else
      ps aux | grep -i "$pattern" | grep -v grep || printf 'No processes matching: %s\n' "$pattern"
    fi
    ;;
  env)
    env | grep -E 'NODE|NPM|PATH|PORT|ENV|HOME' || true
    ;;
  -h|--help|help) usage ;;
  *)
    printf 'Unknown debug command: %s\n\n' "$cmd" >&2
    usage
    exit 2
    ;;
esac
