#!/usr/bin/env bash
# Show 3-node SequoiaDB cluster status.
#   - container states (health, ports)
#   - replica group topology (node count + primary node per group)
#   - inter-node sdbcm reachability
#   - host coord port reachability
#
# Defensive by design: any single check failing MUST NOT mask the others,
# so we use `set -uo pipefail` (no -e) and `|| true` after risky pipelines.
set -uo pipefail
cd "$(dirname "$0")/.."
if [ -f .env ]; then
  # shellcheck disable=SC1091
  set -a; . ./.env; set +a
fi
: "${HOST_COORD_PORT_1:=11811}"
: "${HOST_COORD_PORT_2:=11812}"
: "${HOST_COORD_PORT_3:=11813}"
: "${HOST_SQL_MYSQL_PORT:=13306}"

echo "=== Containers ==="
docker ps --filter "name=sdbserver" --filter "name=sdb-init" \
  --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || true

echo ""
echo "=== Replica group topology ==="
# Probe each replica group independently. Three important constraints:
#   1. In sdb batch mode (`-f`), BSON object properties are NOT directly
#      accessible — only methods returning strings work. So we MUST call
#      `node.getHostName()` / `node.getServiceName()`, never `.HostName`.
#   2. `print()` in sdb batch mode does NOT emit a newline; use
#      `println()` so each group's output lands on its own line.
#   3. The SYSCoord group has no "master" — coord replicas elect an LSN
#      (Log Sync Node), not a primary. Calling `getMaster()` on SYSCoord
#      throws (-71 in current builds), so we special-case it.
docker exec sdbserver1 /bin/bash -c 'cat > /var/tmp/sdb-topo.js <<'"'"'EOS'"'"'
var db = new Sdb("sdbserver1", 11810);
var groups = [
  { name: "SYSCatalogGroup", port: 11800 },
  { name: "group1",          port: 11820 },
  { name: "SYSCoord",        port: 11810 },
];
var hosts = ["sdbserver1", "sdbserver2", "sdbserver3"];
for (var g = 0; g < groups.length; g++) {
  var gi = groups[g];
  var rg;
  try { rg = db.getRG(gi.name); }
  catch (e) { println(gi.name + ": group unavailable (" + e + ")"); continue; }

  // Count nodes by probing each known host:port (same logic as verify.sh).
  var n = 0;
  for (var i = 0; i < hosts.length; i++) {
    try { rg.getNode(hosts[i], gi.port); n++; } catch (e) {}
  }

  // Fetch primary. getMaster() returns a Node or throws when no master
  // is elected. In batch mode, use accessor methods that return strings,
  // never raw property access on the Node object.
  var primaryStr;
  try {
    var p = rg.getMaster();
    primaryStr = (p != null) ? (p.getHostName() + ":" + p.getServiceName()) : "no master";
  } catch (e) {
    // SYSCoord has no master (LSN instead); other groups: real failure.
    primaryStr = (gi.name === "SYSCoord") ? "n/a (coord group, no master)" : ("no master (" + e + ")");
  }
  println(gi.name + " nodes=" + n + " primary=" + primaryStr);
}
EOS
chmod 644 /var/tmp/sdb-topo.js' || echo "  failed to write probe script into sdbserver1"

# `|| true` because sdb -f returns non-zero when any JS exception escapes
# the script. We still want to print the rest of the report.
docker exec sdbserver1 /opt/sequoiadb/bin/sdb -f /var/tmp/sdb-topo.js 2>&1 \
  | grep -v "Using a password" | sed 's/^/  /' || true

echo ""
echo "=== Inter-node sdbcm (11790) reachability (via docker network) ==="
# NOTE: Alpine's /bin/sh (busybox ash) does NOT support bash's /dev/tcp.
# Use `nc -z -w 2` (always present in alpine) — same approach as verify.sh.
for n in sdbserver1 sdbserver2 sdbserver3; do
  if docker run --rm --network sequoiadb-docker-compose_sequoiadb-net \
       alpine:latest nc -z -w 2 "$n" 11790 >/dev/null 2>&1; then
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

echo ""
echo "=== SequoiaSQL-MySQL gateway reachability ==="
# SQL instance is optional — only probe if its container is running.
cname=sequoiasql-mysql
running=$(docker inspect -f '{{.State.Running}}' "$cname" 2>/dev/null || echo "false")
if [ "$running" != "true" ]; then
  echo "  mysql ($cname): not running"
else
  if exec 3<>/dev/tcp/127.0.0.1/"$HOST_SQL_MYSQL_PORT" 2>/dev/null; then exec 3<&-
    echo "  mysql $HOST_SQL_MYSQL_PORT OPEN"
  else
    echo "  mysql $HOST_SQL_MYSQL_PORT closed"
  fi
fi