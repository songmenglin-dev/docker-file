# MySQL MGR Cluster (Docker, Single-Primary)

3-node MySQL Group Replication + MySQL Router, deployed via docker-compose.

- **Spec:** `docs/superpowers/specs/2026-08-26-mgr-cluster-design.md`
- **Plan:** `docs/superpowers/plans/2026-08-26-mgr-cluster.md`

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

See `docs/RUNBOOK.md` for failover, rebuild, backup, and restore procedures.