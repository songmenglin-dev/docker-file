#!/usr/bin/env bash
# backup-catalog.sh — dump the gateway's MySQL catalog to a mysqldump file.
#
# Use this BEFORE any operation that destroys the container:
#   - `docker-compose down`
#   - `docker-compose up -d --force-recreate`
#   - VM reboot
#
# Usage:
#   bash scripts/backup-catalog.sh                       # writes ./sequoiasql-mysql-YYYYMMDD-HHMMSS.sql
#   bash scripts/backup-catalog.sh /tmp/mysnapshot.sql    # explicit path
#
# Why mysqldump (not raw file copy): the image's instance registration lives
# on the container's overlay filesystem, not in /opt/sequoiasql/mysql/database.
# Copying the raw data dir to a volume preserves the SQL objects but the
# entrypoint on the next start fails with "instance does not exist". A
# logical dump (CREATE DATABASE/USER/GRANT + INSERT rows) bypasses that
# entirely — we apply it via `mysql <` after a fresh init.
#
# Companion: scripts/restore-catalog.sh
set -uo pipefail

GATEWAY="sequoiasql-mysql"
HOST="${BACKUP_HOST:-127.0.0.1}"
PORT="${BACKUP_PORT:-13306}"
USER="${BACKUP_USER:-root}"

DUMP="${1:-./sequoiasql-mysql-$(date +%Y%m%d-%H%M%S).sql}"

if ! command -v docker >/dev/null 2>&1; then
  printf 'backup-catalog: docker is not installed or not in PATH\n' >&2
  exit 1
fi

running=$(docker inspect -f '{{.State.Running}}' "$GATEWAY" 2>/dev/null || echo missing)
if [ "$running" != "true" ]; then
  printf 'backup-catalog: container %s is not running (state="%s")\n' "$GATEWAY" "$running" >&2
  exit 1
fi

printf 'backup-catalog: dumping from %s:%s to %s ...\n' "$HOST" "$PORT" "$DUMP"
# mysqldump runs over TCP on the host port (13306), not inside the container.
# --all-databases ensures appdb + mysql.user are captured together so the
# restore recreates users with their grants intact.
if mysqldump -h "$HOST" -P "$PORT" -u "$USER" \
     --single-transaction --routines --triggers --events \
     --add-drop-database --databases mysql appdb > "$DUMP" 2>&1; then
  printf 'backup-catalog: ✓ wrote %s (%s bytes)\n' "$DUMP" "$(wc -c < "$DUMP")"
else
  rc=$?
  printf 'backup-catalog: ✗ mysqldump failed (rc=%d)\n' "$rc" >&2
  rm -f "$DUMP"
  exit 1
fi
