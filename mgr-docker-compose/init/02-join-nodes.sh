#!/usr/bin/env bash
# Joins node2 and node3 to the group. Retries each node independently.
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

RETRIES="${BOOTSTRAP_JOIN_RETRIES:-3}"
SLEEP="${BOOTSTRAP_JOIN_SLEEP_SECONDS:-5}"

join_node() {
  local svc="$1"
  # Skip if already ONLINE
  local state
  state=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT MEMBER_STATE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='$svc'" 2>/dev/null || echo "")
  if [ "$state" = "ONLINE" ]; then
    echo "   $svc already ONLINE; skipping"
    return 0
  fi

  echo "   joining $svc (retries=$RETRIES)..."
  local attempt
  for attempt in $(seq 1 "$RETRIES"); do
    # Install plugin only if not already ACTIVE
    local plugin_state
    plugin_state=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
      "SELECT PLUGIN_STATUS FROM information_schema.PLUGINS WHERE PLUGIN_NAME='group_replication'" 2>/dev/null || echo "")
    if [ "$plugin_state" != "ACTIVE" ]; then
      docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" \
        -e "INSTALL PLUGIN group_replication SONAME 'group_replication.so';" \
        2>&1 | grep -v "Using a password" || true
    fi

    # Issue CHANGE MASTER + START GROUP_REPLICATION
    # RESET MASTER clears any local GTID set (fresh nodes may have inherited
    # system-table transactions on their own server UUID that conflict with
    # the group GTIDs).
    docker exec -i "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
STOP GROUP_REPLICATION;
RESET MASTER;
SET SQL_LOG_BIN=0;
CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='${REPL_PASSWORD}' FOR CHANNEL 'group_replication_recovery';
SET SQL_LOG_BIN=1;
START GROUP_REPLICATION;
SQL

    # Poll for ONLINE (filter by local server-id; MEMBER_HOST is the container ID)
    local _i
    for _i in $(seq 1 15); do
      online_count=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
        "SELECT COUNT(*) FROM performance_schema.replication_group_members WHERE MEMBER_STATE='ONLINE' AND MEMBER_ID=@@server_uuid" 2>/dev/null || echo 0)
      [ "$online_count" = "1" ] && { echo "   $svc ONLINE"; return 0; }
      sleep 2
    done

    echo "   attempt $attempt failed for $svc; sleeping ${SLEEP}s"
    sleep "$SLEEP"
  done
  echo "ERROR: $svc failed to join after $RETRIES attempts" >&2
  return 1
}

join_node mgr-node2
join_node mgr-node3