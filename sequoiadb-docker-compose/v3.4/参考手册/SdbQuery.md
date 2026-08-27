---
title: SdbQuery
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190853-edition_id-304
---

SdbQuery 类主要用于指定查询条件和操作查询结果，包含的函数如下：

名称 | 描述  
---|---  
[arrayAccess()](/cn/sequoiadb-cat_id-1537862272-edition_id-304) | 将结果集保存到数组中并获取指定下标记录  
[close()](/cn/sequoiadb-cat_id-1562070375-edition_id-304) | 关闭游标  
[count()](/cn/sequoiadb-cat_id-1432190855-edition_id-304) | 查询符合匹配条件的记录条数  
[current()](/cn/sequoiadb-cat_id-1562070410-edition_id-304) | 获取当前游标指向的记录  
[explain()](/cn/sequoiadb-cat_id-1432190854-edition_id-304) | 获取查询的访问计划  
[flags()](/cn/sequoiadb-cat_id-1564555250-edition_id-304) | 按指定的标志位遍历结果集  
[getQueryMeta()](/cn/sequoiadb-cat_id-1537862277-edition_id-304) | 获取查询元数据信息  
[hint()](/cn/sequoiadb-cat_id-1432190857-edition_id-304) | 按指定的索引遍历结果集  
[limit()](/cn/sequoiadb-cat_id-1432190858-edition_id-304) | 控制查询返回的记录条数  
[next()](/cn/sequoiadb-cat_id-1562070468-edition_id-304) | 获取当前游标指向的下一条记录  
[query()](/cn/sequoiadb-cat_id-1432190856-edition_id-304) | 以下标的方式访问查询结果集  
[remove()](/cn/sequoiadb-cat_id-1432190859-edition_id-304) | 删除查询后的结果集  
[size()](/cn/sequoiadb-cat_id-1432190860-edition_id-304) | 返回当前游标到最终游标的记录条数  
[skip()](/cn/sequoiadb-cat_id-1432190861-edition_id-304) | 指定结果集从哪条记录开始返回  
[sort()](/cn/sequoiadb-cat_id-1432190862-edition_id-304) | 对结果集按指定字段排序  
[toArray()](/cn/sequoiadb-cat_id-1432190863-edition_id-304) | 以数组的形式返回结果集  
[update()](/cn/sequoiadb-cat_id-1432190864-edition_id-304) | 更新查询后的结果集
