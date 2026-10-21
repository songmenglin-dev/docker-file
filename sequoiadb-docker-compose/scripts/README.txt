scripts/
========

sequoiadb-docker-compose/scripts/ 下是 3 节点 SequoiaDB 集群的运维脚本集合。
本目录里所有脚本都是对 `docker exec` / `docker compose` / `mysql*` 的薄封装，
不直接管理容器生命周期。

下面按用途分组介绍每个脚本。

------------------------------------------------------------------------
1. 集群引导 — bootstrap.sh
------------------------------------------------------------------------

用途：一次性编排脚本，在三个 sdbserver{1,2,3} 容器已运行但还没建集群时，
      在它们内部创建出完整的 3 节点集群拓扑。

什么时候跑：每个集群只需要跑一次，由 sdb-init 容器在 docker compose up 时
            自动触发（通过 entrypoint）。日常运维中不会手动调用它。

做了什么（对应官方《集群模式部署》流程）：

  1. 等待三个节点上的 sdbcm（端口 11790）就绪。
  2. 用 Oma 连到 sdbserver1，在端口 29800 上创建一个**临时 coord**。
     注意端口不是 18800，因为 sdbcm 在空集群上会自动注册一个 18800 上的
     临时 coord，跟我们手动建的会冲突。
  3. 连上临时 coord，创建**catalog 副本组** SYSCatalogGroup，
     三个节点各一个（端口 11800）。
  4. 创建**数据副本组** group1，三个节点各一个（端口 11820）。
  5. 创建**coord 副本组** SYSCoordGroup，三个节点各一个（端口 11810）。
  6. 删除临时 coord。
  7. 写 /var/sdb-bootstrap/.done 文件，让三个数据节点的 entrypoint wrapper
     知道可以安全调用本机的 sdbstart -t all 来启动本地节点。

值得知道的坑：

  - createCataRG / createRG / createCoordRG 重跑时可能返回 -145 / -146
    （状态已存在）。脚本会捕获并视为"正常"——底层节点其实是被创建出来了。
    不要去"修复"这个错误处理。
  - 所有 createNode 调用都必须对 2 号、3 号节点传 {catalogaddr:
    "sdbserver1:11800"}，否则会返回 -180 "no catalog address specified"。
  - 脚本足够幂等，重新创建 sdb-init 容器在已有集群上跑是安全的。


------------------------------------------------------------------------
2. 操作员入口脚本
------------------------------------------------------------------------

四个脚本都把操作员（或者流水线数据）送进一个已运行的数据节点容器。
都接受节点名作为第一个位置参数，默认 sdbserver1。

  脚本                  落点                           是否交互
  ------------------   ---------------------------   ---------
  enter-bash.sh         容器里的 bash                  是（需要 TTY）
  enter-sdbshell.sh     本节点 coord 上的 sdb JS REPL  是（需要 TTY）
  sdb-shell.sh          同上（同名别名）                是（需要 TTY）
  sdb-exec.sh           sdb 批处理模式（一次性执行）    否

(1) enter-bash.sh — 打开 bash 会话
    用法：
        bash scripts/enter-bash.sh                # 默认进 sdbserver1
        bash scripts/enter-bash.sh sdbserver2     # 指定节点
    适用场景：OS 层操作，比如看 /opt/sequoiadb/database/coord/11810/log/
    下的日志、跑 sdbstart / sdbstop、改 conf 文件等。
    前置检查：白名单校验节点名（sdbserver1|2|3），确认 docker 在 PATH 里，
    拒绝进入 unhealthy 状态的容器；starting / none 状态允许进入（方便在
    bootstrap 过程中介入）。

(2) enter-sdbshell.sh — 打开交互式 sdb shell
    用法：
        bash scripts/enter-sdbshell.sh
    功能和 sdb-shell.sh 完全一样：运行 /opt/sequoiadb/bin/sdb，连到本节点
    的 coord（11810），coord 内部转发到 catalog / data 组。所以任一节点
    的 REPL 能做的事，其他节点的 REPL 也能做。
    命名约定：enter-* 系列是面向用户的清晰动词，sdb-shell.sh 是技术名 /
    原始名。两个都保留，按习惯选用。

(3) sdb-shell.sh — 同上的别名
    实现和 enter-sdbshell.sh 一致。保留是为了不破坏重命名之前已经在用
    sdb-shell.sh 这个名字的脚本和工作流。

(4) sdb-exec.sh — 非交互式执行 sdb 命令
    用法：
        # -c 一行命令
        bash scripts/sdb-exec.sh -c 'var db = new Sdb(); db.listReplicaGroups().forEach(printjson);'

        # -f 脚本文件
        bash scripts/sdb-exec.sh sdbserver2 -f ./maintenance.js

        # stdin 管道
        echo 'db.listCollectionSpaces()' | bash scripts/sdb-exec.sh

    适合放在脚本和 CI 里——输出可以直接管道传给 grep/jq 等。实现细节：
    sdb 不接受 -f /dev/stdin（会去 stat 这个伪设备），所以脚本会先把输入
    写到容器内的 /tmp/sdb-exec-$$.js（用主机 shell 的 PID 区分并发），
    跑完后 EXIT trap 会清理掉。


------------------------------------------------------------------------
3. 监控 — status.sh、verify.sh
------------------------------------------------------------------------

(1) status.sh — 完整的运维 dashboard（只读）
    用法：
        bash scripts/status.sh
    分五节输出，每节独立可跑，任何一节失败都不会影响其他节：

      1. 容器状态：所有 sdbserver* 和 sdb-init 的 docker ps，
         含 health 和 ports。
      2. 副本组拓扑：对 SYSCatalogGroup / group1 / SYSCoord 分别打印
         节点数和主节点（coord 组没有主节点，选的是 LSN，所以打印 n/a）。
      3. 跨节点 sdbcm 连通性：通过 alpine nc -z 探测 11790
         （在 docker 网络里）。
      4. 主机侧 coord 端口连通性：11811 / 11812 / 11813
         （端口从 .env 取，默认值）。
      5. SequoiaSQL-MySQL 网关：如果 sequoiasql-mysql 容器在跑，
         就探测 13306。

    设计上故意只 set -uo pipefail，不带 -e：单个检查挂了不影响
    整份报告。想看"现在整体状态怎么样"用这个。

(2) verify.sh — 通过/失败的烟测脚本
    用法：
        bash scripts/verify.sh
    五项硬检查，任何一项失败就 exit 1：

      1. 三个 sdbserver{1,2,3} 都是 healthy。
      2. 三个 sdbcm 端口在 docker 网络里都能连上。
      3. bootstrap 标记文件 /var/sdb-bootstrap/.done 存在。
      4. 集群拓扑正确：3 个组，每组 3 个节点（通过 sdb -f
         跑生成出来的 countNodes() 脚本来探测）。
      5. 三个主机侧 coord 端口都能连上。

    全过就打印 VERIFY: PASS — 3-node SequoiaDB cluster is healthy。
    适合用在 CI / 部署后钩子里；人要看 dashboard 用 status.sh。


------------------------------------------------------------------------
4. 网关（SequoiaSQL-MySQL）持久化
------------------------------------------------------------------------

sequoiasql-mysql:v5.0.1 镜像有个坑：MySQL 实例的注册信息存在容器的
overlay 文件系统里，不在 /opt/sequoiasql/mysql/database。所以朴素地把
data 目录 cp 来 cp 去，能恢复 SQL 对象，但下次启动时 entrypoint 会报
"instance MySQLInstance3306 does not exist"。

务实的做法是通过主机映射端口 13306 做**逻辑备份**（mysqldump / mysql <）。
本节三个脚本就是这个工作流。

(1) backup-catalog.sh — 导出 MySQL catalog
    用法：
        bash scripts/backup-catalog.sh                       # → ./sequoiasql-mysql-YYYYMMDD-HHMMSS.sql
        bash scripts/backup-catalog.sh /tmp/snapshot.sql     # 显式指定路径
    在主机侧跑 mysqldump --all-databases --single-transaction --routines
    --triggers --events --databases mysql appdb，连 127.0.0.1:13306。
    包含 mysql 库是为了 appuser 和它的 GRANT 在恢复后还在。

    **在以下操作之前一定要跑**：docker compose down、--force-recreate、
    虚拟机重启。
    失败时会打印 ✗ mysqldump failed (rc=N) 并删掉不完整的输出文件。
    环境变量覆盖：BACKUP_HOST / BACKUP_PORT / BACKUP_USER。

(2) restore-catalog.sh — 把 dump 回放进新建的网关
    用法：
        bash scripts/restore-catalog.sh /tmp/snapshot.sql
    等最多 60 秒让 MySQL 起来（mysqladmin ping），然后 mysql < $DUMP。
    用于 docker compose up -d 重建容器之后——data 目录是空的、
    MySQL 是 fresh-init 的。
    环境变量覆盖：RESTORE_HOST / RESTORE_PORT / RESTORE_USER。

(3) sequoiasql-mysql-persist.sh — 容器内的 entrypoint wrapper
    这个文件被挂进 sequoiasql-mysql 容器当作 entrypoint。**虽然名字带
    persist，但它现在是个空壳**——只是 exec /opt/docker-entrypoint.sh。
    原来的"SIGTERM 时把 data 目录拷进拷出"方案因为上面说的 overlay FS
    注册问题被废弃了；持久化完全由 backup-catalog / restore-catalog
    这对脚本承担。
    除非你重新设计持久化方案，否则不要动这个文件。


------------------------------------------------------------------------
快速参考
------------------------------------------------------------------------

  任务                                       脚本
  ----------------------------------------   ---------------------
  集群第一次启动                             （自动——sdb-init 跑 bootstrap.sh）
  在节点上开 bash                            enter-bash.sh
  开交互式 sdb REPL                          enter-sdbshell.sh（或 sdb-shell.sh）
  从脚本/CI 跑 sdb 命令                      sdb-exec.sh
  看完整集群状态                             status.sh
  CI / 部署后烟测                            verify.sh
  重建容器前快照网关                         backup-catalog.sh
  重建容器后回放快照                         restore-catalog.sh