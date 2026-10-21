# PostgreSQL 16 (Docker, Single Instance)

Remote-accessible single PostgreSQL 16 instance, no auth, deployed via docker-compose.

## Quick start

```bash
cd pgsql-docker-compose
docker-compose up -d
docker-compose ps
docker exec -it pgsql psql -U postgres -d appdb -c 'SELECT version();'
```

## Endpoints

| Purpose | Host:Port |
|---|---|
| PostgreSQL (any host on the LAN) | `<host>:5432` |
| Default user | `postgres` |
| Default database | `appdb` |

## Security notes

- `listen_addresses = '*'` + `pg_hba.conf` with `trust` for `0.0.0.0/0` =
  **no password required from anywhere**. Fine for trusted LAN / internal
  test environments. **Do NOT expose port 5432 to the public internet**
  without switching to `scram-sha-256` (and setting a real password via
  `POSTGRES_PASSWORD`).
- Container runs as the unprivileged `postgres` user (uid 999) baked into
  the `postgres:16-alpine` image. The host `logs/` and the named volume
  `pgsql_data` are owned correctly by the image's docker-entrypoint — no
  manual chmod required.

## Tuning

- **Memory cap**: edit `shared_buffers` / `effective_cache_size` /
  `work_mem` / `maintenance_work_mem` in `conf/postgresql.conf`.
- **Connection cap**: `max_connections = 200`. Bump if you have many clients.
- **Slow-query log**: `log_min_duration_statement = 1000` (ms). Set to `0`
  to log everything in dev, or `5000` to only catch the 5+ second queries.
- **Storage**: tune `random_page_cost` if you're not on SSD.