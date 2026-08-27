#!/usr/bin/env bash
# Confirms router splits R/W vs R/O traffic.
# Uses a one-shot mysql:8.0 container as the client (no host mysql client needed).
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

PRIMARY_HOST=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'")

# R/W should land on PRIMARY
rw_host=$(docker run --rm --network mgr-net \
  -e MYSQL_PWD="${MYSQL_ROOT_PASSWORD}" \
  "${MYSQL_IMAGE}" \
  mysql -hmgr-router -P6446 -uroot -N -B -e "SELECT @@hostname")
[ "$rw_host" = "$PRIMARY_HOST" ] || { echo "FAIL: R/W went to $rw_host, expected PRIMARY=$PRIMARY_HOST" >&2; exit 1; }
echo "  R/W -> $rw_host (PRIMARY) OK"

# R/O should land on a SECONDARY (loop until we see one, with timeout)
ok=0
for _ in $(seq 1 10); do
  ro_host=$(docker run --rm --network mgr-net \
    -e MYSQL_PWD="${MYSQL_ROOT_PASSWORD}" \
    "${MYSQL_IMAGE}" \
    mysql -hmgr-router -P6447 -uroot -N -B -e "SELECT @@hostname")
  if [ "$ro_host" != "$PRIMARY_HOST" ]; then
    ok=1; break
  fi
  sleep 1
done
[ "$ok" = 1 ] || { echo "FAIL: R/O kept landing on PRIMARY=$PRIMARY_HOST" >&2; exit 1; }
echo "  R/O -> $ro_host (SECONDARY) OK"

echo "VERIFY-ROUTER-RW-SPLIT: PASS"