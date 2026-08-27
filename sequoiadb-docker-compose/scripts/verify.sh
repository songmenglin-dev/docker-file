#!/usr/bin/env bash
# Smoke test for the 3-node SequoiaDB distributed cluster.
# Checks:
#   1. All three sdbserver{1,2,3} containers are running and healthy.
#   2. All three sdbcm ports (11790) are reachable on the docker network.
#   3. The bootstrap marker exists (init container finished).
#   4. A coord query from any node shows the 3-group topology.
#   5. All three coord ports (11811/11812/11813 on host) are reachable.
set -euo pipefail
cd "$(dirname "$0")/.."
if [ -f .env ]; then
  # shellcheck disable=SC1091
  set -a; . ./.env; set +a
fi
: "${HOST_COORD_PORT_1:=11811}"
: "${HOST_COORD_PORT_2:=11812}"
: "${HOST_COORD_PORT_3:=11813}"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "  PASS: $*"; }

echo "=== [1] all 3 containers running and healthy ==="
for n in sdbserver1 sdbserver2 sdbserver3; do
  s=$(docker inspect --format '{{.State.Health.Status}}' "$n" 2>/dev/null || echo missing)
  [ "$s" = healthy ] || fail "$n not healthy (got '$s')"
  pass "$n is healthy"
done

echo "=== [2] sdbcm ports reachable across the docker network ==="
# Alpine's /bin/sh lacks bash's /dev/tcp. Use `nc -z` from busybox (always in alpine).
for hp in "sdbserver1 11790" "sdbserver2 11790" "sdbserver3 11790"; do
  set -- $hp
  if docker run --rm --network sequoiadb-docker-compose_sequoiadb-net \
       alpine:latest nc -z -w 2 "$1" "$2" >/dev/null 2>&1; then
    pass "$1:$2 reachable"
  else
    fail "$1:$2 not reachable"
  fi
done

echo "=== [3] bootstrap marker exists ==="
marker=$(docker exec sdbserver1 ls /var/sdb-bootstrap/.done 2>/dev/null || echo missing)
[ "$marker" != missing ] || fail "bootstrap marker not found; sdb-init likely failed (docker logs sdb-init)"
pass "marker present"

echo "=== [4] cluster topology: 3 replica groups, each with 3 nodes ==="
# rg.getDetail() returns an object whose properties aren't directly accessible
# in sdb batch mode (only toString works). Instead, probe each known
# host:port with getNode and count successes.
docker exec sdbserver1 /bin/bash -c 'cat > /var/tmp/sdb-topo.js <<EOS
var db = new Sdb("sdbserver1", 11810);
function countNodes(groupName, role) {
  var rg = db.getRG(groupName);
  var ports = { coord: 11810, data: 11820, catalog: 11800 };
  var hosts = ["sdbserver1", "sdbserver2", "sdbserver3"];
  var n = 0;
  for (var i = 0; i < hosts.length; i++) {
    try { rg.getNode(hosts[i], ports[role]); n++; }
    catch (e) { /* node not in group */ }
  }
  print(groupName + " nodes=" + n);
}
countNodes("SYSCatalogGroup", "catalog");
countNodes("group1", "data");
countNodes("SYSCoord", "coord");
EOS
chmod 644 /var/tmp/sdb-topo.js'
out=$(docker exec sdbserver1 /opt/sequoiadb/bin/sdb -f /var/tmp/sdb-topo.js 2>&1 | grep -v "Using a password" || true)
echo "$out" | grep -q "SYSCatalogGroup" || fail "SYSCatalogGroup not listed (got: $out)"
echo "$out" | grep -q "group1" || fail "data group1 not listed (got: $out)"
echo "$out" | grep -q "SYSCoord" || fail "SYSCoord not listed (got: $out)"
n=$(echo "$out" | grep -o "nodes=3" | wc -l | tr -d ' ' || true)
[ "$n" = "3" ] || fail "expected exactly 3 groups with nodes=3, got $n (output: $out)"
echo "$out" | grep -o "[A-Za-z]* nodes=3" | sed 's/^/  /'

echo "=== [5] all 3 host coord ports reachable ==="
for p in "$HOST_COORD_PORT_1" "$HOST_COORD_PORT_2" "$HOST_COORD_PORT_3"; do
  if exec 3<>/dev/tcp/127.0.0.1/"$p" 2>/dev/null; then exec 3<&-
    pass "host:$p OPEN"
  else
    fail "host:$p not reachable"
  fi
done

echo ""
echo "VERIFY: PASS — 3-node SequoiaDB cluster is healthy"
