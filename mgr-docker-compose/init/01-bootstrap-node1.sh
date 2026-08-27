#!/usr/bin/env bash
# Configures mgr-node1: repl user + group bootstrap.
# Idempotent: re-running on a member that's already ONLINE is a no-op.
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

# If node1 already in group, skip.
existing=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_STATE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='mgr-node1'" 2>/dev/null || echo "")
if [ "$existing" = "ONLINE" ]; then
  echo "   mgr-node1 already ONLINE; skipping bootstrap"
  exit 0
fi

docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "
  INSTALL PLUGIN group_replication SONAME 'group_replication.so';
" 2>&1 | grep -v "Using a password" || true

# Confirm plugin is ACTIVE (INSTALL PLUGIN is idempotent; second call would error, that's fine)
plugin_state=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT PLUGIN_STATUS FROM information_schema.PLUGINS WHERE PLUGIN_NAME='group_replication'")
if [ "$plugin_state" != "ACTIVE" ]; then
  echo "ERROR: group_replication plugin not ACTIVE (got '$plugin_state')" >&2; exit 1
fi

docker exec -i mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
SET SQL_LOG_BIN=0;
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY '${REPL_PASSWORD}';
GRANT REPLICATION SLAVE, BACKUP_ADMIN ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
SET SQL_LOG_BIN=1;

CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='${REPL_PASSWORD}' FOR CHANNEL 'group_replication_recovery';

SET GLOBAL group_replication_bootstrap_group=ON;
START GROUP_REPLICATION;
SET GLOBAL group_replication_bootstrap_group=OFF;
SQL

# Wait for ONLINE. MEMBER_HOST in MySQL is the container's @hostname, which
# is the container ID (not the docker service name). So we filter by the local
# server-id instead.
echo "   waiting for mgr-node1 to reach ONLINE..."
state=""
for _ in $(seq 1 30); do
  # Count ONLINE members — there should be exactly one (us) after bootstrap
  online_count=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT COUNT(*) FROM performance_schema.replication_group_members WHERE MEMBER_STATE='ONLINE' AND MEMBER_ID=@@server_uuid" 2>/dev/null || echo 0)
  [ "$online_count" = "1" ] && { state="ONLINE"; break; }
  sleep 2
done
[ "$state" = "ONLINE" ] || { echo "ERROR: mgr-node1 did not reach ONLINE" >&2; exit 1; }
echo "   mgr-node1 ONLINE"