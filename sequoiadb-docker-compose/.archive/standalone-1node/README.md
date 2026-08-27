# SequoiaDB 5.0.1 Standalone (Docker)

Single-node SequoiaDB cluster (coord + catalog + data + stp), all in one container.
Image: `sequoiadb/sequoiadb:v5.0.1` (official Docker Hub).

- **Spec/plan reference**: this directory is the deliverable; design decisions were made ad-hoc with the user
- **Image**: `sequoiadb/sequoiadb:v5.0.1`

## Quick start

```bash
cp .env.example .env       # placeholder, no passwords to set
docker compose up -d       # first boot triggers SDB_DEPLOY; takes ~30-60s
bash scripts/verify.sh     # smoke test
bash scripts/status.sh     # show topology
```

## Endpoints (after first boot)

| Purpose | Host:Port |
|---|---|
| Coord (client/SQL access) | `<host>:11810` |
| Catalog | `<host>:11800` |
| Data group1 | `<host>:11820` |
| STP server | (inside container on port 9622) |

## Connection from inside the cluster

```bash
docker exec sequoiadb /opt/sequoiadb/bin/sdb -e 'var db = new Sdb("localhost", 11810); db.listCollectionSpaces().forEach(printjson);'
```

## Persistence

Named volume `sequoiadb_data` mounted at `/opt/sequoiadb/database` — survives container restarts.
To wipe: `docker compose down -v`.

## Known caveats

- Default `sdb` account has no password (per official image). Set a password via `db.updateUser()` before exposing publicly.
- 6.5 GB RAM host with 1.5 GB cap leaves little room for additional services — monitor with `docker stats`.
- Image entrypoint triggers `SDB_DEPLOY=1` on first boot only; subsequent restarts reuse the existing cluster.