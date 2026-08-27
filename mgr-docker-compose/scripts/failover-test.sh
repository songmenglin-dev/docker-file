#!/usr/bin/env bash
# Manual failover drill: docker stop PRIMARY, observe router R/W recovery.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

PRIMARY=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'")
echo "Current PRIMARY: $PRIMARY"

# A baseline query through router R/W
docker run --rm --network mgr-net \
  -e MYSQL_PWD="${MYSQL_ROOT_PASSWORD}" \
  "${MYSQL_IMAGE}" \
  mysql -hmgr-router -P6446 -uroot -e "SELECT 1" >/dev/null

echo "Stopping $PRIMARY..."
docker stop "$PRIMARY" >/dev/null

echo "Polling R/W router for recovery (up to 60 s)..."
start=$(date +%s)
new_primary=""
for _ in $(seq 1 60); do
  if docker run --rm --network mgr-net \
       -e MYSQL_PWD="${MYSQL_ROOT_PASSWORD}" \
       "${MYSQL_IMAGE}" \
       mysql -hmgr-router -P6446 -uroot -N -B -e "SELECT 1" >/dev/null 2>&1; then
    elapsed=$(( $(date +%s) - start ))
    # Wait a few extra seconds for the new PRIMARY to be elected stably
    sleep 5
    new_primary=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
      "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'" 2>/dev/null || true)
    [ -n "$new_primary" ] && [ "$new_primary" != "$PRIMARY" ] && {
      echo "  recovered in ${elapsed}s; new PRIMARY = $new_primary"
      break
    }
    new_primary=""
  fi
  sleep 1
done
[ -n "$new_primary" ] || { echo "FAIL: router R/W did not recover in 60 s, or PRIMARY did not change" >&2; docker start "$PRIMARY" >/dev/null; exit 1; }

echo "Restarting $PRIMARY (expect it to rejoin as SECONDARY)..."
docker start "$PRIMARY" >/dev/null
sleep 15
role=$(docker exec "$PRIMARY" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_ROLE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='$PRIMARY'" 2>/dev/null || echo "")
echo "  $PRIMARY role after restart: $role"

if [ "$role" = "SECONDARY" ]; then
  echo "FAILOVER-TEST: PASS"
else
  echo "FAILOVER-TEST: WARN (old primary rejoined as $role; expected SECONDARY)" >&2
  exit 1
fi