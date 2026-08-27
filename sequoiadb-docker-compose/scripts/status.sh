#!/usr/bin/env bash
# Show 3-node SequoiaDB cluster status.
#   - container states (health, ports, IPs)
#   - inter-node sdbcm reachability
#   - replica group topology
#   - host coord port reachability
set -euo pipefail
cd "$(dirname "$0")/.."
if [ -f .env ]; then
  # shellcheck disable=SC1091
  set -a; . ./.env; set +a
fi
: "${HOST_COORD_PORT_1:=11811}"
: "${HOST_COORD_PORT_2:=11812}"
: "${HOST_COORD_PORT_3:=11813}"

echo "=== Containers ==="
docker ps --filter "name=sdbserver" --filter "name=sdb-init" \
  --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=== Replica group topology ==="
docker exec sdbserver1 /bin/bash -c 'cat > /var/tmp/sdb-topo.js <<EOS
var db = new Sdb("sdbserver1", 11810);
function countNodes(groupName, role) {
  var rg = db.getRG(groupName);
  var ports = { coord: 11810, data: 11820, catalog: 11800 };
  var hosts = ["sdbserver1", "sdbserver2", "sdbserver3"];
  var n = 0;
  for (var i = 0; i < hosts.length; i++) {
    try { rg.getNode(hosts[i], ports[role]); n++; } catch (e) {}
  }
  print(groupName + " nodes=" + n);
}
countNodes("SYSCatalogGroup", "catalog");
countNodes("group1", "data");
countNodes("SYSCoord", "coord");
EOS
chmod 644 /var/tmp/sdb-topo.js'
docker exec sdbserver1 /opt/sequoiadb/bin/sdb -f /var/tmp/sdb-topo.js 2>&1 \
  | grep -v "Using a password" | sed 's/^/  /'

echo ""
echo "=== Inter-node sdbcm (11790) reachability (via docker network) ==="
for n in sdbserver1 sdbserver2 sdbserver3; do
  if docker run --rm --network sequoiadb-docker-compose_sequoiadb-net \
       alpine:latest sh -c "exec 3<>/dev/tcp/$n/11790 && exec 3<&- && exit 0 || exit 1" \
       >/dev/null 2>&1; then
    echo "  $n:11790 OPEN"
  else
    echo "  $n:11790 closed"
  fi
done

echo ""
echo "=== Host coord port reachability ==="
for p in "$HOST_COORD_PORT_1" "$HOST_COORD_PORT_2" "$HOST_COORD_PORT_3"; do
  if exec 3<>/dev/tcp/127.0.0.1/"$p" 2>/dev/null; then exec 3<&-
    echo "  $p OPEN"
  else
    echo "  $p closed"
  fi
done
