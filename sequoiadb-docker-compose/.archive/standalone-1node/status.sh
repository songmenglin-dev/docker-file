#!/usr/bin/env bash
# Show SequoiaDB container status, node count, and host port reachability.
# Works whether .env is present or not; variables fall back to safe defaults.
set -euo pipefail
cd "$(dirname "$0")/.."
if [ -f .env ]; then
  # shellcheck disable=SC1091
  set -a; . ./.env; set +a
fi
: "${TZ:=Asia/Shanghai}"

echo "=== Container ==="
docker ps --filter "name=sequoiadb" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=== Cluster reachable from sdb shell ==="
# Use -f batch mode (interactive shell hangs on stdin EOF). Write the JS file
# inside the container at /var/tmp (writable by sdbadmin; /tmp is root-owned).
docker exec sequoiadb /bin/bash -c 'cat > /var/tmp/sdb-check.js <<EOS
var db = new Sdb("sequoiadb", 11810);
db.listCollectionSpaces();
EOS
chmod 644 /var/tmp/sdb-check.js'
out=$(docker exec sequoiadb /opt/sequoiadb/bin/sdb -f /var/tmp/sdb-check.js 2>&1 | grep -v "Using a password")
echo "$out" | grep -q "Return .* row" || echo "  WARN: listCollectionSpaces returned no 'Return' line"
echo "$out" | grep "Return" | sed 's/^/  /'

echo ""
echo "=== Coord reachable on host:11810 ==="
if exec 3<>/dev/tcp/127.0.0.1/11810 2>/dev/null; then exec 3<&-; echo "  11810 OPEN"; else echo "  11810 closed"; fi