# Terminal Commands

Overview
--------
This directory contains the core shell scripts shipped with @kingzyphor/devtools-cli.
Each script is standalone, well-documented, and intended to be used from the top-level
`devtools` dispatcher (installed as `devtools` and `dt`).

Included scripts:
- `git-autopush.sh`  — Safe automated git staging, commit & push helper.
- `debug-suite.sh`   — Utilities for logs, ports, dependencies and process inspection.
- `sys-info.sh`      — System and environment diagnostics.
- `repo-cleaner.sh`  — Conservative repository re-organization tool (dry-run default).
- `branch-sync.sh`   — Safe sync between local and remote branches.
- `error-trace.sh`   — Helpers to gather runtime traces for processes or commands.

Guidelines
----------
- Make scripts executable: `chmod +x "Terminal Commands"/*.sh`.
- Each script supports a `-h|--help` or `help` mode; consult individual help for details.
- Scripts avoid destructive defaults; repo-cleaner uses `--dry-run` by default.

Ownership & Credits
-------------------
Author: KingZyphor — sole owner of this CLI and its derivatives unless otherwise specified.
