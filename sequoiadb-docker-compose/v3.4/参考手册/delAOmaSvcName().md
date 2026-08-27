---
title: delAOmaSvcName()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1580718030-edition_id-304
---

## 名称

delAOmaSvcName - 将目标机器 sdbcm 的服务端口号从其配置文件中删除。

## 语法

**oma.delAOmaSvcName( <hostname>,[confFile])**

## 类别

Oma

## 描述

将目标机器 sdbcm 的服务端口号从其配置文件中删除。

## 参数

  * `hostname` ( _String_ ， _必填_ )

目标机器主机名。

  * `configFile` ( _String_ ， _选填_ )

配置文件路径，当不填时使用默认的配置文件：SequoiaDB 安装目录下的 conf/sdbcm.conf 文件。

## 返回值

成功：无。 

失败：抛出异常。

## 错误

`delAOmaSvcName()`函数常见异常如下：

错误码 | 错误类型 | 描述 | 解决方法  
---|---|---|---  
-4 | SDB_FNE | 文件不存在。 | 检查配置文件路径是否正确。  
  
当异常抛出时，可以通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)， 或通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息。 可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)了解更多内容。

## 版本

v2.0及以上版本。

## 示例

将目标机器 sdbserver1 上 sdbcm 的服务端口号从其配置文件中删除。
    
    
    > var oma = new Oma( "sdbserver1", 11790 )
    > oma.delAOmaSvcName( "sdbserver1")
