#!/usr/bin/env bash
# Smoke test: prove the SequoiaDB cluster is healthy after first boot.
#  - container running and healthy
#  - coord (11810) reachable from host
#  - sdb shell query succeeds (proves catalog + coord + sdbcm are functional)
# Works whether .env is present or not.
set -euo pipefail
cd "$(dirname "$0")/.."
if [ -f .env ]; then
  # shellcheck disable=SC1091
  set -a; . ./.env; set +a
fi

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "=== [1] container running and healthy ==="
status=$(docker inspect --format '{{.State.Health.Status}}' sequoiadb 2>/dev/null || echo missing)
[ "$status" = healthy ] || fail "container not healthy (got '$status')"
echo "  healthy"

echo "=== [2] coord reachable on host:11810 ==="
if exec 3<>/dev/tcp/127.0.0.1/11810 2>/dev/null; then exec 3<&-
  echo "  11810 OPEN"
else
  fail "11810 not reachable"
fi

echo "=== [3] sdb shell query succeeds ==="
# The sdb interactive shell hangs waiting for stdin EOF that pipes don't
# deliver. Workaround: write the JS file INSIDE the container via docker exec
# (so it's owned by sdbadmin) and run `sdb -f` batch mode.
# Use /var/tmp (writable by sdbadmin; /tmp is root-owned and read-only).
docker exec sequoiadb /bin/bash -c 'cat > /var/tmp/sdb-check.js <<EOS
var db = new Sdb("sequoiadb", 11810);
db.listCollectionSpaces();
EOS
chmod 644 /var/tmp/sdb-check.js'
out=$(docker exec sequoiadb /opt/sequoiadb/bin/sdb -f /var/tmp/sdb-check.js 2>&1 | grep -v "Using a password")
echo "$out" | grep -q "Return .* row" || fail "sdb returned no 'Return' line (got: $out)"
echo "  $(echo "$out" | grep 'Return')"

echo ""
echo "VERIFY: PASS"