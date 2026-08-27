---
title: Oma
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190888-edition_id-304
---

Oma 类主要用于集群管理，包含的函数如下：

名称 | 描述  
---|---  
[Oma()](/cn/sequoiadb-cat_id-1495022521-edition_id-304) | 集群管理对象  
[addAOmaSvcName()](/cn/sequoiadb-cat_id-1580718029-edition_id-304) | 将目标机器为 sdbcm 设置的服务端口号写到该 sdbcm 的配置文件中  
[delAOmaSvcName()](/cn/sequoiadb-cat_id-1580718030-edition_id-304) | 将目标机器 sdbcm 的服务端口号从其配置文件中删除  
[close()](/cn/sequoiadb-cat_id-1432190889-edition_id-304) | 关闭 Oma 连接对象  
[createCoord()](/cn/sequoiadb-cat_id-1432190890-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中创建一个 coord 节点  
[createData()](/cn/sequoiadb-cat_id-1432190891-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中创建一个 standalone 节点  
[createOM()](/cn/sequoiadb-cat_id-1432190892-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中创建 sdbom 服务进程（ SequoiaDB 管理中心进程）  
[getAOmaSvcName()](/cn/sequoiadb-cat_id-1580718031-edition_id-304) | 获取目标机器 sdbcm 的服务端口  
[getIniConfigs()](/cn/sequoiadb-cat_id-1580718032-edition_id-304) | 获取 INI 文件的配置信息  
[getNodeConfigs()](/cn/sequoiadb-cat_id-1580718033-edition_id-304) | 从配置文件中获取指定端口的数据库节点的配置信息  
[getOmaConfigFile()](/cn/sequoiadb-cat_id-1580718034-edition_id-304) | 获取 sdbcm 的配置文件  
[getOmaConfigs()](/cn/sequoiadb-cat_id-1580718035-edition_id-304) | 获取 sdbcm 的配置信息  
[getOmaInstallFile()](/cn/sequoiadb-cat_id-1580718036-edition_id-304) | 获取安装信息文件  
[getOmaInstallInfo()](/cn/sequoiadb-cat_id-1580718037-edition_id-304) | 从安装信息文件中获取安装信息  
[listNodes()](/cn/sequoiadb-cat_id-1580718038-edition_id-304) | 列出当前所连 sdbcm 所在机器符合条件的所有节点的信息  
[reloadConfigs()](/cn/sequoiadb-cat_id-1580718039-edition_id-304) | sdbcm 重新加载其配置文件的内容，并使其生效  
[removeCoord()](/cn/sequoiadb-cat_id-1432190893-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中删除一个 coord 节点  
[removeData()](/cn/sequoiadb-cat_id-1432190894-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中删除指定的 standalone 节点  
[removeOM()](/cn/sequoiadb-cat_id-1432190895-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中删除 sdbom 服务进程（SequoiaDB 管理中心进程）  
[setIniConfigs()](/cn/sequoiadb-cat_id-1580718040-edition_id-304) | 把配置信息写入 INI 文件  
[setNodeConfigs()](/cn/sequoiadb-cat_id-1580718041-edition_id-304) | 对指定端口的数据库节点，用新的节点配置信息覆盖该节点原来配置文件上的配置信息  
[setOmaConfigs()](/cn/sequoiadb-cat_id-1580718042-edition_id-304) | 把 sdbcm 的配置信息写入到其配置文件  
[start()](/cn/sequoiadb-cat_id-1580718043-edition_id-304) | 启动 sdbcm 服务  
[startAllNodes()](/cn/sequoiadb-cat_id-1507622478-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中启动所有属于指定业务的节点  
[stopAllNodes()](/cn/sequoiadb-cat_id-1507622490-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中停止所有属于指定业务的节点  
[startNode()](/cn/sequoiadb-cat_id-1432190896-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中启动指定节点  
[stopNode()](/cn/sequoiadb-cat_id-1432190897-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中停止指定节点  
[startNodes()](/cn/sequoiadb-cat_id-1580718044-edition_id-304) | 通过服务端口启动节点  
[stopNodes()](/cn/sequoiadb-cat_id-1580718045-edition_id-304) | 在目标集群控制器（sdbcm）所在的机器中停止指定节点  
[updateNodeConfigs()](/cn/sequoiadb-cat_id-1580718046-edition_id-304) | 对指定端口的数据库节点，用新的节点配置信息更新该节点原来配置文件上的配置信息
