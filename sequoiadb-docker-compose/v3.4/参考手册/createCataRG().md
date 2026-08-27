---
title: createCataRG()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190771-edition_id-304
---

## 名称

createCataRG - 新建编目复制组

## 语法

**db.createCataRG( <host>, <service>, <dbpath>, [config] )**

## 类别

Sdb

## 描述

该函数用于新建编目复制组，同时创建并启动一个编目节点。同一集群中只能创建一个编目复制组，且组名默认为“SYSCatalogGroup”。

## 参数

  * host（ _string，必填_ ）

指定编目节点的主机名

  * service（ _int32/string，必填_ ）

指定编目节点的服务端口，需确保该端口号及往后延续的五个端口号都未被占用；如指定服务端口为 11800，应确保 11800/11801/11802/11803/11804/11805 端口都未被占用 

  * dbpath（ _string，必填_ ）

指定数据文件路径，用于存放编目数据文件；建议填写绝对路径，且确保数据库管理用户（安装时创建，默认为 sdbadmin）对该路径有写权限

  * config（ _object，选填_ ）

指定需要配置的细节参数，细节参数可参考[数据库配置](/cn/sequoiadb-cat_id-1632902617-edition_id-304)一节

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

在名为"hostname1"的主机上创建一个编目复制组，指定服务端口为 11800，指定数据文件存放路径为 `/opt/sequoiadb/database/cata/11800`，并配置日志文件大小为 64MB
    
    
    > db.createCataRG("hostname1",11800,"/opt/sequoiadb/database/cata/11800",{logfilesz:64})
