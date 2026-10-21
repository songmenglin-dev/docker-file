#!/usr/bin/env bash
# enter-bash.sh — interactively `docker exec` into a SequoiaDB data-node container's bash.
#
# Usage:
#   bash scripts/enter-bash.sh                # defaults to sdbserver1
#   bash scripts/enter-bash.sh sdbserver2     # pick a specific node
#
# The container name is validated BEFORE being handed to docker exec so a typo
# never reaches the docker daemon. The final step uses `exec` to replace this
# shell with `docker exec` so the user lands directly in the container's bash
# prompt, and a clean exit (Ctrl+D / `exit`) returns to the calling terminal
# instead of bouncing through an intermediate bash.
#
# For an interactive SequoiaDB sdb shell on the same node, use enter-sdbshell.sh
# instead — this script always lands in bash, not in sdb's JS REPL.
#
# Style matches scripts/sdb-shell.sh and scripts/sdb-exec.sh: defensive, no
# `set -e` so each preflight check can fail with its own message rather than
# aborting.

set -uo pipefail
cd "$(dirname "$0")/.."

# --- arg parsing -------------------------------------------------------------
TARGET="${1:-sdbserver1}"

# Only the three SDB nodes are valid targets. sequoiasql-mysql is intentionally
# excluded — its entry semantics differ (mysql shell, not bash).
case "$TARGET" in
  sdbserver1|sdbserver2|sdbserver3) ;;
  *)
    printf 'enter-bash: invalid node "%s"; must be one of: sdbserver1 sdbserver2 sdbserver3\n' "$TARGET" >&2
    exit 2
    ;;
esac

# --- preflight ---------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
  printf 'enter-bash: docker is not installed or not in PATH\n' >&2
  exit 1
fi

running=$(docker inspect -f '{{.State.Running}}' "$TARGET" 2>/dev/null || echo missing)
if [ "$running" != "true" ]; then
  printf 'enter-bash: container %s is not running (state="%s"). Start it with: docker compose up -d %s\n' \
    "$TARGET" "$running" "$TARGET" >&2
  exit 1
fi

# Health is informational, not blocking. `starting` is acceptable because we
# want to drop in even during cluster bootstrap; `unhealthy` is a real
# signal that should refuse entry. `none` means no healthcheck is defined
# (e.g. older compose versions) — also fine to proceed.
health=$(docker inspect -f '{{.State.Health.Status}}' "$TARGET" 2>/dev/null || echo none)
case "$health" in
  unhealthy)
    printf 'enter-bash: container %s reports health="%s"; refusing to enter. Check: docker logs %s\n' \
      "$TARGET" "$health" "$TARGET" >&2
    exit 1
    ;;
  starting|none)
    printf 'enter-bash: note — container %s health="%s"; entering anyway\n' "$TARGET" "$health" >&2
    ;;
  healthy)
    : # no news is good news
    ;;
esac

# --- exec --------------------------------------------------------------------
# `exec` replaces this shell with `docker exec` so the user lands directly in
# the container's bash prompt. Without `exec`, `docker exec` would run in a
# subshell and the script's bash would resurface after exit — surprising.
exec docker exec -it "$TARGET" bash