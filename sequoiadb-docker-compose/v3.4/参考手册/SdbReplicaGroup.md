---
title: SdbReplicaGroup
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190865-edition_id-304
---

SdbReplicaGroup 类主要用于操作复制组和获取复制组相关的信息，包含的函数如下：

名称 | 描述  
---|---  
[attachNode()](/cn/sequoiadb-cat_id-1432190866-edition_id-304) | 将不属于任何复制组的节点加入当前复制组  
[createNode()](/cn/sequoiadb-cat_id-1432190867-edition_id-304) | 在当前复制组中创建节点  
[detachNode()](/cn/sequoiadb-cat_id-1432190868-edition_id-304) | 分离当前复制组内的一个节点  
[getDetailObj()](/cn/sequoiadb-cat_id-1601192934-edition_id-304) | 获取复制组的信息  
[getMaster()](/cn/sequoiadb-cat_id-1432190870-edition_id-304) | 获取当前复制组的主节点  
[getNode()](/cn/sequoiadb-cat_id-1432190871-edition_id-304) | 获取当前复制组的指定节点  
[getSlave()](/cn/sequoiadb-cat_id-1432190872-edition_id-304) | 获取当前复制组的备节点  
[reelect()](/cn/sequoiadb-cat_id-1432190873-edition_id-304) | 在当前复制组中重新选举  
[removeNode()](/cn/sequoiadb-cat_id-1432190874-edition_id-304) | 删除当前复制组中的指定节点  
[start()](/cn/sequoiadb-cat_id-1432190875-edition_id-304) | 启动当前复制组  
[stop()](/cn/sequoiadb-cat_id-1432190876-edition_id-304) | 停止当前复制组
