# Redis 7.2 (Docker, Single Instance)

Remote-accessible single Redis instance, no auth, deployed via docker-compose.

## Quick start

```bash
cd redis-docker-compose
docker-compose up -d
docker-compose ps
docker exec -it redis redis-cli ping   # → PONG
```

## Endpoints

| Purpose | Host:Port |
|---|---|
| Redis (any host on the LAN) | `<host>:6379` |

## Security notes

- `bind 0.0.0.0` + `protected-mode no` + **no password** — fine for trusted LAN
  / internal test environments. **Do NOT expose port 6379 to the public
  internet** without adding `requirepass` (and ideally firewall rules / VPC).
- Container runs as the unprivileged `redis` user (uid 999) baked into the
  `redis:7.2-alpine` image. The host `logs/` and named volume `redis_data`
  are owned by root that the user can write to — no manual chmod required.

## Tuning

- **Memory cap**: edit `maxmemory` in `conf/redis.conf` (default `256mb`).
- **Eviction policy**: `maxmemory-policy allkeys-lru` — drop any key under
  memory pressure. Swap to `volatile-lru` to only evict keys with TTL.
- **Durability**: flip `appendonly` to `yes` to enable AOF (`everysec`
  fsync is the production sweet spot).