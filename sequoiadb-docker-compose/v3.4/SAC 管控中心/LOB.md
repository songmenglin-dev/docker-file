---
title: LOB
category: SAC 管控中心
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1483944513-edition_id-304
---

1. 已存在集合 sample.employee 

  2. 使用 coord 节点的主机，运行 SDB Shell 
         
         $ /opt/sequoiadb/bin/sdb

  3. 连接协调节点
         
         > db = new Sdb( "localhost", 11810 )

  4. 导入 Lob
         
         > db.sample.employee.putLob( '/opt/pic.jpg' )

输出 Lob 的 OID：
         
         5878b0add9d765d278000000

  5. 导入完成
