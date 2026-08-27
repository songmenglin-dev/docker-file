#!/usr/bin/env bash
# Print MGR cluster topology.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

echo "=== Containers ==="
docker ps --filter "name=mgr-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=== Group members (mgr-node1 view) ==="
docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -t -e "
  SELECT MEMBER_ID, MEMBER_HOST, MEMBER_STATE, MEMBER_ROLE, MEMBER_VERSION
  FROM performance_schema.replication_group_members
  ORDER BY MEMBER_HOST;"

echo ""
echo "=== Router listeners (skipped — nc not available / router not deployed) ==="
if exec 3<>/dev/tcp/127.0.0.1/33461 2>/dev/null; then exec 3<&-; echo "  33461 (R/W) open"; else echo "  33461 (R/W) closed"; fi
if exec 3<>/dev/tcp/127.0.0.1/33471 2>/dev/null; then exec 3<&-; echo "  33471 (R/O) open"; else echo "  33471 (R/O) closed"; fi