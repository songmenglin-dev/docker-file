---
title: SdbCollection
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190824-edition_id-304
---

SdbCollection 类主要用于操作集合，包含的函数如下：

名称 | 描述  
---|---  
[aggregate()](/cn/sequoiadb-cat_id-1432190825-edition_id-304) | 计算集合中数据的聚合值  
[alter()](/cn/sequoiadb-cat_id-1432190826-edition_id-304) | 修改集合的属性  
[attachCL()](/cn/sequoiadb-cat_id-1432190827-edition_id-304) | 挂载子分区集合  
[count()](/cn/sequoiadb-cat_id-1432190828-edition_id-304) | 统计当前集合符合条件的记录总数  
[createAutoIncrement()](/cn/sequoiadb-cat_id-1541039122-edition_id-304) | 创建自增字段  
[createIdIndex()](/cn/sequoiadb-cat_id-1432190829-edition_id-304) | 创建 $id 索引  
[createIndex()](/cn/sequoiadb-cat_id-1432190830-edition_id-304) | 创建索引  
[createLobID()](/cn/sequoiadb-cat_id-1563882538-edition_id-304) | 创建大对象 ID  
[deleteLob()](/cn/sequoiadb-cat_id-1432190831-edition_id-304) | 删除集合中的大对象  
[detachCL()](/cn/sequoiadb-cat_id-1432190832-edition_id-304) | 从主分区集合中分离出子分区集合  
[disableCompression()](/cn/sequoiadb-cat_id-1524019500-edition_id-304) | 修改集合的属性关闭压缩功能  
[disableSharding()](/cn/sequoiadb-cat_id-1524019501-edition_id-304) | 修改集合的属性关闭分区功能  
[dropAutoIncrement()](/cn/sequoiadb-cat_id-1541039200-edition_id-304) | 删除自增字段  
[dropIdIndex()](/cn/sequoiadb-cat_id-1432190833-edition_id-304) | 删除集合中的 $id 索引  
[dropIndex()](/cn/sequoiadb-cat_id-1432190834-edition_id-304) | 删除集合中指定的索引  
[enableCompression()](/cn/sequoiadb-cat_id-1524019502-edition_id-304) | 开启集合的压缩功能或者修改集合的压缩算法  
[enableSharding()](/cn/sequoiadb-cat_id-1524019503-edition_id-304) | 修改集合的属性开启分区属性  
[find()](/cn/sequoiadb-cat_id-1432190835-edition_id-304) | 查询记录  
[findOne()](/cn/sequoiadb-cat_id-1432190836-edition_id-304) | 查询符合条件的一条记录  
[getDetail()](/cn/sequoiadb-cat_id-1586250289-edition_id-304) | 获取集合具体信息  
[getIndex()](/cn/sequoiadb-cat_id-1432190837-edition_id-304) | 获取指定索引  
[getIndexStat()](/cn/sequoiadb-cat_id-1595582798-edition_id-304) | 获取指定索引的统计信息  
[getLob()](/cn/sequoiadb-cat_id-1432190838-edition_id-304) | 读取大对象  
[getLobDetail()](/cn/sequoiadb-cat_id-1575861253-edition_id-304) | 获取大对象被读写访问的详细信息  
[insert()](/cn/sequoiadb-cat_id-1432190839-edition_id-304) | 将单条或者批量记录插入当前集合  
[listIndexes()](/cn/sequoiadb-cat_id-1432190840-edition_id-304) | 枚举集合下的索引信息  
[listLobs()](/cn/sequoiadb-cat_id-1432190841-edition_id-304) | 列举集合中的大对象  
[putLob()](/cn/sequoiadb-cat_id-1432190842-edition_id-304) | 在集合中插入大对象  
[remove()](/cn/sequoiadb-cat_id-1432190843-edition_id-304) | 删除集合中的记录  
[setAttributes()](/cn/sequoiadb-cat_id-1524019504-edition_id-304) | 修改集合的属性  
[split()](/cn/sequoiadb-cat_id-1432190844-edition_id-304) | 切分数据记录  
[splitAsync()](/cn/sequoiadb-cat_id-1432190845-edition_id-304) | 异步切分数据记录  
[truncate()](/cn/sequoiadb-cat_id-1432190846-edition_id-304) | 删除集合内所有数据  
[truncateLob()](/cn/sequoiadb-cat_id-1510277748-edition_id-304) | 截短集合中的大对象  
[update()](/cn/sequoiadb-cat_id-1432190847-edition_id-304) | 更新集合记录  
[upsert()](/cn/sequoiadb-cat_id-1432190848-edition_id-304) | 更新集合记录
