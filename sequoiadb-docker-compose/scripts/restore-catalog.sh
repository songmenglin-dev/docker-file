#!/usr/bin/env bash
# restore-catalog.sh — pipe a mysqldump file into a freshly-started gateway.
#
# Use AFTER `docker-compose up -d` recreates the container (data dir is empty,
# MySQL is fresh-init). This script just waits for MySQL to be reachable and
# then `mysql < $DUMP`.
#
# Usage:
#   bash scripts/restore-catalog.sh /path/to/dump.sql
#
# Companion: scripts/backup-catalog.sh
set -uo pipefail

DUMP="${1:?usage: $0 <dump.sql>}"
HOST="${RESTORE_HOST:-127.0.0.1}"
PORT="${RESTORE_PORT:-13306}"
USER="${RESTORE_USER:-root}"

if [ ! -f "$DUMP" ]; then
  printf 'restore-catalog: dump file "%s" not found\n' "$DUMP" >&2
  exit 1
fi

printf 'restore-catalog: waiting for MySQL at %s:%s ...\n' "$HOST" "$PORT"
for _ in $(seq 1 30); do
  if mysqladmin ping -h "$HOST" -P "$PORT" -u "$USER" --connect-timeout=2 \
        >/dev/null 2>&1; then
    printf 'restore-catalog: MySQL is up\n'
    break
  fi
  sleep 2
done

if ! mysqladmin ping -h "$HOST" -P "$PORT" -u "$USER" --connect-timeout=2 \
     >/dev/null 2>&1; then
  printf 'restore-catalog: MySQL never became reachable at %s:%s\n' "$HOST" "$PORT" >&2
  exit 1
fi

printf 'restore-catalog: applying %s ...\n' "$DUMP"
if mysql -h "$HOST" -P "$PORT" -u "$USER" < "$DUMP"; then
  printf 'restore-catalog: ✓ restore complete\n'
else
  printf 'restore-catalog: ✗ mysql returned non-zero — restore may be partial\n' >&2
  exit 1
fi
