# SequoiaDB 5.0.1 — 3-Node Distributed Cluster (Docker)

3-node SequoiaDB cluster with full replica groups (catalog / data / coord), running as 3 Docker containers on a single host.
Image: `sequoiadb/sequoiadb:v5.0.1` (official Docker Hub).
Cluster topology follows the official `安装部署/集群模式部署.md` procedure verbatim.

## Topology

| Role | Replica group | Nodes | Port |
|---|---|---|---|
| Catalog | `SYSCatalogGroup` | sdbserver1, sdbserver2, sdbserver3 | 11800 |
| Data    | `group1`         | sdbserver1, sdbserver2, sdbserver3 | 11820 |
| Coord   | `SYSCoordGroup`  | sdbserver1, sdbserver2, sdbserver3 | 11810 |
| sdbcm   | (daemon)         | sdbserver1, sdbserver2, sdbserver3 | 11790 |
| STP     | (server)         | sdbserver1, sdbserver2, sdbserver3 | 9622  |

Any single node can fail and the cluster stays available (3-replica, majority quorum).

## Quick start

```bash
cp .env.example .env
docker compose up -d           # first boot: ~60s; init creates the topology
bash scripts/verify.sh         # smoke test (all 3 nodes + topology)
bash scripts/status.sh         # show topology + reachability
```

To **tear down and wipe**:
```bash
docker compose down -v         # removes containers AND the 3 data volumes
```

## Endpoints (after first boot)

Client connects to the coord group. To survive a single node failure, use all three host ports in a connection pool:

| Coord node | Host:Port |
|---|---|
| sdbserver1 | `<host>:11811` |
| sdbserver2 | `<host>:11812` |
| sdbserver3 | `<host>:11813` |

Container-internal (not exposed on host): catalog 11800, data 11820, sdbcm 11790, STP 9622.

## Connection from outside

```bash
# Single-node client (will fail if that node is down):
docker run --rm --network sequoiadb-docker-compose_sequoiadb-net \
  sequoiadb/sequoiadb:v5.0.1 /opt/sequoiadb/bin/sdb \
  -e 'var db = new Sdb("sdbserver1", 11810); db.listCollectionSpaces().forEach(printjson);'

# From the host (any coord port):
docker exec sdbserver1 /opt/sequoiadb/bin/sdb -e 'var db = new Sdb("sdbserver1", 11810); db.listCollectionSpaces().forEach(printjson);'
```

## How the bootstrap works

1. **`sdbserver{1,2,3}`** start `sdbcm` (port 11790) only. Their wrappers wait for the init marker.
2. **`sdb-init`** waits for all 3 `sdbcm` ports, then runs `scripts/bootstrap.sh` which executes the official cluster bootstrap JS:
   - Create temporary coord at `sdbserver1:18800`
   - `db.createCataRG` + 3 `cataRG.createNode` (one per host) → start
   - `db.createRG("group1")` + 3 `createNode` → start
   - `db.createCoordRG` + 3 `createNode` → start
   - `oma.removeCoord(18800)`
3. Init writes `/var/sdb-bootstrap/.done` on the shared volume.
4. Each per-node wrapper sees the marker and runs `sdbstart -t all` to start its local nodes.

On restart, init is idempotent (skips groups that already exist) and `sdbcm` auto-starts registered nodes (per official `集群启停.md`).

## Persistence

| Volume | Container path | Holds |
|---|---|---|
| `sdb1_data` | sdbserver1:/opt/sequoiadb/database | coord/catalog/data for node 1 |
| `sdb2_data` | sdbserver2:/opt/sequoiadb/database | coord/catalog/data for node 2 |
| `sdb3_data` | sdbserver3:/opt/sequoiadb/database | coord/catalog/data for node 3 |
| `sdb_bootstrap` | all:/var/sdb-bootstrap | init marker (small, ephemeral) |

Wipe everything: `docker compose down -v`.

## Files

| File | Purpose |
|---|---|
| `docker-compose.yml` | 3 nodes + init container, shared network, shared bootstrap volume |
| `conf/entrypoint-wrapper.sh` | Per-node: start sdbcm → wait for marker → start local nodes → sleep |
| `scripts/bootstrap.sh` | Init container: official JS bootstrap procedure |
| `scripts/verify.sh` | Smoke test: all 3 containers healthy, 3 groups with 3 nodes each, ports reachable |
| `scripts/status.sh` | Topology dump + reachability matrix |
| `.env.example` | TZ, resource caps (1.2 GB / 1.5 CPU per node), host port mappings |
| `v3.4/` | Local copy of the official v3.4 docs (source of truth for this design) |
| `.archive/standalone-1node/` | Previous single-host deployment (kept for rollback reference) |

## Known caveats

- Default `sdb` account has no password (per official image). Set a password via `db.updateUser()` before exposing publicly.
- 6.5 GB RAM host with 3 × 1.2 GB = 3.6 GB cap leaves ~2.9 GB for the host + other services.
- Docker image is v5.0.1; local docs are v3.4. The bootstrap JS APIs used (Oma / createCataRG / createNode / createRG / createCoordRG / removeCoord) are stable across 3.x / 5.x.
- This is a single-host deployment of a distributed cluster. It exercises the cluster topology and replica logic, but is NOT a real multi-host HA deployment. For true cross-host HA, run one container per physical host and let them form a cluster over the real network.
