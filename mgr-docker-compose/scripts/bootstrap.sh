#!/usr/bin/env bash
# Idempotent cluster bootstrap.
# Usage: bash scripts/bootstrap.sh
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$HERE"

# --- Detect compose CLI -------------------------------------------------------
if docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE=(docker-compose)
else
  echo "ERROR: neither 'docker compose' nor 'docker-compose' is available" >&2
  exit 2
fi

# --- Pre-flight ---------------------------------------------------------------
[ -f .env ] || { echo "ERROR: .env missing - copy .env.example and edit passwords" >&2; exit 2; }

# shellcheck disable=SC1091
set -a; . ./.env; set +a

[ -n "${MYSQL_ROOT_PASSWORD:-}" ] && [ -n "${REPL_PASSWORD:-}" ] || {
  echo "ERROR: MYSQL_ROOT_PASSWORD and REPL_PASSWORD must be set" >&2; exit 2; }
[ "$MYSQL_ROOT_PASSWORD" != "$REPL_PASSWORD" ] || {
  echo "ERROR: MYSQL_ROOT_PASSWORD and REPL_PASSWORD must differ" >&2; exit 2; }

echo ">> [1/5] Pre-flight: docker + network + ports + config file modes"
docker info >/dev/null
docker network inspect mgr-net >/dev/null 2>&1 \
  || docker network create --driver bridge --subnet 172.20.0.0/16 mgr-net >/dev/null

# MySQL refuses to load world-writable config files. rsync from WSL/NTFS
# mounts may strip POSIX perms and leave files as 0777; force them to 0644.
chmod 755 conf.d
chmod 644 conf.d/*.cnf

declare -a NEED_PORTS=(33361 33362 33363 13361 13362 13363 33461 33471)
for p in "${NEED_PORTS[@]}"; do
  if ss -ltnH 2>/dev/null | awk '{print $4}' | grep -qE "[:.]$p\$"; then
    echo "ERROR: host port $p already in use" >&2; exit 3
  fi
done

# --- Bring up node1 -----------------------------------------------------------
echo ">> [2/5] Starting mgr-node1"
"${COMPOSE[@]}" up -d mgr-node1
echo "   waiting for mgr-node1 healthcheck..."
status=""
for _ in $(seq 1 60); do
  status=$(docker inspect --format '{{.State.Health.Status}}' mgr-node1 2>/dev/null || echo starting)
  [ "$status" = healthy ] && break
  sleep 2
done
[ "$status" = healthy ] || { echo "ERROR: mgr-node1 did not become healthy in 120s" >&2; exit 4; }

# --- Initialize node1 (group bootstrap) --------------------------------------
echo ">> [3/5] Bootstrap group on mgr-node1"
bash init/01-bootstrap-node1.sh

# --- Bring up node2/node3 + join ---------------------------------------------
echo ">> [4/5] Starting mgr-node2 + mgr-node3 and joining group"
"${COMPOSE[@]}" up -d mgr-node2 mgr-node3
echo "   waiting for mgr-node2/3 healthcheck..."
for svc in mgr-node2 mgr-node3; do
  s=""
  for _ in $(seq 1 60); do
    s=$(docker inspect --format '{{.State.Health.Status}}' "$svc" 2>/dev/null || echo starting)
    [ "$s" = healthy ] && break
    sleep 2
  done
  [ "$s" = healthy ] || { echo "ERROR: $svc did not become healthy" >&2; exit 5; }
done
bash init/02-join-nodes.sh

# --- Router -------------------------------------------------------------------
echo ">> [5/5] Configure and start mgr-router"
bash init/03-router-config.sh

# --- Verify -------------------------------------------------------------------
echo ""
echo ">> Verification"
bash scripts/verify-bootstrap.sh

echo ""
echo "MGR cluster is up. Endpoints:"
echo "  R/W (write): $(hostname):33461"
echo "  R/O (read) : $(hostname):33471"
echo "  Direct     : 33361 / 33362 / 33363 (node1/2/3)"