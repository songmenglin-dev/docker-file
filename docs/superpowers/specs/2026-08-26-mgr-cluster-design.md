# MySQL MGR Cluster on Docker — Design Spec

- **Date**: 2026-08-26
- **Target server**: `192.168.100.145` (Kylin Linux Advanced Server V10, 8 CPU / 6.5 GB RAM / 13 GB disk free)
- **Working directory (local)**: `/mnt/c/sml/project/agent_workspace/docker-file/mgr-docker-compose/`
- **Author**: Claude + user (brainstorming session)
- **Status**: Approved through 4 brainstorming sections

---

## 1. Goal & Constraints

Deploy a 3-node MySQL Group Replication (MGR) cluster plus a MySQL Router on the target server using Docker, with predictable bootstrap, single-primary failover, and zero external dependencies beyond Docker.

### Hard constraints (derived from the target server)

| Constraint | Source | Implication |
|---|---|---|
| 6.5 GB RAM total, 3.6 GB available | `free -h` | Each MySQL node capped at ~1 GB; default `innodb_buffer_pool_size=512M` |
| 8 CPU | `nproc` | 3 nodes + router → cap each at 2 CPU |
| 13 GB free disk | `df -h` | 3 × ~3 GB InnoDB data dirs leave headroom; `mysqldump` backups must be rotated externally |
| Native mysqld on host port 3306 | `ss -tlnp` | MGR clients must use a different host port range (33xx/133xx/334xx) |
| Docker 18.09.0, no `docker compose` v2 | `docker --version` | Deployment command is `docker-compose` (v1) — but `docker compose` syntax (v3 yaml) is compatible with both, so files are portable. Scripts shall auto-detect: prefer `docker compose`, fall back to `docker-compose`. |
| Kylin V10 (architecture verified by existing `mysql8-docker-compose` already running on this host) | `cat /etc/os-release` | `mysql:8.0` image works on this kernel; no architecture-specific tuning needed |

### Decisions made during brainstorming

| Decision | Value |
|---|---|
| Topology | 3 nodes, **single-primary** |
| MySQL version | `mysql:8.0` (latest 8.0.x stable) |
| Router | Yes — `mysql/mysql-router:8.0` |
| Initial accounts | `root` + `repl` (replication only); no application database |

---

## 2. Architecture & Components

### 2.1 File layout

```
mgr-docker-compose/
├── docker-compose.yml          # 3 mysql nodes + 1 router
├── .env                        # image tags, passwords, group UUID  (gitignored)
├── .env.example                # template with placeholder values
├── .gitignore
├── conf.d/
│   ├── my.cnf                  # common: charset, buffer pool, GTID, binlog
│   ├── replication.cnf         # !included; binlog_format/ROWS + server-id per node
│   └── group_replication.cnf   # !included; plugin, group_seeds, ip_allowlist
├── init/
│   ├── 01-bootstrap-node1.sh   # runs once: repl user + bootstrap group on node1
│   ├── 02-join-nodes.sh        # runs for node2 and node3: CHANGE MASTER + START GROUP_REPLICATION (retried)
│   └── 03-router-config.sh     # generate mysqlrouter.conf and restart router
├── scripts/
│   ├── bootstrap.sh            # entrypoint; idempotent
│   ├── status.sh               # show cluster topology
│   ├── failover-test.sh        # docker stop PRIMARY → measure R/W recovery
│   ├── verify-bootstrap.sh     # E2E smoke after bootstrap
│   ├── verify-replication.sh   # write probe + read all 3 nodes, 60 s run
│   ├── verify-router-rw-split.sh
│   ├── verify-consistency.sh
│   └── backup.sh               # mysqldump from PRIMARY to ./backups/
├── backups/                    # bind mount for dump files (host-side dir)
├── logs/                       # bind mount tail of mysql log dir
└── docs/
    └── RUNBOOK.md              # ops notes: failover, rebuild node, restore from backup
```

### 2.2 Services

| Service | Image | Host ports → container ports | Volume | Resource cap |
|---|---|---|---|---|
| `mgr-node1` | `mysql:8.0` | `33361 → 3306`, `13361 → 33061` | `mgr_node1_data` | mem 1.2 G / cpu 2 |
| `mgr-node2` | `mysql:8.0` | `33362 → 3306`, `13362 → 33061` | `mgr_node2_data` | mem 1.2 G / cpu 2 |
| `mgr-node3` | `mysql:8.0` | `33363 → 3306`, `13363 → 33061` | `mgr_node3_data` | mem 1.2 G / cpu 2 |
| `mgr-router` | `mysql/mysql-router:8.0` | `33461 → 6446` (R/W), `33471 → 6447` (R/O) | `mgr_router_conf` | mem 256 M / cpu 1 |

Port ranges chosen to avoid conflicts with native mysqld (3306/33060), the existing mysql8 docker (33306), and other services (6379/8000/8001/9000/9001/5000).

### 2.3 Network

- New bridge network `mgr-net`, subnet `172.20.0.0/16`.
- All 4 services join `mgr-net`; they resolve each other by service name (`mgr-node1`, etc.).
- `loose-group_replication_ip_allowlist` covers both the host subnet (`192.168.100.0/24`) and the docker subnet (`172.20.0.0/16`).

### 2.4 `my.cnf` key parameters (per node)

Common across all three (substituted by `docker-compose` env interpolation where needed):

```ini
[mysqld]
character-set-server     = utf8mb4
collation-server         = utf8mb4_unicode_ci
skip_name_resolve        = ON
max_connections          = 200
disabled_storage_engines = MyISAM,MEMORY
default_authentication_plugin = mysql_native_password

innodb_buffer_pool_size  = 512M
innodb_log_file_size     = 128M

server-id                = ${NODE_ID}        # 1/2/3 substituted per service
gtid_mode                = ON
enforce_gtid_consistency = ON
binlog_format            = ROW
log_bin                  = mysql-bin
binlog_checksum          = NONE
log_slave_updates        = ON
transaction_write_set_extraction = XXHASH64

loose-group_replication_group_name    = aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
loose-group_replication_start_on_boot = OFF
loose-group_replication_local_address = ${NODE_NAME}:33061
loose-group_replication_group_seeds   = "mgr-node1:33061,mgr-node2:33061,mgr-node3:33061"
loose-group_replication_ip_allowlist  = "192.168.100.0/24,172.20.0.0/16"
loose-group_replication_member_expel_timeout    = 5
loose-group_replication_autorejoin_tries        = 3
group_replication_consistency_mode              = EVENTUAL
```

> `start_on_boot=OFF` is critical: otherwise a container restart would attempt to rejoin before the user has confirmed the local GTID set is correct.

---

## 3. Data Flow & Bootstrap

### 3.1 Normal read/write flow

```
Application ──▶ mgr-router:33461 (R/W, mapped from container 6446) ──▶ PRIMARY node
              └─▶ mgr-router:33471 (R/O, mapped from 6447)          ──▶ any ONLINE SECONDARY
```

### 3.2 `bootstrap.sh` execution sequence

1. **Pre-flight**
   - `docker info` succeeds
   - `mgr-net` exists (create if missing with `docker network create`)
   - ports 33361/33362/33363/13361/13362/13363/33461/33471 free on host
2. **`docker-compose up -d mgr-node1`** and wait for healthcheck (`mysqladmin ping`, start_period 60 s).
3. **`init/01-bootstrap-node1.sh`** runs SQL inside node1:
   - `CREATE USER 'repl'@'%' IDENTIFIED BY '${REPL_PASSWORD}'`
   - `GRANT REPLICATION SLAVE, BACKUP_ADMIN ON *.* TO 'repl'@'%'`
   - `CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='${REPL_PASSWORD}' FOR CHANNEL 'group_replication_recovery'`
   - `SET GLOBAL group_replication_bootstrap_group=ON; START GROUP_REPLICATION; SET GLOBAL group_replication_bootstrap_group=OFF;`
   - Poll `performance_schema.replication_group_members` until node1 reports `MEMBER_STATE='ONLINE'`; fail if not within 60 s.
4. **`docker-compose up -d mgr-node2 mgr-node3`** and wait for healthcheck.
5. **`init/02-join-nodes.sh`** loops node2 then node3:
   - Same SQL as node1, but **without** `bootstrap_group=ON`.
   - Retry up to 3 times with 5 s sleep; exit non-zero on persistent failure.
6. **`verify-bootstrap.sh`** (auto-invoked): writes a probe row, reads it back from all three nodes within 5 s.
7. **`docker-compose up -d mgr-router`** with `--bootstrap` mode auto-discovered; if router config already exists from a prior run, use `--conf-path` instead and reload.
8. **`init/03-router-config.sh`** verifies R/W and R/O listeners are reachable on `127.0.0.1:6446` and `:6447`.
9. **Smoke**: a `mysql` CLI through `33461` writes to `mysql.mgr_smoke`, then reads through `33361/33362/33363` directly. Both must succeed.

`bootstrap.sh` is idempotent: if node1 already has `group_replication` running, skip steps 3-5 and only run step 7-9.

### 3.3 `.env` contract

```dotenv
MYSQL_IMAGE=mysql:8.0
ROUTER_IMAGE=mysql/mysql-router:8.0
TZ=Asia/Shanghai

# Strong passwords — bootstrap.sh aborts if MYSQL_ROOT_PASSWORD == REPL_PASSWORD
MYSQL_ROOT_PASSWORD=<chosen by user>
REPL_PASSWORD=<chosen by user>

# Group replication
MGR_GROUP_NAME=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
MGR_LOCAL_NET=192.168.100.0/24
MGR_DOCKER_NET=172.20.0.0/16

# Resource caps (single source of truth, applied in compose deploy.resources)
MYSQL_MEM_LIMIT=1200M
MYSQL_CPU_LIMIT=2.0
ROUTER_MEM_LIMIT=256M
ROUTER_CPU_LIMIT=1.0

# Bootstrap retunes
BOOTSTRAP_JOIN_RETRIES=3
BOOTSTRAP_JOIN_SLEEP_SECONDS=5
```

`.env.example` ships placeholder values and an inline warning that the file must be populated before `bootstrap.sh` will run.

---

## 4. Failure Handling & Recovery

### 4.1 Failure matrix

| Scenario | Automatic behavior | Application-visible | Operator action |
|---|---|---|---|
| Secondary restart / crash | Marked `UNREACHABLE`; cluster continues (still majority) | Brief R/O misses on the dead node | Inspect `docker logs` |
| PRIMARY crash | Built-in election picks new primary within ~30 s | R/W connection drops for ~30s, then resumes via router | Investigate the old primary's logs; restart with `docker start`; it rejoins as SECONDARY automatically |
| Network partition (split-brain risk) | Minority side flips to `super_read_only=ON` to refuse writes | Writes on minority are rejected | Fix network; minority nodes rejoin |
| node1 datadir corruption | `status.sh` shows `ERROR` / `UNREACHABLE` for node1 | Brief R/W outage during election | Rebuild node1 from a healthy secondary (see 4.3) |

### 4.2 Protection knobs in `my.cnf`

- `group_replication_consistency_mode = EVENTUAL` (single-primary default; avoids write-latency amplification from BEFORE/AFTER hooks)
- `group_replication_member_expel_timeout = 5` (default 0 is too aggressive against transient network blips)
- `group_replication_autorejoin_tries = 3` (node tries to rejoin 3 times with backoff before being expelled)
- `max_connections = 200` per node (600 total available to clients through router)

### 4.3 Node rebuild procedure

Documented in `docs/RUNBOOK.md`:

1. Stop the failed node: `docker compose stop <svc>`
2. Wipe the data volume: `docker compose rm -fv <svc>` (this removes the volume)
3. Start the node: `docker compose up -d <svc>` (waits for `mysqld` to initialize an empty datadir)
4. Run `init/02-join-nodes.sh <svc>` to bring it back into the group (the script detects "no group replication configured" and runs the join SQL)

### 4.4 Full reset

```bash
docker compose down -v   # removes containers AND named volumes
bash scripts/bootstrap.sh # rebuilds from scratch
```

### 4.5 Backups (`scripts/backup.sh`)

- Runs `mysqldump --all-databases --single-transaction --set-gtid-purged=ON --triggers --routines --events` against the **current PRIMARY** (queried via `performance_schema.replication_group_members`).
- Output: `./backups/mgr_YYYY-MM-DD_HHMMSS.sql.gz` (compressed on-host with `gzip`).
- v1 does not auto-rotate old backups. RUNBOOK documents a one-liner cron suggestion for the user.

---

## 5. Testing & Verification

### 5.1 Mandatory verification (run before any change ships)

| Script | What it verifies | Pass criterion |
|---|---|---|
| `verify-bootstrap.sh` | Fresh cluster is healthy right after `bootstrap.sh` | All 3 nodes `MEMBER_STATE=ONLINE`; router 6446 and 6447 reachable; smoke-write propagates to all nodes within 5 s |
| `verify-replication.sh` | Replication lag under continuous write load | For 60 s, write one row/sec with embedded server-id; read `latest_ts` from all 3 nodes; max delta ≤ 5 s |

### 5.2 Optional verification

| Script | Verifies |
|---|---|
| `failover-test.sh` | PRIMARY `docker stop`, observe router R/W recovery | Within 30 s router reconnects to a new PRIMARY; old container rejoins as SECONDARY after `docker start` |
| `verify-router-rw-split.sh` | Traffic separation | `33461` connections land on PRIMARY; `33471` connections land on a SECONDARY |
| `verify-consistency.sh` | GTID/ROW consistency | `FLUSH TABLES WITH READ LOCK` on PRIMARY while a SECONDARY reads shows pre-lock snapshot |

### 5.3 Container-level healthchecks

- mysql nodes: `mysqladmin ping -uroot -p${MYSQL_ROOT_PASSWORD} -h 127.0.0.1`, interval 10 s, retries 10, `start_period=60s` (group bootstrap can take 30-60 s)
- router: `nc -z 127.0.0.1 6446` and `nc -z 127.0.0.1 6447`, interval 15 s, retries 5

### 5.4 Out of scope for v1 (YAGNI)

- Application-level integration tests (no application code)
- Performance / load testing (6.5 GB RAM does not support meaningful benchmarks for MGR)
- Automated chaos testing (only the manual `failover-test.sh`)
- xtrabackup incremental backup chain (mysqldump full only)

---

## 6. Out of Scope / Risks

- **TLS between nodes** — v1 uses `caching_sha2_password` / `mysql_native_password` over plain TCP inside the bridge network. Production should add TLS; flagged as a follow-up.
- **MySQL Operator / orchestrator** — v1 uses plain docker; a Kubernetes operator is not on the table.
- **Cross-host deployment** — v1 is single-host by design. Stretching across hosts requires changing the `group_replication_ip_allowlist` and the bind mounts.
- **Disk pressure** — only 13 GB free. Three MGR nodes at default growth can fill this in months of heavy writes. RUNBOOK flags monitoring `df -h /` weekly.
- **Memory pressure** — three nodes at 512 MB buffer pool leaves ~1 GB for OS + native mysqld + gaussdb + minio + redis + router. Adding more services on this host will degrade MGR.

---

## 7. Open Questions

None at design time. (All decisions were resolved during brainstorming; any deviation discovered during implementation will trigger a spec amendment.)