#!/usr/bin/env bash
# Configures mgr-router:
#   1. Run `mysqlrouter --bootstrap` against node1 to generate config.
#   2. Persist the generated mysqlrouter.conf on the host (bind mount).
#   3. Start a router container with the persisted config.
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

CONFIG_DIR="$(pwd)/mgr-router-conf"
mkdir -p "$CONFIG_DIR"

# --- Step 1: Bootstrap (generate config if missing) ---------------------------
if [ -f "$CONFIG_DIR/mysqlrouter.conf" ]; then
  echo "   mysqlrouter.conf already exists; skipping bootstrap"
else
  echo "   bootstrapping mysqlrouter config..."
  # Bypass mysqlrouter --bootstrap entirely. The image's old mysqlrouter
  # (mysql/mysql-router:8.0 from 3 years ago) hard-requires InnoDB Cluster
  # metadata, which we don't have and the network can't pull a newer image.
  #
  # Instead we write a minimal config by hand. mysqlrouter will discover the
  # PRIMARY via performance_schema.replication_group_members automatically.
  cat > "$CONFIG_DIR/mysqlrouter.conf" <<'CONF'
[DEFAULT]
logging_folder =
connect_timeout = 5
read_timeout = 30
server_id = 100
keyring_path = /var/lib/mysqlrouter/keyring

[metadata_cache:cluster]
cluster_type = gr
router_id = 1
user = root
password = __ROOT_PW__
metadata_cluster = mgr-docker-compose-cluster
ttl = 0.5
auth_cache_ttl = -1
use_gr_notifications = 0

[routing:rw]
bind_address = 0.0.0.0
bind_port = 6446
destinations = mgr-node1:3306,mgr-node2:3306,mgr-node3:3306
routing_strategy = first-available
mode = read-write
protocol = classic
connection_sharing = 0
client_ssl_mode = PREFERRED
server_ssl_mode = PREFERRED

[routing:ro]
bind_address = 0.0.0.0
bind_port = 6447
destinations = mgr-node1:3306,mgr-node2:3306,mgr-node3:3306
routing_strategy = round-robin-with-fallback
mode = read-only
protocol = classic
connection_sharing = 1
client_ssl_mode = PREFERRED
server_ssl_mode = PREFERRED
CONF

  # Substitute the password placeholder with the real root password
  sed -i "s|__ROOT_PW__|${MYSQL_ROOT_PASSWORD}|g" "$CONFIG_DIR/mysqlrouter.conf"
  chmod 644 "$CONFIG_DIR/mysqlrouter.conf"
  echo "   config written"
fi

# --- Step 2: Start router container with the persisted config ----------------
if docker ps -a --format '{{.Names}}' | grep -qx mgr-router; then
  docker rm -f mgr-router >/dev/null
fi

# Use /bin/sh as entrypoint so the image's /run.sh wrapper (which would
# intercept `mysqlrouter` as the first arg and override --config) is bypassed.
# Mount a named volume for /var/lib/mysqlrouter so the keyring file persists
# across container restarts but is owned by the container's mysqlrouter user.
docker volume create mgr_router_data >/dev/null 2>&1 || true
docker run -d \
  --name mgr-router \
  --restart unless-stopped \
  --network mgr-net \
  -p 33461:6446 \
  -p 33471:6447 \
  --entrypoint /bin/sh \
  -v "$CONFIG_DIR:/mysqlrouter/conf" \
  -v mgr_router_data:/var/lib/mysqlrouter \
  "${ROUTER_IMAGE}" \
  -c "exec mysqlrouter -c /mysqlrouter/conf/mysqlrouter.conf"

# --- Step 3: Wait for listeners (use bash /dev/tcp; nc may not be installed) -
echo "   waiting for router R/W (33461) and R/O (33471)..."
ok_rw=0; ok_ro=0
for _ in $(seq 1 30); do
  if exec 3<>/dev/tcp/127.0.0.1/33461 2>/dev/null; then exec 3<&-; exec 3<&-; ok_rw=1; fi
  if exec 3<>/dev/tcp/127.0.0.1/33471 2>/dev/null; then exec 3<&-; exec 3<&-; ok_ro=1; fi
  [ "$ok_rw" = 1 ] && [ "$ok_ro" = 1 ] && break
  sleep 1
done
[ "$ok_rw" = 1 ] || { echo "ERROR: R/W listener 33461 not up"; exit 1; }
[ "$ok_ro" = 1 ] || { echo "ERROR: R/O listener 33471 not up"; exit 1; }
echo "   router up"