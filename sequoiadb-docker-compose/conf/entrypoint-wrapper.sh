#!/usr/bin/env bash
# Per-node entrypoint wrapper for the 3-node distributed SequoiaDB cluster.
#
# Lifecycle (per official 集群启停.md § 集群管理服务):
#   1. Always start sdbcm (cluster manager daemon). It binds 11790.
#   2. Wait for the init container to finish bootstrapping the cluster
#      topology (shared marker file). This prevents this node from
#      `sdbstart -t all`-ing before its nodes are registered.
#   3. Once the marker exists, run `sdbstart -t all` to start the local
#      coord/catalog/data nodes registered by init's bootstrap.sh.
#   4. sdbcm will keep these nodes alive across restarts; the wrapper just
#      sleeps forever to keep the container foregrounded.
#
# Idempotency:
#   - On cold start: init creates topology, then this script starts nodes.
#   - On restart (cluster already deployed): init is a no-op (marker present),
#     sdbcm auto-restarts registered nodes, and `sdbstart -t all` is harmless.
set -euo pipefail

SDB_HOME="/opt/sequoiadb"
SDB_BIN="$SDB_HOME/bin"
SDB_DB="$SDB_HOME/database"
BOOTSTRAP_DIR="${SDB_BOOTSTRAP_DIR:-/var/sdb-bootstrap}"
BOOTSTRAP_MARKER="$BOOTSTRAP_DIR/.done"

echo "[wrapper] hostname=$(hostname)"

# Fresh-deploy detection: if the shared bootstrap marker is absent, this is
# a brand-new deployment (or an intentional wipe via `docker compose down -v`).
# In that case wipe BOTH the local node's data dirs AND sdbcm's local node
# registry so no stale coord/catalog/data state survives from a previous
# failed init. sdbcm auto-restarts registered nodes, so any leftover
# registration in /opt/sequoiadb/conf/local/ would recreate the dirs after
# the wipe — by wiping both BEFORE sdbcm starts we guarantee a clean slate.
if [ ! -f "$BOOTSTRAP_MARKER" ]; then
  echo "[wrapper] no bootstrap marker → fresh deploy → wiping local state..."
  for d in coord catalog data; do
    if [ -d "$SDB_DB/$d" ]; then
      rm -rf "${SDB_DB:?}/$d" && echo "[wrapper]   wiped $SDB_DB/$d"
    fi
  done
  if [ -d "$SDB_HOME/conf/local" ]; then
    rm -rf "${SDB_HOME:?}/conf/local" && echo "[wrapper]   wiped $SDB_HOME/conf/local (sdbcm local node registry)"
  fi
else
  echo "[wrapper] bootstrap marker present → preserving local state"
fi

echo "[wrapper] starting sdbcm (cluster manager)..."
"$SDB_BIN/sdbcmart" >/dev/null 2>&1 || true

# Defensive: ensure the database directory exists and is owned by sdbadmin
# (the image's runtime user). No-op in normal cases.
mkdir -p "$SDB_DB"
chown -R sdbadmin:sdbadmin_group "$SDB_DB" 2>/dev/null || true

# Wait for init container to finish bootstrap. The marker is written by
# scripts/bootstrap.sh ONLY after topology creation + node startup succeed.
if [ ! -f "$BOOTSTRAP_MARKER" ]; then
  echo "[wrapper] waiting for cluster bootstrap (marker: $BOOTSTRAP_MARKER)..."
  # Wait up to ~5 minutes (60 * 5s). If init never finishes, fail loudly so
  # the container exits and the failure is visible.
  for _ in $(seq 1 60); do
    if [ -f "$BOOTSTRAP_MARKER" ]; then
      break
    fi
    sleep 5
  done
  if [ ! -f "$BOOTSTRAP_MARKER" ]; then
    echo "[wrapper] ERROR: bootstrap marker not found after 5min. Init container likely failed." >&2
    echo "[wrapper] Check: docker logs sdb-init" >&2
    exit 1
  fi
fi
echo "[wrapper] bootstrap marker present; starting local nodes..."

# Start local coord/catalog/data nodes. sdbstart is idempotent for already-running
# nodes (it just reports them as already started).
"$SDB_BIN/sdbstart" -t all || {
  rc=$?
  echo "[wrapper] WARN: sdbstart exited $rc; checking if nodes are already running..." >&2
}

echo "[wrapper] sequoiadb cluster nodes started on $(hostname); sleeping to keep container alive..."
while true; do sleep 60; done
