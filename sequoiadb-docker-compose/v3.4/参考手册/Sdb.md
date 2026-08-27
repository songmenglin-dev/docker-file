---
title: Sdb
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190767-edition_id-304
---

Sdb 类主要用于连接和操作 SequoiaDB 巨杉数据库，包含的函数函数如下：

名称 | 描述  
---|---  
[Sdb()](/cn/sequoiadb-cat_id-1564969947-edition_id-304) | SequoiaDB 连接对象  
[analyze()](/cn/sequoiadb-cat_id-1496923440-edition_id-304) | 收集统计信息  
[backup()](/cn/sequoiadb-cat_id-1432190768-edition_id-304) | 备份数据库  
[cancelTask()](/cn/sequoiadb-cat_id-1432190769-edition_id-304) | 取消任务  
[close()](/cn/sequoiadb-cat_id-1432190770-edition_id-304) | 关闭数据库连接  
[createCataRG()](/cn/sequoiadb-cat_id-1432190771-edition_id-304) | 新建编目复制组  
[createCoordRG()](/cn/sequoiadb-cat_id-1432190772-edition_id-304) | 创建协调复制组  
[createCS()](/cn/sequoiadb-cat_id-1432190773-edition_id-304) | 创建集合空间  
[createDataSource()](/cn/sequoiadb-cat_id-1610376288-edition_id-304) | 创建数据源  
[createDomain()](/cn/sequoiadb-cat_id-1432190774-edition_id-304) | 创建域  
[createProcedure()](/cn/sequoiadb-cat_id-1432190775-edition_id-304) | 创建存储过程  
[createRG()](/cn/sequoiadb-cat_id-1432190776-edition_id-304) | 新建复制组  
[createSequence()](/cn/sequoiadb-cat_id-1606120774-edition_id-304) | 创建序列对象  
[createSpareRG()](/cn/sequoiadb-cat_id-1432290820-edition_id-304) | 创建热备组  
[createUsr()](/cn/sequoiadb-cat_id-1432190777-edition_id-304) | 创建数据库用户  
[dropCS()](/cn/sequoiadb-cat_id-1432190778-edition_id-304) | 删除一个已存在的集合空间  
[dropDataSource()](/cn/sequoiadb-cat_id-1610376333-edition_id-304) | 删除数据源  
[dropDomain()](/cn/sequoiadb-cat_id-1432190779-edition_id-304) | 删除域  
[dropSequence()](/cn/sequoiadb-cat_id-1606120775-edition_id-304) | 删除指定的序列  
[dropUsr()](/cn/sequoiadb-cat_id-1432190780-edition_id-304) | 删除数据库用户  
[eval()](/cn/sequoiadb-cat_id-1432190781-edition_id-304) | 调用存储过程  
[exec()](/cn/sequoiadb-cat_id-1432190782-edition_id-304) | 执行 SQL 的 select 语句  
[execUpdate()](/cn/sequoiadb-cat_id-1432190783-edition_id-304) | 执行除 select 以外的 SQL 语句  
[flushConfigure()](/cn/sequoiadb-cat_id-1432190784-edition_id-304) | 将节点内存中的配置刷盘至配置文件  
[forceSession()](/cn/sequoiadb-cat_id-1432190785-edition_id-304) | 终止指定会话的当前操作  
[forceStepUp()](/cn/sequoiadb-cat_id-1432190786-edition_id-304) | 强制将备节点升级为主节点  
[getCataRG()](/cn/sequoiadb-cat_id-1432190787-edition_id-304) | 获取编目复制组的引用  
[getCoordRG()](/cn/sequoiadb-cat_id-1432190788-edition_id-304) | 获取协调复制组的引用  
[getCS()](/cn/sequoiadb-cat_id-1432190789-edition_id-304) | 获取指定集合空间  
[getDataSource()](/cn/sequoiadb-cat_id-1610377717-edition_id-304) | 获取数据源的引用  
[getDomain()](/cn/sequoiadb-cat_id-1432190790-edition_id-304) | 获取指定域  
[getRG()](/cn/sequoiadb-cat_id-1432190791-edition_id-304) | 获取指定复制组  
[getSequence()](/cn/sequoiadb-cat_id-1606120776-edition_id-304) | 获取指定的序列对象  
[getSessionAttr()](/cn/sequoiadb-cat_id-1516326561-edition_id-304) | 获取会话属性  
[getSpareRG()](/cn/sequoiadb-cat_id-1432290821-edition_id-304) | 获取备份组的引用  
[invalidateCache()](/cn/sequoiadb-cat_id-1432190792-edition_id-304) | 清除节点的缓存信息  
[list()](/cn/sequoiadb-cat_id-1432190793-edition_id-304) | 获取列表  
[listBackup()](/cn/sequoiadb-cat_id-1432190794-edition_id-304) | 枚举数据库备份  
[listCollections()](/cn/sequoiadb-cat_id-1432190795-edition_id-304) | 枚举集合信息  
[listCollectionSpaces()](/cn/sequoiadb-cat_id-1432190796-edition_id-304) | 枚举集合空间信息  
[listDataSources()](/cn/sequoiadb-cat_id-1610377810-edition_id-304) | 查看数据源的元数据信息  
[listDomains()](/cn/sequoiadb-cat_id-1432190797-edition_id-304) | 枚举用户创建的域  
[listProcedures()](/cn/sequoiadb-cat_id-1432190798-edition_id-304) | 枚举存储过程  
[listReplicaGroups()](/cn/sequoiadb-cat_id-1432190799-edition_id-304) | 枚举复制组信息  
[listSequences()](/cn/sequoiadb-cat_id-1563243399-edition_id-304) | 枚举序列信息  
[listTasks()](/cn/sequoiadb-cat_id-1432190800-edition_id-304) | 枚举后台任务  
[removeBackup()](/cn/sequoiadb-cat_id-1432190801-edition_id-304) | 删除数据库备份  
[removeCataRG()](/cn/sequoiadb-cat_id-1432190803-edition_id-304) | 删除编目复制组  
[removeCoordRG()](/cn/sequoiadb-cat_id-1432190804-edition_id-304) | 删除数据库中的协调复制组  
[removeSpareRG()](/cn/sequoiadb-cat_id-1432290822-edition_id-304) | 删除数据库中的 SYSSpare 组  
[removeProcedure()](/cn/sequoiadb-cat_id-1432190805-edition_id-304) | 删除指定的函数名  
[removeRG()](/cn/sequoiadb-cat_id-1432190806-edition_id-304) | 删除复制组  
[renameCS()](/cn/sequoiadb-cat_id-1541488257-edition_id-304) | 集合空间改名  
[renameSequence()](/cn/sequoiadb-cat_id-1606120777-edition_id-304) | 修改序列名  
[resetSnapshot()](/cn/sequoiadb-cat_id-1432190807-edition_id-304) | 重置快照  
[reloadConf()](/cn/sequoiadb-cat_id-1483064748-edition_id-304) | 重新加载配置文件  
[deleteConf()](/cn/sequoiadb-cat_id-1521424296-edition_id-304) | 删除配置  
[setSessionAttr()](/cn/sequoiadb-cat_id-1432190808-edition_id-304) | 设置会话属性  
[snapshot()](/cn/sequoiadb-cat_id-1432190809-edition_id-304) | 获取快照  
[startRG()](/cn/sequoiadb-cat_id-1432190810-edition_id-304) | 启动复制组  
[stopRG()](/cn/sequoiadb-cat_id-1432190819-edition_id-304) | 停止复制组  
[sync()](/cn/sequoiadb-cat_id-1482329455-edition_id-304) | 持久化数据和日志到磁盘  
[setPDLevel()](/cn/sequoiadb-cat_id-1483064791-edition_id-304) | 动态设置节点的诊断日志级别  
[traceOff()](/cn/sequoiadb-cat_id-1432190811-edition_id-304) | 关闭数据库引擎跟踪功能  
[traceOn()](/cn/sequoiadb-cat_id-1432190812-edition_id-304) | 开启数据库引擎跟踪功能  
[traceResume()](/cn/sequoiadb-cat_id-1432190813-edition_id-304) | 重新开启断点跟踪程序  
[traceStatus()](/cn/sequoiadb-cat_id-1432190814-edition_id-304) | 查看当前程序跟踪的状态  
[transBegin()](/cn/sequoiadb-cat_id-1432190815-edition_id-304) | 开启事务  
[transCommit()](/cn/sequoiadb-cat_id-1432190816-edition_id-304) | 事务提交  
[transRollback()](/cn/sequoiadb-cat_id-1432190817-edition_id-304) | 事务回滚  
[updateConf()](/cn/sequoiadb-cat_id-1521424274-edition_id-304) | 更新节点配置  
[waitTasks()](/cn/sequoiadb-cat_id-1432190818-edition_id-304) | 同步等待指定任务结束或取消
