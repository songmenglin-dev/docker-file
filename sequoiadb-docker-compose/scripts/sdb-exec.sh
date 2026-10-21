#!/usr/bin/env bash
# sdb-exec.sh — run SequoiaDB sdb shell commands non-interactively.
#
# Usage:
#   bash scripts/sdb-exec.sh -c 'var db = new Sdb(); db.listReplicaGroups();'
#   bash scripts/sdb-exec.sh sdbserver2 -c '...'
#   bash scripts/sdb-exec.sh -f path/to/script.js
#   cat commands.js | bash scripts/sdb-exec.sh         # stdin
#   bash scripts/sdb-exec.sh                           # stdin (default node)
#
# Node defaults to sdbserver1. The node's own coord (11810) is used as the
# connection target — same as an interactive sdb-shell session.
#
# All three modes run `sdb -f /dev/stdin` (or `sdb -f <file>`) inside the
# container so the sdb process is in batch mode: it executes the script and
# exits on EOF, making output pipeline-friendly (grep, awk, jq, etc).
#
# Examples:
#   # Count collections in appdb
#   bash scripts/sdb-exec.sh -c 'var db = new Sdb("sdbserver1", 11810);
#                                db.listCollectionSpaces().toArray()
#                                  .filter(cs => cs.Name === "appdb")[0]
#                                  .toString()' | head -5
#
#   # Run a maintenance script on sdbserver2
#   bash scripts/sdb-exec.sh sdbserver2 -f ./maintenance.js
#
# Style matches scripts/enter.sh: defensive, no `set -e` so each preflight
# check can fail with its own message rather than aborting.

set -uo pipefail
cd "$(dirname "$0")/.."

# --- arg parsing -------------------------------------------------------------
TARGET=""
MODE=""
ARG=""

positional=()
while [ $# -gt 0 ]; do
  case "$1" in
    -c)
      MODE=cmd; ARG="$2"; shift 2 ;;
    -f)
      MODE=file; ARG="$2"; shift 2 ;;
    -h|--help)
      printf 'Usage: sdb-exec.sh [-c "code" | -f file.js] [node]\n' >&2
      printf '       cat script.js | sdb-exec.sh [node]\n' >&2
      exit 0
      ;;
    -*)
      printf 'sdb-exec: unknown flag "%s"\n' "$1" >&2
      exit 2
      ;;
    *)
      positional+=("$1"); shift ;;
  esac
done

# First non-flag positional is the node; default sdbserver1.
TARGET="${positional[0]:-sdbserver1}"

case "$TARGET" in
  sdbserver1|sdbserver2|sdbserver3) ;;
  *)
    printf 'sdb-exec: invalid node "%s"; must be one of: sdbserver1 sdbserver2 sdbserver3\n' "$TARGET" >&2
    exit 2
    ;;
esac

# --- preflight ---------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
  printf 'sdb-exec: docker is not installed or not in PATH\n' >&2
  exit 1
fi

running=$(docker inspect -f '{{.State.Running}}' "$TARGET" 2>/dev/null || echo missing)
if [ "$running" != "true" ]; then
  printf 'sdb-exec: container %s is not running (state="%s").\n' "$TARGET" "$running" >&2
  exit 1
fi

# --- exec --------------------------------------------------------------------
# SequoiaDB's sdb binary does NOT support `-f /dev/stdin` (it tries to stat
# the path and fails on the pseudo-fs device). Workaround: stream the script
# content into a per-PID temp file inside the container, then `sdb -f` that
# file, then rm. Three docker exec calls per invocation — the file is tiny
# (sub-ms transfer) so the overhead is negligible compared to the round-trip.
#
# The temp filename uses $$ (host shell PID). Concurrent sdb-exec.sh calls
# on different PIDs do not collide; on the same host PID collisions only
# happen within the same shell process tree, which is unrealistic for this
# interactive script.
TMPNAME="/tmp/sdb-exec-$$.js"

cleanup() {
  # Best-effort: ignore failures (container may be gone, file may not exist).
  docker exec "$TARGET" rm -f "$TMPNAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

case "$MODE" in
  file)
    if [ ! -f "$ARG" ]; then
      printf 'sdb-exec: file "%s" not found\n' "$ARG" >&2
      exit 1
    fi
    # Stream host file into container, then run sdb on it.
    docker exec -i "$TARGET" sh -c "cat > $TMPNAME" < "$ARG"
    docker exec -i "$TARGET" /opt/sequoiadb/bin/sdb -f "$TMPNAME"
    ;;
  cmd)
    # Printf adds a trailing newline so the last JS statement flushes before EOF.
    printf '%s\n' "$ARG" \
      | docker exec -i "$TARGET" sh -c "cat > $TMPNAME"
    docker exec -i "$TARGET" /opt/sequoiadb/bin/sdb -f "$TMPNAME"
    ;;
  *)
    # Default: host stdin is piped through docker exec into the container.
    docker exec -i "$TARGET" sh -c "cat > $TMPNAME"
    docker exec -i "$TARGET" /opt/sequoiadb/bin/sdb -f "$TMPNAME"
    ;;
esac
