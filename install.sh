#!/usr/bin/env bash
# ==================================
# DevTools Installer
# ==================================
# Info:
#   Copies the 'Terminal Commands' folder into the current working directory.
#   Can download & extract a tarball when provided a URL.
# Usage:
#   ./install.sh                # local install (run from package root)
#   ./install.sh <tarball-url>  # download and install from a tarball
# ==================================

set -euo pipefail
IFS=$'\n\t'

DEST_DIR="Terminal Commands"
TARBALL_URL="${1:-}"

cleanup() {
  if [ -n "${TMPDIR:-}" ] && [ -d "$TMPDIR" ]; then
    rm -rf "$TMPDIR"
  fi
}
trap cleanup EXIT

# ==================================
# Helper: require curl or wget for remote installs
# ==================================
require_download_tool() {
  if command -v curl >/dev/null 2>&1; then
    echo "curl"
  elif command -v wget >/dev/null 2>&1; then
    echo "wget"
  else
    echo "ERROR: curl or wget required for remote install." >&2
    exit 1
  fi
}

# ==================================
# Remote installation: download tarball then extract Terminal Commands
# ==================================
if [ -n "$TARBALL_URL" ]; then
  echo "Downloading package from: $TARBALL_URL"
  TMPDIR="$(mktemp -d)"
  DL_TOOL="$(require_download_tool)"
  if [ "$DL_TOOL" = "curl" ]; then
    curl -fsSL "$TARBALL_URL" | tar -xz -C "$TMPDIR"
  else
    wget -qO- "$TARBALL_URL" | tar -xz -C "$TMPDIR"
  fi

  # find extracted root folder
  ROOT="$(find "$TMPDIR" -maxdepth 2 -mindepth 1 -type d | head -n 1)"
  if [ -z "$ROOT" ]; then
    echo "ERROR: Extracted tarball did not contain expected files." >&2
    exit 1
  fi

  if [ ! -d "$ROOT/Terminal Commands" ]; then
    echo "ERROR: Tarball does not include 'Terminal Commands' folder." >&2
    exit 1
  fi

  mkdir -p "$DEST_DIR"
  cp -rv "$ROOT/Terminal Commands/"* "$DEST_DIR/"
  chmod +x "$DEST_DIR"/*.sh || true
  echo "Installed Terminal Commands into ./$DEST_DIR"
  exit 0
fi

# ==================================
# Local installation: copy from the package directory
# ==================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -d "$SCRIPT_DIR/Terminal Commands" ]; then
  mkdir -p "$DEST_DIR"
  cp -rv "$SCRIPT_DIR/Terminal Commands/"* "$DEST_DIR/"
  chmod +x "$DEST_DIR"/*.sh || true
  echo "Installed Terminal Commands into ./$DEST_DIR"
  exit 0
fi

echo "ERROR: Could not find 'Terminal Commands' in package root. For remote installs, pass a tarball URL." >&2
exit 1
