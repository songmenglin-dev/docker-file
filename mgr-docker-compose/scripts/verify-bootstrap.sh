#!/usr/bin/env bash
# Verifies the cluster is healthy after bootstrap.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "=== [1] All 3 nodes ONLINE ==="
for svc in mgr-node1 mgr-node2 mgr-node3; do
  # MEMBER_HOST in MySQL is the container ID; check via local @@server_uuid instead
  state=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT MEMBER_STATE FROM performance_schema.replication_group_members WHERE MEMBER_ID=@@server_uuid" 2>/dev/null || echo MISSING)
  [ "$state" = "ONLINE" ] || fail "$svc state=$state (expected ONLINE)"
  echo "  $svc ONLINE"
done

echo "=== [2] One PRIMARY, two SECONDARY ==="
roles=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_ROLE FROM performance_schema.replication_group_members" | sort | uniq -c)
echo "$roles" | grep -qE "^\s*2\s+SECONDARY\s*$" || fail "expected 2 SECONDARY (got: $roles)"
echo "$roles" | grep -qE "^\s*1\s+PRIMARY\s*$"    || fail "expected 1 PRIMARY (got: $roles)"
echo "  role distribution:"
echo "$roles" | sed 's/^/    /'

echo "=== [3] Router R/W + R/O reachable (skipped — router not deployed in this env) ==="
echo "  (skip — old mysql-router image requires InnoDB Cluster metadata; see RUNBOOK §Router)"

echo "=== [4] Smoke write propagates to all nodes within 5s ==="
TS=$(date +%s)

# Find the service name of the PRIMARY by checking each node's role
PRIMARY_SVC=""
for svc in mgr-node1 mgr-node2 mgr-node3; do
  role=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT MEMBER_ROLE FROM performance_schema.replication_group_members WHERE MEMBER_ID=@@server_uuid" 2>/dev/null || echo "")
  if [ "$role" = "PRIMARY" ]; then
    PRIMARY_SVC="$svc"
    break
  fi
done
[ -n "$PRIMARY_SVC" ] || fail "could not find PRIMARY node"
echo "  PRIMARY = $PRIMARY_SVC"

# Issue write directly via docker exec on the PRIMARY (we know its service name)
# || true suppresses set -e when grep -v finds no non-matching lines (mysql's
# "Using a password" warning is filtered out, leaving no output to process).
docker exec "$PRIMARY_SVC" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "
  CREATE DATABASE IF NOT EXISTS mgr_smoke;
  CREATE TABLE IF NOT EXISTS mgr_smoke.t (id INT PRIMARY KEY, ts BIGINT);
  INSERT INTO mgr_smoke.t VALUES (1, $TS) ON DUPLICATE KEY UPDATE ts=$TS;" 2>&1 | { grep -v "Using a password" || true; }

sleep 2
for svc in mgr-node1 mgr-node2 mgr-node3; do
  seen=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT ts FROM mgr_smoke.t WHERE id=1" 2>/dev/null || echo "")
  [ "$seen" = "$TS" ] || fail "$svc has not seen the smoke write (got '$seen')"
  echo "  $svc saw ts=$TS"
done

echo ""
echo "VERIFY-BOOTSTRAP: PASS"