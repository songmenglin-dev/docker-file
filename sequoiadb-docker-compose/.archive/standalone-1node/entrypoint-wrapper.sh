#!/usr/bin/env bash
# SequoiaDB 5.x standalone entrypoint wrapper.
# - First boot (empty /opt/sequoiadb/database): SDB_DEPLOY=1 → quickDeploy.sh creates
#   cluster config AND starts nodes.
# - Subsequent boots (data persists): the image's official entrypoint sees
#   "already deployed" but does NOT start nodes. This wrapper explicitly starts
#   them via sdbstart -t all, then keeps the container alive.
set -euo pipefail

SDB_HOME="/opt/sequoiadb"
SDB_BIN="$SDB_HOME/bin"
SDB_DB="$SDB_HOME/database"

echo "[wrapper] starting sdbcm (cluster manager)..."
"$SDB_BIN/sdbcmart" >/dev/null 2>&1 || true

# Already-deployed path: nodes need to be started each boot.
if [ "$(ls -A "$SDB_DB" 2>/dev/null)" ]; then
  echo "[wrapper] existing deployment detected detected; starting nodes via sdbstart..."
  "$SDB_BIN/sdbstart" -t all
else
  echo "[wrapper] empty database directory; running image entrypoint for first-boot deploy..."
  # Defer to the image's official entrypoint logic by re-running it.
  # Use `bash` to invoke (the script is not executable by sdbadmin).
  exec /bin/bash /opt/docker-entrypoint.sh
fi

echo "[wrapper] sequoiadb cluster started; sleeping forever to keep container alive..."
while true; do sleep 60; done