#!/usr/bin/env bash
# Confirms GTID/ROW consistency: a write on PRIMARY becomes visible on all SECONDARIES.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

marker="consistency_$(date +%s)_$$"

PRIMARY=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'")

# Write via router R/W
docker run --rm --network mgr-net \
  -e MYSQL_PWD="${MYSQL_ROOT_PASSWORD}" \
  "${MYSQL_IMAGE}" \
  mysql -hmgr-router -P6446 -uroot \
    -e "INSERT INTO mgr_smoke.t VALUES (2, $(date +%s), '$marker') ON DUPLICATE KEY UPDATE writer='$marker';" \
  >/dev/null 2>&1

sleep 2
for port in 33361 33362 33363; do
  case "$port" in
    33361) svc=mgr-node1 ;;
    33362) svc=mgr-node2 ;;
    33363) svc=mgr-node3 ;;
  esac
  seen=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT writer FROM mgr_smoke.t WHERE id=2" 2>/dev/null || echo "")
  [ "$seen" = "$marker" ] || { echo "FAIL: $svc (port $port) has writer='$seen', expected '$marker'" >&2; exit 1; }
  echo "  $svc saw marker '$marker'"
done
echo "VERIFY-CONSISTENCY: PASS"