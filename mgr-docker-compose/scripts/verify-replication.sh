#!/usr/bin/env bash
# Writes a row/sec through router R/W for 60 s; checks replication lag.
# Uses docker exec into mgr-node1 for mysql client (no host mysql client required).
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

# Find PRIMARY (writes must go to it through router R/W)
PRIMARY=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'")
[ -n "$PRIMARY" ] || { echo "ERROR: no PRIMARY in group"; exit 1; }
echo "  PRIMARY = $PRIMARY"

# Helper: run a SQL via docker exec on the chosen node
mysql_on() {
  local svc="$1"; shift
  docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" "$@"
}

# Setup schema on PRIMARY (use mgr-node1 as the write host; if PRIMARY is node2/3,
# we still write through docker exec on the PRIMARY)
echo "  creating mgr_smoke.t on $PRIMARY..."
mysql_on "$PRIMARY" -e "
  CREATE DATABASE IF NOT EXISTS mgr_smoke;
  CREATE TABLE IF NOT EXISTS mgr_smoke.t (
    id INT PRIMARY KEY,
    ts BIGINT NOT NULL,
    writer VARCHAR(32) NOT NULL
  );" >/dev/null

# Write via router R/W (so we test the read/write split path too).
# Router R/W sends writes to PRIMARY. We have no host mysql client, so use
# `docker run --rm mysql:8.0 mysql ...` as a one-shot client.
echo "  writing 1 row/sec for 60 s through router R/W (33461)..."
end=$(( $(date +%s) + 60 ))
while [ "$(date +%s)" -lt "$end" ]; do
  ts=$(date +%s)
  docker run --rm --network mgr-net \
    -e MYSQL_PWD="${MYSQL_ROOT_PASSWORD}" \
    "${MYSQL_IMAGE}" \
    mysql -hmgr-router -P6446 -uroot \
      -e "INSERT INTO mgr_smoke.t VALUES (1, $ts, 'repl-test') ON DUPLICATE KEY UPDATE ts=$ts, writer='repl-test';" \
    >/dev/null 2>&1
  sleep 1
done

echo "  reading latest_ts from each node (direct port)..."
last_ts=$(mysql_on "$PRIMARY" -N -B -e "SELECT MAX(ts) FROM mgr_smoke.t")
echo "    PRIMARY ($PRIMARY): $last_ts"

max_delta=0
for port in 33361 33362 33363; do
  case "$port" in
    33361) svc=mgr-node1 ;;
    33362) svc=mgr-node2 ;;
    33363) svc=mgr-node3 ;;
  esac
  t=$(mysql_on "$svc" -N -B -e "SELECT MAX(ts) FROM mgr_smoke.t" 2>/dev/null || echo 0)
  delta=$(( last_ts - t ))
  [ "$delta" -lt 0 ] && delta=$((-delta))
  [ "$delta" -gt "$max_delta" ] && max_delta=$delta
  echo "    $svc (port $port): $t (delta=$delta)"
done

if [ "$max_delta" -le 5 ]; then
  echo "VERIFY-REPLICATION: PASS (max delta=${max_delta}s <= 5s)"
else
  echo "VERIFY-REPLICATION: FAIL (max delta=${max_delta}s > 5s)" >&2
  exit 1
fi