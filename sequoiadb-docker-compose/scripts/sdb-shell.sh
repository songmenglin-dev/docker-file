#!/usr/bin/env bash
# sdb-shell.sh — open an interactive SequoiaDB sdb shell on a data-node container.
#
# Usage:
#   bash scripts/sdb-shell.sh                   # default: sdbserver1
#   bash scripts/sdb-shell.sh sdbserver2        # pick a specific node
#
# The sdb binary lives at /opt/sequoiadb/bin/sdb inside each data-node image.
# Running it with no arguments opens a JS REPL connected to that node's own
# coord (port 11810); the coord forwards to the catalog/data groups internally.
#
# Useful REPL commands once you're in:
#   var db = new Sdb();                         # connect to local coord
#   db.listReplicaGroups();                     # enumerate replica groups
#   var rg = db.getRG("group1");                # address a specific group
#   rg.getMaster().getHostName();               # which node is primary
#   db.listCollectionSpaces();                  # enumerate SQL collection spaces
#   help;                                       # list all Sdb methods
#   quit;                                       # exit the REPL
#
# sdb-init is intentionally excluded — it's a one-shot bootstrap container
# that has already exited; it has no running sdb process.
#
# Style matches scripts/enter.sh: defensive, no `set -e` so each preflight
# check can fail with its own message rather than aborting.

set -uo pipefail
cd "$(dirname "$0")/.."

# --- arg parsing -------------------------------------------------------------
TARGET="${1:-sdbserver1}"

# Only the three SDB nodes are valid targets. sequoiasql-mysql is excluded
# (mysql shell, not sdb); sdb-init is excluded (one-shot, exited).
case "$TARGET" in
  sdbserver1|sdbserver2|sdbserver3) ;;
  *)
    printf 'sdb-shell: invalid node "%s"; must be one of: sdbserver1 sdbserver2 sdbserver3\n' "$TARGET" >&2
    exit 2
    ;;
esac

# --- preflight ---------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
  printf 'sdb-shell: docker is not installed or not in PATH\n' >&2
  exit 1
fi

running=$(docker inspect -f '{{.State.Running}}' "$TARGET" 2>/dev/null || echo missing)
if [ "$running" != "true" ]; then
  printf 'sdb-shell: container %s is not running (state="%s"). Start it with: docker compose up -d %s\n' \
    "$TARGET" "$running" "$TARGET" >&2
  exit 1
fi

# --- exec --------------------------------------------------------------------
# `exec` replaces this shell with `docker exec` so the user lands directly in
# the sdb REPL. Without `exec`, `docker exec` would run in a subshell and the
# script's bash would resurface after exit — surprising.
exec docker exec -it "$TARGET" /opt/sequoiadb/bin/sdb
