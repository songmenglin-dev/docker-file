# MGR Cluster — Operations Runbook

## Day-to-day

| Task | Command |
|---|---|
| View topology | `bash scripts/status.sh` |
| Quick health  | `bash scripts/verify-bootstrap.sh` |
| Replication lag | `bash scripts/verify-replication.sh` (60 s) |
| Full backup   | `bash scripts/backup.sh` |

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
# Pipe into the current PRIMARY
PRIMARY=$(bash -c 'cd /opt/mgr-docker-compose && source .env && docker exec mgr-node1 mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -N -B -e "SELECT MEMBER_HOST FROM performance_schema.replication_group_members WHERE MEMBER_ROLE=\"PRIMARY\""')
docker exec -i $PRIMARY mysql -uroot -p"$MYSQL_ROOT_PASSWORD" < backups/mgr_*.sql
```

After restore, the group re-syncs other nodes via standard replication.

## Backup rotation (one-time cron)

```cron
# /etc/cron.d/mgr-backup - runs daily at 03:15; keeps last 7
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