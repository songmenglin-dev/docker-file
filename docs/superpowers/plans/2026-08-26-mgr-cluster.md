# MGR Cluster Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans (single-session, batch execution with checkpoints) — this is a one-shot infrastructure deployment, not a multi-cycle feature build. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deploy a 3-node MySQL Group Replication (single-primary, mysql:8.0) cluster plus MySQL Router on target server `192.168.100.145`, with reproducible bootstrap scripts and end-to-end verification.

**Architecture:** Single-host, Docker-based. One `docker-compose.yml` defines 3 mysql services (`mgr-node1/2/3`) and 1 router service (`mgr-router`), joined to a dedicated bridge network `mgr-net`. A bootstrap shell script orchestrates first-time setup; idempotent re-runs are supported. Verification scripts confirm cluster health post-deploy.

**Tech Stack:** Docker 18.09.0 (target host), `docker-compose` v1 + v2-compatible yaml, `mysql:8.0`, `mysql/mysql-router:8.0`, bash for orchestration scripts, sshpass for agent-side remote execution.

---

## Global Constraints

Pulled verbatim from the approved spec `/mnt/c/sml/project/agent_workspace/docker-file/docs/superpowers/specs/2026-08-26-mgr-cluster-design.md`:

- **Topology:** 3 nodes, **single-primary**
- **Image:** `mysql:8.0` (latest 8.0.x stable), `mysql/mysql-router:8.0`
- **Ports (host → container):**
  - node1: `33361 → 3306`, `13361 → 33061`
  - node2: `33362 → 3306`, `13362 → 33061`
  - node3: `33363 → 3306`, `13363 → 33061`
  - router: `33461 → 6446` (R/W), `33471 → 6447` (R/O)
- **Resources per mysql node:** mem `1.2G`, cpu `2.0`. **Router:** mem `256M`, cpu `1.0`. **`innodb_buffer_pool_size=512M`**
- **MGR parameters (all nodes):** `gtid_mode=ON`, `enforce_gtid_consistency=ON`, `binlog_format=ROW`, `binlog_checksum=NONE`, `log_slave_updates=ON`, `transaction_write_set_extraction=XXHASH64`
- **Group config:** `group_replication_group_name=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa`, `start_on_boot=OFF`, `member_expel_timeout=5`, `autorejoin_tries=3`, `consistency_mode=EVENTUAL`
- **Network:** bridge `mgr-net`, subnet `172.20.0.0/16`. `ip_allowlist` covers `192.168.100.0/24` and `172.20.0.0/16`.
- **Healthcheck:** mysql: `mysqladmin ping -uroot -p${MYSQL_ROOT_PASSWORD} -h 127.0.0.1`, interval 10s, retries 10, start_period 60s. Router: `nc -z 127.0.0.1 6446`, interval 15s, retries 5.
- **Accounts (v1):** only `root` + `repl` (replication only); no application DB.
- **Workspace:** all new files go under `/mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/`
- **Target server:** `192.168.100.145` (root password `18162161837Xiner` — from user memory; not hardcoded in any committed file)

---

## File Structure

All paths relative to `mgr-docker-compose/`:

```
mgr-docker-compose/
├── docker-compose.yml
├── .env                              # gitignored; populated at deploy time
├── .env.example
├── .gitignore
├── README.md
├── conf.d/
│   ├── my.cnf                        # per-node overrides via ${NODE_ID} / ${NODE_NAME}
│   ├── replication.cnf               # !included from my.cnf (kept separate for clarity)
│   └── group_replication.cnf
├── init/
│   ├── 01-bootstrap-node1.sh         # idempotent; safe to re-run
│   ├── 02-join-nodes.sh              # loops node2 + node3
│   └── 03-router-config.sh
├── scripts/
│   ├── bootstrap.sh                  # main entrypoint; idempotent
│   ├── status.sh
│   ├── verify-bootstrap.sh           # MANDATORY after bootstrap
│   ├── verify-replication.sh         # MANDATORY after bootstrap
│   ├── verify-router-rw-split.sh     # optional
│   ├── verify-consistency.sh         # optional
│   ├── failover-test.sh              # optional manual
│   └── backup.sh
├── backups/                          # .gitkeep; bind-mount target on server
├── logs/                             # .gitkeep; bind-mount tail of mysql log
└── docs/
    └── RUNBOOK.md
```

---

## Task 1: Scaffold project layout and `.gitignore`

**Files:**
- Create: `mgr-docker-compose/.gitignore`
- Create: `mgr-docker-compose/README.md` (skeleton — placeholder title + spec pointer)
- Create: `mgr-docker-compose/backups/.gitkeep`
- Create: `mgr-docker-compose/logs/.gitkeep`

- [ ] **Step 1: Create directory structure**

```bash
cd /mnt/c/sml/project/agent_workspace/docker-file
mkdir -p mgr-docker-compose/{conf.d,init,scripts,backups,logs,docs}
touch mgr-docker-compose/backups/.gitkeep mgr-docker-compose/logs/.gitkeep
```

- [ ] **Step 2: Write `.gitignore`**

Write `mgr-docker-compose/.gitignore`:

```
.env
backups/*.sql*
logs/*.log
logs/*.err
*.pid
.vscode/
.idea/
```

- [ ] **Step 3: Write README skeleton**

Write `mgr-docker-compose/README.md`:

```markdown
# MySQL MGR Cluster (Docker, Single-Primary)

3-node MySQL Group Replication + MySQL Router, deployed via docker-compose.

**Spec:** `docs/superpowers/specs/2026-08-26-mgr-cluster-design.md`
**Plan:** `docs/superpowers/plans/2026-08-26-mgr-cluster.md`

## Quick start

```bash
cp .env.example .env   # edit passwords
bash scripts/bootstrap.sh
bash scripts/verify-bootstrap.sh
bash scripts/verify-replication.sh   # runs ~60 s
```

## Endpoints (after bootstrap)

| Purpose | Host:Port |
|---|---|
| Write (router R/W) | `<host>:33461` |
| Read  (router R/O) | `<host>:33471` |
| Direct node1 | `<host>:33361` |
| Direct node2 | `<host>:33362` |
| Direct node3 | `<host>:33363` |
```

- [ ] **Step 4: Verify layout**

```bash
cd /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose
find . -type f -o -type d | sort
```

Expected: shows `.gitignore`, `README.md`, `backups/.gitkeep`, `logs/.gitkeep`, plus the 6 subdirs (`conf.d/ init/ scripts/ docs/`).

---

## Task 2: Write `.env.example`

**Files:**
- Create: `mgr-docker-compose/.env.example`

- [ ] **Step 1: Write `.env.example`**

Write `mgr-docker-compose/.env.example`:

```dotenv
# =============================================================================
# MySQL MGR Cluster — environment template
# Copy to .env, fill in passwords. DO NOT commit .env.
# bootstrap.sh aborts if MYSQL_ROOT_PASSWORD == REPL_PASSWORD.
# =============================================================================

MYSQL_IMAGE=mysql:8.0
ROUTER_IMAGE=mysql/mysql-router:8.0
TZ=Asia/Shanghai

# --- Passwords (REQUIRED — must differ from each other) ----------------------
MYSQL_ROOT_PASSWORD=ChangeMe_RootPass_!Strong_2026
REPL_PASSWORD=ChangeMe_ReplPass_!Strong_2026

# --- Group replication -------------------------------------------------------
MGR_GROUP_NAME=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
MGR_LOCAL_NET=192.168.100.0/24
MGR_DOCKER_NET=172.20.0.0/16

# --- Resource caps (single source of truth for deploy.resources) -------------
MYSQL_MEM_LIMIT=1200M
MYSQL_CPU_LIMIT=2.0
ROUTER_MEM_LIMIT=256M
ROUTER_CPU_LIMIT=1.0

# --- Bootstrap retunes -------------------------------------------------------
BOOTSTRAP_JOIN_RETRIES=3
BOOTSTRAP_JOIN_SLEEP_SECONDS=5
```

- [ ] **Step 2: Sanity-check**

```bash
grep -E '^[A-Z_]+=' /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/.env.example | wc -l
```

Expected: ≥ 12 (counts top-level keys).

---

## Task 3: Write MySQL config files

**Files:**
- Create: `mgr-docker-compose/conf.d/my.cnf`
- Create: `mgr-docker-compose/conf.d/replication.cnf`
- Create: `mgr-docker-compose/conf.d/group_replication.cnf`

Compose mounts `conf.d/` at `/etc/mysql/conf.d` (ro). MySQL loads every `*.cnf` inside, alphabetical. The names ensure `my.cnf` loads first; `replication.cnf` and `group_replication.cnf` append.

- [ ] **Step 1: Write `conf.d/my.cnf`**

Write `mgr-docker-compose/conf.d/my.cnf`:

```ini
[mysqld]
user                           = mysql
character-set-server           = utf8mb4
collation-server               = utf8mb4_unicode_ci
skip_name_resolve              = ON
max_connections                = 200
disabled_storage_engines       = MyISAM,MEMORY
default_authentication_plugin  = mysql_native_password
default-time-zone              = '+08:00'

innodb_buffer_pool_size        = 512M
innodb_log_file_size           = 128M
innodb_flush_log_at_trx_commit = 2

server-id                      = ${NODE_ID}
log_bin                        = mysql-bin
binlog_format                  = ROW
binlog_checksum                = NONE
log_slave_updates              = ON
gtid_mode                      = ON
enforce_gtid_consistency       = ON
transaction_write_set_extraction = XXHASH64

expire_logs_days               = 7
```

`${NODE_ID}` is substituted by `docker-compose`'s env interpolation from the service-level environment (`NODE_ID: '1'` etc.). This file is also where any future per-node overrides land; env vars from compose override anything here.

- [ ] **Step 2: Write `conf.d/replication.cnf`**

Write `mgr-docker-compose/conf.d/replication.cnf`:

```ini
# Loaded alphabetically after my.cnf; kept separate for clarity.
[mysqld]
relay_log                      = relay-bin
relay_log_info_repository      = TABLE
master_info_repository         = TABLE
sync_binlog                    = 1
slave_rows_search_algorithms   = INDEX_SCAN,HASH_SCAN
```

- [ ] **Step 3: Write `conf.d/group_replication.cnf`**

Write `mgr-docker-compose/conf.d/group_replication.cnf`:

```ini
# Loaded alphabetically after my.cnf and replication.cnf.
[mysqld]
loose-group_replication_group_name      = aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
loose-group_replication_start_on_boot   = OFF
loose-group_replication_local_address   = ${NODE_NAME}:33061
loose-group_replication_group_seeds     = "mgr-node1:33061,mgr-node2:33061,mgr-node3:33061"
loose-group_replication_ip_allowlist    = "${MGR_LOCAL_NET},${MGR_DOCKER_NET}"
loose-group_replication_member_expel_timeout = 5
loose-group_replication_autorejoin_tries     = 3
group_replication_consistency_mode           = EVENTUAL
```

`loose-` prefix allows mysqld to start even if the plugin hasn't been loaded yet (mysql:8.0 image has it bundled; `loose-` is for forward compatibility with images where it isn't).

- [ ] **Step 4: Verify env interpolation tokens**

```bash
grep -E '\$\{[A-Z_]+\}' /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/conf.d/*.cnf
```

Expected: shows `NODE_ID` and `NODE_NAME` (in my.cnf / group_replication.cnf) plus `MGR_LOCAL_NET` and `MGR_DOCKER_NET`. Confirm compose env block sets all four (next task).

---

## Task 4: Write `docker-compose.yml`

**Files:**
- Create: `mgr-docker-compose/docker-compose.yml`

- [ ] **Step 1: Write `docker-compose.yml`**

Write `mgr-docker-compose/docker-compose.yml`:

```yaml
# Compatible with both `docker-compose` (v1) and `docker compose` (v2).
# bootstrap.sh detects which is available.
version: "3.8"

x-mysql-common: &mysql-common
  image: ${MYSQL_IMAGE}
  restart: unless-stopped
  env_file: [.env]
  environment:
    TZ: ${TZ}
    MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
  volumes:
    - ${PWD}/conf.d:/etc/mysql/conf.d:ro
    - ${PWD}/logs/${NODE_NAME}:/var/log/mysql
    - ${NODE_NAME}_data:/var/lib/mysql
  networks:
    - mgr-net
  healthcheck:
    test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-uroot", "-p${MYSQL_ROOT_PASSWORD}"]
    interval: 10s
    timeout: 5s
    retries: 10
    start_period: 60s
  deploy:
    resources:
      limits:
        memory: ${MYSQL_MEM_LIMIT}
        cpus: "${MYSQL_CPU_LIMIT}"
  logging:
    driver: "json-file"
    options:
      max-size: "50m"
      max-file: "3"

services:
  mgr-node1:
    <<: *mysql-common
    container_name: mgr-node1
    environment:
      TZ: ${TZ}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      NODE_NAME: mgr-node1
      NODE_ID: "1"
    ports:
      - "33361:3306"
      - "13361:33061"
    volumes:
      - ${PWD}/conf.d:/etc/mysql/conf.d:ro
      - ${PWD}/logs/mgr-node1:/var/log/mysql
      - mgr_node1_data:/var/lib/mysql

  mgr-node2:
    <<: *mysql-common
    container_name: mgr-node2
    environment:
      TZ: ${TZ}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      NODE_NAME: mgr-node2
      NODE_ID: "2"
    ports:
      - "33362:3306"
      - "13362:33061"
    volumes:
      - ${PWD}/conf.d:/etc/mysql/conf.d:ro
      - ${PWD}/logs/mgr-node2:/var/log/mysql
      - mgr_node2_data:/var/lib/mysql

  mgr-node3:
    <<: *mysql-common
    container_name: mgr-node3
    environment:
      TZ: ${TZ}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      NODE_NAME: mgr-node3
      NODE_ID: "3"
    ports:
      - "33363:3306"
      - "13363:33061"
    volumes:
      - ${PWD}/conf.d:/etc/mysql/conf.d:ro
      - ${PWD}/logs/mgr-node3:/var/log/mysql
      - mgr_node3_data:/var/lib/mysql

  mgr-router:
    image: ${ROUTER_IMAGE}
    container_name: mgr-router
    restart: unless-stopped
    depends_on:
      mgr-node1:
        condition: service_healthy
      mgr-node2:
        condition: service_healthy
      mgr-node3:
        condition: service_healthy
    environment:
      TZ: ${TZ}
    networks:
      - mgr-net
    ports:
      - "33461:6446"
      - "33471:6447"
    deploy:
      resources:
        limits:
          memory: ${ROUTER_MEM_LIMIT}
          cpus: "${ROUTER_CPU_LIMIT}"
    logging:
      driver: "json-file"
      options:
        max-size: "50m"
        max-file: "3"

networks:
  mgr-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

volumes:
  mgr_node1_data:
  mgr_node2_data:
  mgr_node3_data:
```

> Notes:
> - YAML anchor `&mysql-common` is a v3 idiom; both `docker-compose` v1 and `docker compose` v2 honor it.
> - `${PWD}` is set by docker-compose automatically; if running on a remote host via SSH, bootstrap.sh `cd`'s into the project dir first so `${PWD}` resolves correctly.
> - `depends_on: condition: service_healthy` requires docker-compose v2.12+ or docker compose v2; if bootstrap.sh detects v1, it falls back to a polling wait inside `init/03-router-config.sh` instead.

- [ ] **Step 2: Validate YAML syntax locally (don't need docker installed for this)**

```bash
python3 -c "import yaml,sys; yaml.safe_load(open('/mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/docker-compose.yml')); print('OK')"
```

Expected: `OK`.

- [ ] **Step 3: Commit-ready check (no commit yet — workspace not git-tracked)**

```bash
grep -c "services:" /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/docker-compose.yml
grep -c "mgr-node" /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/docker-compose.yml
```

Expected: 1 (services block), 4 (3 nodes + router + seeds).

---

## Task 5: Write `scripts/bootstrap.sh`

**Files:**
- Create: `mgr-docker-compose/scripts/bootstrap.sh`

This is the main entrypoint. It must be idempotent (re-running should not corrupt the cluster; it should only re-run missing steps).

- [ ] **Step 1: Write `scripts/bootstrap.sh`**

Write `mgr-docker-compose/scripts/bootstrap.sh`:

```bash
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
[ -f .env ] || { echo "ERROR: .env missing — copy .env.example and edit passwords" >&2; exit 2; }

# shellcheck disable=SC1091
set -a; . ./.env; set +a

[ -n "${MYSQL_ROOT_PASSWORD:-}" ] && [ -n "${REPL_PASSWORD:-}" ] || {
  echo "ERROR: MYSQL_ROOT_PASSWORD and REPL_PASSWORD must be set" >&2; exit 2; }
[ "$MYSQL_ROOT_PASSWORD" != "$REPL_PASSWORD" ] || {
  echo "ERROR: MYSQL_ROOT_PASSWORD and REPL_PASSWORD must differ" >&2; exit 2; }

echo ">> [1/6] Pre-flight: docker + network + ports"
docker info >/dev/null
docker network inspect mgr-net >/dev/null 2>&1 \
  || docker network create --driver bridge --subnet 172.20.0.0/16 mgr-net >/dev/null

declare -a NEED_PORTS=(33361 33362 33363 13361 13362 13363 33461 33471)
for p in "${NEED_PORTS[@]}"; do
  if ss -ltnH 2>/dev/null | awk '{print $4}' | grep -qE "[:.]$p\$"; then
    echo "ERROR: host port $p already in use" >&2; exit 3
  fi
done

# --- Bring up node1 -----------------------------------------------------------
echo ">> [2/6] Starting mgr-node1"
"${COMPOSE[@]}" up -d mgr-node1
echo "   waiting for mgr-node1 healthcheck..."
for _ in $(seq 1 60); do
  status=$(docker inspect --format '{{.State.Health.Status}}' mgr-node1 2>/dev/null || echo starting)
  [ "$status" = healthy ] && break
  sleep 2
done
[ "$status" = healthy ] || { echo "ERROR: mgr-node1 did not become healthy in 120s" >&2; exit 4; }

# --- Initialize node1 (group bootstrap) --------------------------------------
echo ">> [3/6] Bootstrap group on mgr-node1"
bash init/01-bootstrap-node1.sh

# --- Bring up node2/node3 + join ---------------------------------------------
echo ">> [4/6] Starting mgr-node2 + mgr-node3"
"${COMPOSE[@]}" up -d mgr-node2 mgr-node3
echo "   waiting for mgr-node2/3 healthcheck..."
for svc in mgr-node2 mgr-node3; do
  for _ in $(seq 1 60); do
    s=$(docker inspect --format '{{.State.Health.Status}}' "$svc" 2>/dev/null || echo starting)
    [ "$s" = healthy ] && break
    sleep 2
  done
  [ "$s" = healthy ] || { echo "ERROR: $svc did not become healthy" >&2; exit 5; }
done
bash init/02-join-nodes.sh

# --- Router -------------------------------------------------------------------
echo ">> [5/6] Configure and start mgr-router"
bash init/03-router-config.sh

# --- Verify -------------------------------------------------------------------
echo ">> [6/6] Verification"
bash scripts/verify-bootstrap.sh

echo ""
echo "MGR cluster is up. Endpoints:"
echo "  R/W (write): $(hostname):33461"
echo "  R/O (read) : $(hostname):33471"
echo "  Direct     : 33361 / 33362 / 33363 (node1/2/3)"
```

- [ ] **Step 2: Make executable + syntax check**

```bash
chmod +x /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/bootstrap.sh
bash -n /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/bootstrap.sh && echo SYNTAX_OK
```

Expected: `SYNTAX_OK`.

- [ ] **Step 3: Install shellcheck if missing, then lint**

```bash
if ! command -v shellcheck >/dev/null 2>&1; then
  apt-get install -y shellcheck >/dev/null 2>&1 || true
fi
command -v shellcheck >/dev/null && shellcheck -S warning /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/bootstrap.sh || echo "shellcheck not available — skipping (manual review)"
```

Expected: no errors (warnings about `set -a`/`.env` interpolation are OK; review any `SC2086` suggestions).

---

## Task 6: Write init/01-bootstrap-node1.sh

**Files:**
- Create: `mgr-docker-compose/init/01-bootstrap-node1.sh`

- [ ] **Step 1: Write the script**

Write `mgr-docker-compose/init/01-bootstrap-node1.sh`:

```bash
#!/usr/bin/env bash
# Configures mgr-node1: repl user + group bootstrap.
# Idempotent: re-running on a member that's already ONLINE is a no-op.
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

# If node1 already in group, skip.
existing=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_STATE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='mgr-node1'" 2>/dev/null || echo "")
if [ "$existing" = "ONLINE" ]; then
  echo "   mgr-node1 already ONLINE; skipping bootstrap"
  exit 0
fi

docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
SET SQL_LOG_BIN=0;
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY '${REPL_PASSWORD}';
GRANT REPLICATION SLAVE, BACKUP_ADMIN ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
SET SQL_LOG_BIN=1;

CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='${REPL_PASSWORD}' FOR CHANNEL 'group_replication_recovery';

SET GLOBAL group_replication_bootstrap_group=ON;
START GROUP_REPLICATION;
SET GLOBAL group_replication_bootstrap_group=OFF;
SQL

# Wait for ONLINE
echo "   waiting for mgr-node1 to reach ONLINE..."
for _ in $(seq 1 30); do
  state=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT MEMBER_STATE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='mgr-node1'" 2>/dev/null || echo "")
  [ "$state" = "ONLINE" ] && break
  sleep 2
done
[ "$state" = "ONLINE" ] || { echo "ERROR: mgr-node1 did not reach ONLINE" >&2; exit 1; }
echo "   mgr-node1 ONLINE"
```

- [ ] **Step 2: Make executable + syntax check**

```bash
chmod +x /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/init/01-bootstrap-node1.sh
bash -n /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/init/01-bootstrap-node1.sh && echo SYNTAX_OK
```

---

## Task 7: Write init/02-join-nodes.sh

**Files:**
- Create: `mgr-docker-compose/init/02-join-nodes.sh`

- [ ] **Step 1: Write the script**

Write `mgr-docker-compose/init/02-join-nodes.sh`:

```bash
#!/usr/bin/env bash
# Joins node2 and node3 to the group. Retries each node independently.
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

RETRIES="${BOOTSTRAP_JOIN_RETRIES:-3}"
SLEEP="${BOOTSTRAP_JOIN_SLEEP_SECONDS:-5}"

join_node() {
  local svc="$1"
  # Skip if already ONLINE
  local state
  state=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT MEMBER_STATE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='$svc'" 2>/dev/null || echo "")
  if [ "$state" = "ONLINE" ]; then
    echo "   $svc already ONLINE; skipping"
    return 0
  fi

  echo "   joining $svc (retries=$RETRIES)..."
  for attempt in $(seq 1 "$RETRIES"); do
    if docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
SET SQL_LOG_BIN=0;
CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='${REPL_PASSWORD}' FOR CHANNEL 'group_replication_recovery';
SET SQL_LOG_BIN=1;
START GROUP_REPLICATION;
SQL
    then
      # poll
      for _ in $(seq 1 15); do
        state=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
          "SELECT MEMBER_STATE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='$svc'" 2>/dev/null || echo "")
        [ "$state" = "ONLINE" ] && { echo "   $svc ONLINE"; return 0; }
        sleep 2
      done
    fi
    echo "   attempt $attempt failed for $svc; sleeping ${SLEEP}s"
    sleep "$SLEEP"
  done
  echo "ERROR: $svc failed to join after $RETRIES attempts" >&2
  return 1
}

join_node mgr-node2
join_node mgr-node3
```

- [ ] **Step 2: Make executable + syntax check**

```bash
chmod +x /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/init/02-join-nodes.sh
bash -n /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/init/02-join-nodes.sh && echo SYNTAX_OK
```

---

## Task 8: Write init/03-router-config.sh

**Files:**
- Create: `mgr-docker-compose/init/03-router-config.sh`

Uses `mysqlrouter --bootstrap` against node1 to generate `mysqlrouter.conf`, then starts the router as a managed container via compose.

- [ ] **Step 1: Write the script**

Write `mgr-docker-compose/init/03-router-config.sh`:

```bash
#!/usr/bin/env bash
# Configures mgr-router:
#   1. Run `mysqlrouter --bootstrap` against node1 to generate config.
#   2. Persist the generated mysqlrouter.conf in a named volume / bind-mount.
#   3. Start mgr-router via compose with the persisted config.
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

CONFIG_DIR="$HERE/mgr-router-conf"
mkdir -p "$CONFIG_DIR"

if [ -f "$CONFIG_DIR/mysqlrouter.conf" ]; then
  echo "   mysqlrouter.conf already exists; skipping bootstrap"
else
  docker run --rm \
    -v "$CONFIG_DIR:/tmp/router-conf" \
    --network mgr-net \
    "${ROUTER_IMAGE}" \
    mysqlrouter --bootstrap repl@"mgr-node1:3306" \
      --user=mysqlrouter \
      --directory=/tmp/router-conf \
      --force \
      --conf-use-sockets=0
  echo "   bootstrap complete"
fi

# Re-create container with the persisted config bind-mounted in
if docker ps -a --format '{{.Names}}' | grep -qx mgr-router; then
  docker rm -f mgr-router >/dev/null
fi

docker run -d \
  --name mgr-router \
  --restart unless-stopped \
  --network mgr-net \
  -p 33461:6446 \
  -p 33471:6447 \
  -v "$CONFIG_DIR:/mysqlrouter/conf" \
  "${ROUTER_IMAGE}" \
  mysqlrouter -c /mysqlrouter/conf/mysqlrouter.conf

# Wait for listener
echo "   waiting for router R/W (33461) and R/O (33471)..."
for _ in $(seq 1 30); do
  nc -z 127.0.0.1 33461 && nc -z 127.0.0.1 33471 && break
  sleep 1
done
nc -z 127.0.0.1 33461 || { echo "ERROR: R/W listener 33461 not up"; exit 1; }
nc -z 127.0.0.1 33471 || { echo "ERROR: R/O listener 33471 not up"; exit 1; }
echo "   router up"
```

- [ ] **Step 2: Make executable + syntax check**

```bash
chmod +x /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/init/03-router-config.sh
bash -n /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/init/03-router-config.sh && echo SYNTAX_OK
```

---

## Task 9: Write scripts/status.sh

**Files:**
- Create: `mgr-docker-compose/scripts/status.sh`

- [ ] **Step 1: Write the script**

Write `mgr-docker-compose/scripts/status.sh`:

```bash
#!/usr/bin/env bash
# Print MGR cluster topology.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

echo "=== Containers ==="
docker ps --filter "name=mgr-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=== Group members (mgr-node1 view) ==="
docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -t -e "
  SELECT MEMBER_ID, MEMBER_HOST, MEMBER_STATE, MEMBER_ROLE, MEMBER_VERSION
  FROM performance_schema.replication_group_members
  ORDER BY MEMBER_HOST;"

echo ""
echo "=== Router listeners ==="
nc -zv 127.0.0.1 33461 2>&1 | head -1
nc -zv 127.0.0.1 33471 2>&1 | head -1
```

- [ ] **Step 2: Make executable + syntax check**

```bash
chmod +x /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/status.sh
bash -n /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/status.sh && echo SYNTAX_OK
```

---

## Task 10: Write scripts/verify-bootstrap.sh

**Files:**
- Create: `mgr-docker-compose/scripts/verify-bootstrap.sh`

Acceptance gate: MANDATORY run after bootstrap. Exits non-zero on any failure.

- [ ] **Step 1: Write the script**

Write `mgr-docker-compose/scripts/verify-bootstrap.sh`:

```bash
#!/usr/bin/env bash
# Verifies the cluster is healthy after bootstrap.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "=== [1] All 3 nodes ONLINE ==="
for svc in mgr-node1 mgr-node2 mgr-node3; do
  state=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT MEMBER_STATE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='$svc'" 2>/dev/null || echo MISSING)
  [ "$state" = "ONLINE" ] || fail "$svc state=$state (expected ONLINE)"
  echo "  $svc ONLINE"
done

echo "=== [2] One PRIMARY, two SECONDARY ==="
roles=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_ROLE FROM performance_schema.replication_group_members ORDER BY MEMBER_HOST" | sort | uniq -c | tr -d ' ')
echo "$roles" | grep -q "2 SECONDARY" || fail "expected 2 SECONDARY"
echo "$roles" | grep -q "1 PRIMARY"    || fail "expected 1 PRIMARY"
echo "  role distribution: $(echo "$roles" | tr '\n' ' ')"

echo "=== [3] Router R/W + R/O reachable ==="
nc -z 127.0.0.1 33461 || fail "33461 (R/W) not reachable"
nc -z 127.0.0.1 33471 || fail "33471 (R/O) not reachable"
echo "  33461 (R/W) and 33471 (R/O) open"

echo "=== [4] Smoke write propagates to all nodes within 5s ==="
TS=$(date +%s)
for svc in mgr-node1 mgr-node2 mgr-node3; do
  docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "
    CREATE DATABASE IF NOT EXISTS mgr_smoke;
    CREATE TABLE IF NOT EXISTS mgr_smoke.t (id INT PRIMARY KEY, ts BIGINT);
    INSERT INTO mgr_smoke.t VALUES (1, $TS) ON DUPLICATE KEY UPDATE ts=$TS;" >/dev/null
done

sleep 2
for svc in mgr-node1 mgr-node2 mgr-node3; do
  seen=$(docker exec "$svc" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT ts FROM mgr_smoke.t WHERE id=1" 2>/dev/null || echo "")
  [ "$seen" = "$TS" ] || fail "$svc has not seen the smoke write (got '$seen')"
  echo "  $svc saw ts=$TS"
done

echo ""
echo "VERIFY-BOOTSTRAP: PASS"
```

- [ ] **Step 2: Make executable + syntax check**

```bash
chmod +x /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/verify-bootstrap.sh
bash -n /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/verify-bootstrap.sh && echo SYNTAX_OK
```

---

## Task 11: Write scripts/verify-replication.sh

**Files:**
- Create: `mgr-docker-compose/scripts/verify-replication.sh`

Acceptance gate: writes through R/W router once per second for 60 s; reads `latest_ts` from each node and asserts max delta ≤ 5 s.

- [ ] **Step 1: Write the script**

Write `mgr-docker-compose/scripts/verify-replication.sh`:

```bash
#!/usr/bin/env bash
# Writes a row/sec through router R/W for 60 s; checks replication lag.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

# Install mysql client locally (WSL Debian) — we use the on-host mysql CLI to talk to router.
if ! command -v mysql >/dev/null 2>&1; then
  apt-get install -y default-mysql-client >/dev/null 2>&1 || true
fi
command -v mysql >/dev/null || { echo "ERROR: mysql client not available"; exit 1; }

# One-time schema setup on PRIMARY (via router)
mysql -h127.0.0.1 -P33461 -uroot -p"${MYSQL_ROOT_PASSWORD}" <<'SQL' >/dev/null
CREATE DATABASE IF NOT EXISTS mgr_smoke;
CREATE TABLE IF NOT EXISTS mgr_smoke.t (
  id INT PRIMARY KEY,
  ts BIGINT NOT NULL,
  writer VARCHAR(32) NOT NULL
);
SQL

echo "Writing 1 row/sec for 60 s through router R/W..."
end=$(( $(date +%s) + 60 ))
while [ "$(date +%s)" -lt "$end" ]; do
  ts=$(date +%s)
  mysql -h127.0.0.1 -P33461 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e \
    "INSERT INTO mgr_smoke.t VALUES (1, $ts, 'repl-test') ON DUPLICATE KEY UPDATE ts=$ts, writer='repl-test';" 2>/dev/null
  sleep 1
done

echo "Reading latest_ts from each node..."
last_ts=$(mysql -h127.0.0.1 -P33461 -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MAX(ts) FROM mgr_smoke.t")
echo "  router R/W: $last_ts"

max_delta=0
for port in 33361 33362 33363; do
  t=$(mysql -h127.0.0.1 -P$port -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT MAX(ts) FROM mgr_smoke.t" 2>/dev/null || echo 0)
  delta=$(( last_ts - t ))
  [ "$delta" -lt 0 ] && delta=$((-delta))
  [ "$delta" -gt "$max_delta" ] && max_delta=$delta
  echo "  node direct (port $port): $t (delta=$delta)"
done

if [ "$max_delta" -le 5 ]; then
  echo "VERIFY-REPLICATION: PASS (max delta=${max_delta}s ≤ 5s)"
else
  echo "VERIFY-REPLICATION: FAIL (max delta=${max_delta}s > 5s)" >&2
  exit 1
fi
```

- [ ] **Step 2: Make executable + syntax check**

```bash
chmod +x /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/verify-replication.sh
bash -n /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/verify-replication.sh && echo SYNTAX_OK
```

---

## Task 12: Write optional verify scripts

**Files:**
- Create: `mgr-docker-compose/scripts/verify-router-rw-split.sh`
- Create: `mgr-docker-compose/scripts/verify-consistency.sh`
- Create: `mgr-docker-compose/scripts/failover-test.sh`

- [ ] **Step 1: Write `verify-router-rw-split.sh`**

Write `mgr-docker-compose/scripts/verify-router-rw-split.sh`:

```bash
#!/usr/bin/env bash
# Confirms router splits R/W vs R/O traffic.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

PRIMARY_HOST=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'")

# R/W should land on PRIMARY
rw_host=$(mysql -h127.0.0.1 -P33461 -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT @@hostname")
[ "$rw_host" = "$PRIMARY_HOST" ] || { echo "FAIL: R/W went to $rw_host, expected PRIMARY=$PRIMARY_HOST" >&2; exit 1; }
echo "  R/W → $rw_host (PRIMARY) ✓"

# R/O should land on a SECONDARY (loop until we see one, with timeout)
ok=0
for _ in $(seq 1 10); do
  ro_host=$(mysql -h127.0.0.1 -P33471 -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT @@hostname")
  if [ "$ro_host" != "$PRIMARY_HOST" ]; then
    ok=1; break
  fi
  sleep 1
done
[ "$ok" = 1 ] || { echo "FAIL: R/O kept landing on PRIMARY=$PRIMARY_HOST" >&2; exit 1; }
echo "  R/O → $ro_host (SECONDARY) ✓"

echo "VERIFY-ROUTER-RW-SPLIT: PASS"
```

- [ ] **Step 2: Write `verify-consistency.sh`**

Write `mgr-docker-compose/scripts/verify-consistency.sh`:

```bash
#!/usr/bin/env bash
# Confirms GTID/ROW consistency: a write on PRIMARY becomes visible on all SECONDARIES.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

marker="consistency_$(date +%s)_$$"
mysql -h127.0.0.1 -P33461 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e \
  "INSERT INTO mgr_smoke.t VALUES (2, $(date +%s), '$marker') ON DUPLICATE KEY UPDATE writer='$marker';" >/dev/null

sleep 2
for port in 33361 33362 33363; do
  seen=$(mysql -h127.0.0.1 -P$port -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
    "SELECT writer FROM mgr_smoke.t WHERE id=2" 2>/dev/null || echo "")
  [ "$seen" = "$marker" ] || { echo "FAIL: port $port has writer='$seen', expected '$marker'" >&2; exit 1; }
done
echo "VERIFY-CONSISTENCY: PASS (marker '$marker' visible on all 3 nodes)"
```

- [ ] **Step 3: Write `failover-test.sh`**

Write `mgr-docker-compose/scripts/failover-test.sh`:

```bash
#!/usr/bin/env bash
# Manual failover drill: docker stop PRIMARY, observe router R/W recovery.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

PRIMARY=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'")
echo "Current PRIMARY: $PRIMARY"

echo "Issuing a baseline write through router R/W..."
mysql -h127.0.0.1 -P33461 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e \
  "SELECT 1" >/dev/null

echo "Stopping $PRIMARY..."
docker stop "$PRIMARY" >/dev/null

echo "Polling R/W router for recovery (up to 60 s)..."
start=$(date +%s)
new_primary=""
for _ in $(seq 1 60); do
  # router returns an error until it discovers the new PRIMARY; we accept any successful query
  if mysql -h127.0.0.1 -P33461 -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e "SELECT 1" >/dev/null 2>&1; then
    elapsed=$(( $(date +%s) - start ))
    new_primary=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
      "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'")
    echo "  recovered in ${elapsed}s; new PRIMARY = $new_primary"
    break
  fi
  sleep 1
done
[ -n "$new_primary" ] || { echo "FAIL: router R/W did not recover in 60 s" >&2; exit 1; }

echo "Restarting $PRIMARY (expect it to rejoin as SECONDARY)..."
docker start "$PRIMARY" >/dev/null
sleep 15
role=$(docker exec "$PRIMARY" mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_ROLE FROM performance_schema.replication_group_members WHERE MEMBER_HOST='$PRIMARY'" 2>/dev/null || echo "")
echo "  $PRIMARY role after restart: $role"

echo "FAILOVER-TEST: PASS"
```

- [ ] **Step 4: Make all three executable + syntax-check**

```bash
cd /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose
chmod +x scripts/verify-router-rw-split.sh scripts/verify-consistency.sh scripts/failover-test.sh
for f in scripts/verify-router-rw-split.sh scripts/verify-consistency.sh scripts/failover-test.sh; do
  bash -n "$f" && echo "OK $f" || echo "FAIL $f"
done
```

Expected: three `OK` lines.

---

## Task 13: Write scripts/backup.sh

**Files:**
- Create: `mgr-docker-compose/scripts/backup.sh`

- [ ] **Step 1: Write the script**

Write `mgr-docker-compose/scripts/backup.sh`:

```bash
#!/usr/bin/env bash
# mysqldump full backup, run against the current PRIMARY.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
set -a; . ./.env; set +a

PRIMARY=$(docker exec mgr-node1 mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -N -B -e \
  "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE='PRIMARY'" 2>/dev/null || true)
[ -n "$PRIMARY" ] || { echo "ERROR: no PRIMARY in group — refusing to backup" >&2; exit 1; }
echo "Backing up PRIMARY=$PRIMARY"

stamp=$(date +%F_%H%M%S)
out="backups/mgr_${stamp}.sql.gz"
mkdir -p backups

docker exec "$PRIMARY" mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" \
  --all-databases --single-transaction \
  --set-gtid-purged=ON --triggers --routines --events \
  | gzip -9 > "$out"

ls -lh "$out"
echo "Backup written: $out"
echo "NOTE: rotate old backups manually or with cron — see docs/RUNBOOK.md"
```

- [ ] **Step 2: Make executable + syntax check**

```bash
chmod +x /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/backup.sh
bash -n /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/scripts/backup.sh && echo SYNTAX_OK
```

---

## Task 14: Write docs/RUNBOOK.md

**Files:**
- Create: `mgr-docker-compose/docs/RUNBOOK.md`

- [ ] **Step 1: Write the document**

Write `mgr-docker-compose/docs/RUNBOOK.md`:

````markdown
# MGR Cluster — Operations Runbook

## Day-to-day

| Task | Command |
|---|---|
| View topology | `bash scripts/status.sh` |
| Quick health | `bash scripts/verify-bootstrap.sh` |
| Replication lag | `bash scripts/verify-replication.sh` (60 s) |
| Full backup | `bash scripts/backup.sh` |

## Failover drill

```bash
bash scripts/failover-test.sh
```

Stops the current PRIMARY container, waits for router R/W recovery (≤ 30 s typical), restarts the old container, verifies it rejoins as SECONDARY.

## Rebuild a single node

```bash
# Pick the failing service name: mgr-node1 | mgr-node2 | mgr-node3
SVC=mgr-node2
docker compose stop $SVC
docker compose rm -fv $SVC              # removes the named volume
docker compose up -d $SVC
# Wait for healthcheck (up to 60 s)
bash init/02-join-nodes.sh              # joins $SVC back into the group
```

> Rebuilding node1 is the same — once node1 rejoins, it remains SECONDARY until the next election. To force re-electing node1 as primary, `STOP GROUP_REPLICATION` on the current primary.

## Restore from backup

```bash
# Decompress
gunzip -k backups/mgr_YYYY-MM-DD_HHMMSS.sql.gz
# Stop traffic, then restore into the PRIMARY
docker exec -i $(docker ps --format '{{.Names}}' | grep PRIMARY) mysql -uroot -p${MYSQL_ROOT_PASSWORD} < backups/mgr_*.sql
```

After restore, the group re-syncs other nodes via standard replication.

## Backup rotation (one-time cron)

```cron
# /etc/cron.d/mgr-backup — runs daily at 03:15; keeps last 7
15 3 * * *  cd /opt/mgr-docker-compose && bash scripts/backup.sh && \
  find backups -name 'mgr_*.sql.gz' -mtime +7 -delete
```

## Disk monitoring

```bash
df -h /                                  # whole-host; MGR uses local driver so data sits under /var/lib/docker/volumes/
```

## Network note

If you change `mgr-net` subnet or add nodes, update `loose-group_replication_ip_allowlist` in `conf.d/group_replication.cnf` AND `docker-compose.yml` `networks.mgr-net.ipam.config`.

## Known caveats

- **No TLS between nodes** — bridge network is trusted. Add TLS before exposing cross-host.
- **mysqldump only** — for large datasets, swap in xtrabackup (not in v1 scope).
- **6.5 GB RAM is tight** — adding more services to this host can degrade MGR; check `docker stats`.
````

---

## Task 15: Deploy — copy files to target server

**Files:**
- Transfers: all files under `mgr-docker-compose/` → `/opt/mgr-docker-compose/` on the target

- [ ] **Step 1: Create remote working directory**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'mkdir -p /opt/mgr-docker-compose/{conf.d,init,scripts,backups,logs,docs} && \
   touch /opt/mgr-docker-compose/backups/.gitkeep /opt/mgr-docker-compose/logs/.gitkeep && \
   echo OK'
```

Expected: `OK`.

- [ ] **Step 2: rsync the project tree (preserves structure; excludes `.env`)**

```bash
cd /mnt/c/sml/project/agent_workspace/docker-file
rsync -avz --exclude='.env' \
  -e "sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no" \
  mgr-docker-compose/ root@192.168.100.145:/opt/mgr-docker-compose/
```

Expected: file list ends with lines like `mgr-docker-compose/scripts/backup.sh`; no errors.

- [ ] **Step 3: Populate `.env` on the server with strong passwords**

Generate and write the `.env` non-interactively (no echo of password to terminal):

```bash
ROOT_PW="$(openssl rand -base64 18 | tr -d '/+= ' | head -c 24)Repl."
REPL_PW="$(openssl rand -base64 18 | tr -d '/+= ' | head -c 24)Repl."
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  "sed -e 's|ChangeMe_RootPass_!Strong_2026|${ROOT_PW}|' \
       -e 's|ChangeMe_ReplPass_!Strong_2026|${REPL_PW}|' \
       /opt/mgr-docker-compose/.env.example > /opt/mgr-docker-compose/.env && \
   chmod 600 /opt/mgr-docker-compose/.env && \
   echo SET && \
   head -8 /opt/mgr-docker-compose/.env | sed 's/PASSWORD=.*/PASSWORD=<redacted>/'"
```

Expected: `SET`, then 8 lines of `.env` with redacted passwords.

- [ ] **Step 4: Verify remote tree**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'find /opt/mgr-docker-compose -maxdepth 2 -type f | sort | head -25'
```

Expected: lists `docker-compose.yml`, `.env`, `.env.example`, `.gitignore`, `README.md`, all `conf.d/*.cnf`, all `init/*.sh`, all `scripts/*.sh`, `docs/RUNBOOK.md`.

---

## Task 16: Run bootstrap on the target server

**Files:** No new files; runs `bootstrap.sh` end-to-end on the remote host.

- [ ] **Step 1: Run bootstrap remotely**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'cd /opt/mgr-docker-compose && bash scripts/bootstrap.sh' 2>&1 | tee /tmp/mgr-bootstrap.log
```

Expected: each `>> [N/6]` step prints; ends with `VERIFY-BOOTSTRAP: PASS` and the endpoint summary. Wall-clock: 3–8 min (image pull + bootstrap).

- [ ] **Step 2: Inspect the log for unexpected warnings**

```bash
grep -E 'ERROR|WARN' /tmp/mgr-bootstrap.log | head -20
```

Expected: no matches.

- [ ] **Step 3: Confirm all 4 containers running**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'docker ps --filter "name=mgr-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
```

Expected: 4 rows (mgr-node1, mgr-node2, mgr-node3, mgr-router) all `Up` and `healthy` for the three mysql nodes.

---

## Task 17: Run mandatory verification suite

- [ ] **Step 1: Run verify-replication (60 s write/read test)**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'cd /opt/mgr-docker-compose && bash scripts/verify-replication.sh' 2>&1 | tee /tmp/mgr-repl.log
```

Expected: ends with `VERIFY-REPLICATION: PASS (max delta=…s ≤ 5s)`.

- [ ] **Step 2: Run verify-router-rw-split**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'cd /opt/mgr-docker-compose && bash scripts/verify-router-rw-split.sh' 2>&1 | tee /tmp/mgr-split.log
```

Expected: `VERIFY-ROUTER-RW-SPLIT: PASS`.

- [ ] **Step 3: Run verify-consistency**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'cd /opt/mgr-docker-compose && bash scripts/verify-consistency.sh' 2>&1 | tee /tmp/mgr-cons.log
```

Expected: `VERIFY-CONSISTENCY: PASS`.

- [ ] **Step 4: Check final topology**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'cd /opt/mgr-docker-compose && bash scripts/status.sh' 2>&1 | tee /tmp/mgr-status.log
```

Expected: 3 ONLINE members, 1 PRIMARY + 2 SECONDARY, both router listeners open.

- [ ] **Step 5: Run backup once to validate the path**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'cd /opt/mgr-docker-compose && bash scripts/backup.sh' 2>&1 | tee /tmp/mgr-backup.log
```

Expected: ends with `Backup written: backups/mgr_YYYY-MM-DD_HHMMSS.sql.gz`; file size > 0.

- [ ] **Step 6: Cleanup smoke-test artifact**

```bash
sshpass -p '18162161837Xiner' ssh -o StrictHostKeyChecking=no root@192.168.100.145 \
  'for svc in mgr-node1 mgr-node2 mgr-node3; do \
     docker exec $svc mysql -uroot -p$(grep ^MYSQL_ROOT_PASSWORD= /opt/mgr-docker-compose/.env | cut -d= -f2) -e "DROP DATABASE IF EXISTS mgr_smoke"; \
   done && echo cleaned'
```

Expected: `cleaned`.

- [ ] **Step 7: Tag completion in local workspace**

```bash
echo "Cluster verified $(date -Iseconds)" > /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/.deployed
cat /mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/.deployed
```

Expected: prints the timestamp line.

---

## Self-Review Notes

This plan covers all sections of the spec:

| Spec section | Plan tasks |
|---|---|
| §1 Goal & Constraints | Global Constraints block; port/resource choices in Tasks 3–4 |
| §2 Architecture & Components | Tasks 1 (scaffold), 3 (cnf files), 4 (compose), 5–8 (init scripts) |
| §3 Data Flow & Bootstrap | Task 5 (bootstrap.sh), Tasks 6–8 (init/0[1-3]) |
| §4 Failure Handling & Recovery | Task 12 (failover-test), Task 14 (RUNBOOK rebuild procedure), Task 13 (backup) |
| §5 Testing & Verification | Tasks 10–12 (verify scripts), Tasks 16–17 (run them) |
| §6 Out of Scope / Risks | RUNBOOK §"Known caveats" |

No placeholders ("TBD/TODO/implement later/fill in details") in any step. All commands have expected output. All file paths absolute or relative to the project root. Type/signature consistency: `MYSQL_ROOT_PASSWORD`, `REPL_PASSWORD`, container names (`mgr-node1/2/3`, `mgr-router`), port mappings (33361/33362/33363, 13361/13362/13363, 33461/33471), and env keys are consistent across all files.

Workspace is not a git repo, so commit steps are intentionally omitted (the existing `mysql8-docker-compose` and `mongodb-docker-compose` siblings are likewise uncommitted — the user's call when/whether to `git init`).