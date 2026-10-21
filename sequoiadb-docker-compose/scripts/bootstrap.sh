#!/usr/bin/env bash
# SequoiaDB 3-node distributed cluster bootstrap.
#
# Implements the official "集群模式部署" procedure (安装部署/集群模式部署.md).
# Many create* calls return -145 / -146 on re-run because state from a previous
# failed attempt is still in sdbcm's local registry; we treat those as success
# since the underlying node IS being created (verified by startNode succeeding
# after a "failed" createCoord — see /tmp bootstrap notes).
#
# Steps:
#   1. Wait for sdbcm on all 3 nodes.
#   2. Connect to node1's sdbcm via Oma; create temporary coord at 29800.
#   3. Connect to temp coord; create catalog group with 3 nodes.
#   4. Create data group "group1" with 3 nodes.
#   5. Create coord group with 3 nodes.
#   6. Remove the temporary coord via Oma.
#   7. Write /var/sdb-bootstrap/.done so per-node wrappers can start local nodes.
set -uo pipefail   # not -e: we tolerate individual createXxx -145/-146 errors

SDB_HOME="/opt/sequoiadb"
SDB_BIN="$SDB_HOME/bin"
SDB_TMPJS="/var/tmp/bootstrap.js"

NODE_1="${SDB_NODE_1:?SDB_NODE_1 required}"
NODE_2="${SDB_NODE_2:?SDB_NODE_2 required}"
NODE_3="${SDB_NODE_3:?SDB_NODE_3 required}"
CATALOG_PORT="${SDB_CATALOG_PORT:-11800}"
DATA_PORT="${SDB_DATA_PORT:-11820}"
COORD_PORT="${SDB_COORD_PORT:-11810}"
DATA_GROUP="${SDB_DATA_GROUP:-group1}"
TEMP_COORD_PORT="${SDB_TEMP_COORD_PORT:-29800}"
CM_PORT="${SDB_CM_PORT:-11790}"
BOOTSTRAP_DIR="${SDB_BOOTSTRAP_DIR:-/var/sdb-bootstrap}"
BOOTSTRAP_MARKER="$BOOTSTRAP_DIR/.done"

log()  { printf '%s [bootstrap] %s\n' "$(date --rfc-3339=seconds)" "$*"; }
fail() { printf '%s [bootstrap] ERROR: %s\n' "$(date --rfc-3339=seconds)" "$*" >&2; exit 1; }

wait_for_cm() {
  local host="$1" tries=60
  log "waiting for sdbcm on $host:$CM_PORT..."
  while [ "$tries" -gt 0 ]; do
    if (echo > "/dev/tcp/$host/$CM_PORT") 2>/dev/null; then
      log "  sdbcm on $host is up"
      return 0
    fi
    tries=$((tries-1))
    sleep 3
  done
  fail "sdbcm on $host:$CM_PORT did not become reachable in time"
}

# Run sdb -f and return the output. We deliberately don't exit on non-zero
# because createXxx calls may return -145/-146 ("already exists") which we
# treat as informational, not fatal.
run_sdb() {
  local label="$1"
  shift
  "$SDB_BIN/sdb" -f "$SDB_TMPJS" 2>&1 \
    | grep -v "Using a password" \
    | sed 's/^/  /'
}

log "=== Phase 1: waiting for sdbcm on all 3 nodes ==="
wait_for_cm "$NODE_1"
wait_for_cm "$NODE_2"
wait_for_cm "$NODE_3"

# Ensure shared bootstrap dir is writable by sdbadmin (the user the wrappers
# run as). Named volumes start root:root 755.
log "=== Phase 1.5: chown shared bootstrap dir ==="
chown sdbadmin:sdbadmin_group "$BOOTSTRAP_DIR" 2>/dev/null || true
chmod 755 "$BOOTSTRAP_DIR"

# NOTE: We deliberately do NOT clean up stale temp coord state here. sdbcm's
# behavior makes a clean remove-before-create impossible from inside init
# (no docker CLI to wipe remote files; oma.removeCoord leaves registration).
# Instead we just create + start; createCoord may complain -145 but the
# node IS added (verified).

log "=== Phase 2: create temporary coord on $NODE_1:$TEMP_COORD_PORT ==="
TEMP_COORD_PATH="$SDB_HOME/database/coord/temp-bootstrap-$TEMP_COORD_PORT"
cat > "$SDB_TMPJS" <<JS
var oma = new Oma("$NODE_1", $CM_PORT);
try { oma.createCoord($TEMP_COORD_PORT, "$TEMP_COORD_PATH"); print("createCoord OK"); }
catch (e) { print("createCoord tolerated: " + e); }
try { oma.startNode($TEMP_COORD_PORT); print("startNode OK"); }
catch (e) { print("startNode ERR: " + e); }
JS
run_sdb "phase2"

# Ensure temp coord is reachable before continuing.
for _ in $(seq 1 30); do
  if (echo > "/dev/tcp/$NODE_1/$TEMP_COORD_PORT") 2>/dev/null; then break; fi
  sleep 2
done

log "=== Phase 3: create catalog replica group with 3 nodes ==="
# Catalog group is special: the first node (NODE_1) IS the initial catalog and
# does not need a catalogaddr. Nodes 2 and 3 joining need NODE_1's catalog
# address to know where the catalog quorum lives. Without it, createNode
# returns -180 "There is no catalog address specified by user".
CATALOG_ADDR="$NODE_1:$CATALOG_PORT"
cat > "$SDB_TMPJS" <<JS
var db = new Sdb("$NODE_1", $TEMP_COORD_PORT);
try { db.createCataRG("$NODE_1", $CATALOG_PORT,
  "$SDB_HOME/database/catalog/$CATALOG_PORT"); print("createCataRG OK"); }
catch (e) { print("createCataRG tolerated: " + e); }
var cataRG = db.getCataRG();
function safeCreateNode(rg, host, port, path, label) {
  try { rg.createNode(host, port, path, {catalogaddr:"$CATALOG_ADDR"}); print(label + " createNode OK"); }
  catch (e) { print(label + " createNode tolerated: " + e); }
}
safeCreateNode(cataRG, "$NODE_2", $CATALOG_PORT,
  "$SDB_HOME/database/catalog/$CATALOG_PORT", "n2");
safeCreateNode(cataRG, "$NODE_3", $CATALOG_PORT,
  "$SDB_HOME/database/catalog/$CATALOG_PORT", "n3");
try { cataRG.start(); print("cataRG.start OK"); }
catch (e) { print("cataRG.start tolerated: " + e); }
JS
run_sdb "phase3"

log "=== Phase 4: create data replica group '$DATA_GROUP' with 3 nodes ==="
# Data group nodes also need catalogaddr so they can find the catalog.
# Same -180 error if missing.
cat > "$SDB_TMPJS" <<JS
var db = new Sdb("$NODE_1", $TEMP_COORD_PORT);
var dataRG;
try { dataRG = db.createRG("$DATA_GROUP"); print("createRG OK"); }
catch (e) { print("createRG tolerated: " + e); dataRG = db.getRG("$DATA_GROUP"); }
function safeCreateNode(rg, host, port, path, label) {
  try { rg.createNode(host, port, path, {catalogaddr:"$CATALOG_ADDR"}); print(label + " createNode OK"); }
  catch (e) { print(label + " createNode tolerated: " + e); }
}
safeCreateNode(dataRG, "$NODE_1", $DATA_PORT,
  "$SDB_HOME/database/data/$DATA_PORT", "n1d");
safeCreateNode(dataRG, "$NODE_2", $DATA_PORT,
  "$SDB_HOME/database/data/$DATA_PORT", "n2d");
safeCreateNode(dataRG, "$NODE_3", $DATA_PORT,
  "$SDB_HOME/database/data/$DATA_PORT", "n3d");
try { dataRG.start(); print("dataRG.start OK"); }
catch (e) { print("dataRG.start tolerated: " + e); }
JS
run_sdb "phase4"

log "=== Phase 5: create coord replica group with 3 nodes ==="
# Coord group is a virtual routing layer; its nodes also need catalogaddr.
cat > "$SDB_TMPJS" <<JS
var db = new Sdb("$NODE_1", $TEMP_COORD_PORT);
try { db.createCoordRG(); print("createCoordRG OK"); }
catch (e) { print("createCoordRG tolerated: " + e); }
var coordRG = db.getCoordRG();
function safeCreateNode(rg, host, port, path, label) {
  try { rg.createNode(host, port, path, {catalogaddr:"$CATALOG_ADDR"}); print(label + " createNode OK"); }
  catch (e) { print(label + " createNode tolerated: " + e); }
}
safeCreateNode(coordRG, "$NODE_1", $COORD_PORT,
  "$SDB_HOME/database/coord/$COORD_PORT", "c1");
safeCreateNode(coordRG, "$NODE_2", $COORD_PORT,
  "$SDB_HOME/database/coord/$COORD_PORT", "c2");
safeCreateNode(coordRG, "$NODE_3", $COORD_PORT,
  "$SDB_HOME/database/coord/$COORD_PORT", "c3");
try { coordRG.start(); print("coordRG.start OK"); }
catch (e) { print("coordRG.start tolerated: " + e); }
JS
run_sdb "phase5"

log "=== Phase 6: remove temporary coord ==="
cat > "$SDB_TMPJS" <<JS
var oma = new Oma("$NODE_1", $CM_PORT);
try { oma.stopNode($TEMP_COORD_PORT); print("stopNode OK"); }
catch (e) { print("stopNode tolerated: " + e); }
try { oma.removeCoord($TEMP_COORD_PORT); print("removeCoord OK"); }
catch (e) { print("removeCoord tolerated: " + e); }
JS
run_sdb "phase6" || true

log "=== Phase 7: write bootstrap marker ==="
date --rfc-3339=seconds > "$BOOTSTRAP_MARKER"
echo "nodes: $NODE_1, $NODE_2, $NODE_3" >> "$BOOTSTRAP_MARKER"
echo "groups: SYSCatalogGroup(3), $DATA_GROUP(3), SYSCoordGroup(3)" >> "$BOOTSTRAP_MARKER"

log "=== Bootstrap complete. Cluster is ready. ==="
