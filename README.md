# @kingzyphor/devtools-cli

**DevTools CLI** — a cross-platform, bash-first toolkit for repository maintenance, debugging, and automation.  
This package provides a compact set of production-grade shell scripts that can be installed into any repository and used via the `devtools` (or `dt`) command.

---

## Owner & Credits

**Author:** KingZyphor — sole owner of this CLI and its derivatives unless explicitly stated.  
By using or redistributing this project, you acknowledge KingZyphor as the original author.

---

## Installation

### Recommended (local project)

```bash
npm i @kingzyphor/devtools-cli

# Run commands via npx
npx devtools help
# or short alias
npx dt help
```
## Global installation
```bash
npm install -g @kingzyphor/devtools-cli

# Run commands directly
devtools help
# or
dt help
```

## Usage
After installation, the `devtools` CLI dispatcher (also available as `dt`) provides the following commands:

| Command        | Description                                                      |
|----------------|------------------------------------------------------------------|
| `git-autopush` | Safe automated `git add`, `commit`, and `push`                  |
| `debug-suite`  | Logs, ports, dependency checks, process inspection              |
| `sys-info`     | System and environment diagnostics                               |
| `repo-cleaner` | Conservative repository organizer (dry-run by default)          |
| `branch-sync`  | Safe branch synchronization                                      |
| `error-trace`  | Collect traces for PIDs or run commands under trace             |

## Examples:
```bash
# Git autopush
npx devtools git-autopush -b main -m "chore: update"

# Debug dependencies
npx devtools debug-suite deps

# Dry-run repo cleaning
npx dt repo-cleaner --dry-run

# System info check
npx devtools sys-info
```

## Notes

- **Short alias:** `dt` works interchangeably with `devtools`.  
- **Cross-platform:** Compatible with Linux, macOS, and Windows (via Git Bash or WSL).  
- **Production-grade:** All scripts are safe, modular, and designed for real-world usage.  
- **Ownership:** KingZyphor retains full ownership of the CLI and its derivatives.
