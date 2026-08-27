#!/usr/bin/env bash
# mysqldump full backup, run against the current PRIMARY.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

# Find the service name of the PRIMARY by iterating mgr-node1/2/3
PRIMARY=""
for svc in mgr-node1 mgr-node2 mgr-node3; do
  role=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT MEMBER_ROLE FROM performance_schema.replication_group_members WHERE MEMBER_ID=@@server_uuid" 2>/dev/null || echo "")
  if [ "$role" = "PRIMARY" ]; then
    PRIMARY="$svc"
    break
  fi
done
[ -n "$PRIMARY" ] || { echo "ERROR: no PRIMARY in group - refusing to backup" >&2; exit 1; }
echo "Backing up PRIMARY=$PRIMARY"

stamp=$(date +%F_%H%M%S)
out="backups/mgr_${stamp}.sql.gz"
mkdir -p backups

docker exec "$PRIMARY" mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" \
  --all-databases --single-transaction \
  --set-gtid-purged=ON --triggers --routines --events \
  | gzip -9 > "$out"

ls -lh "$out"
echo "Backup written: $out"
echo "NOTE: rotate old backups manually or with cron - see docs/RUNBOOK.md"