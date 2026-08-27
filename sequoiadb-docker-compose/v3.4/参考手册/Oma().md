---
title: Oma()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1495022521-edition_id-304
---

## 名称

Oma - 集群管理对象。

## 语法

**var oma = new Oma([hostname],[svcname])**

## 类别

Oma

## 描述

集群管理对象。

## 参数

  * `hostname` ( _String_ ， _选填_ )

目标sdbcm所在主机的主机名。

  * `svcname` ( _Int | String_ ， _选填_ )

目标sdbcm所使用的端口号， 默认端口号为11790。

## 返回值

成功：返回Oma对象。 

失败：抛出异常。

## 错误

`Oma()`函数常见异常如下：

错误码 | 错误类型 | 描述 | 解决方法  
---|---|---|---  
-15 | SDB_NETWORK | 网络错误 | 检查填写的地址或者端口是否可达。  
  
当异常抛出时，可以通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)， 或通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息。 可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)了解更多内容。

## 版本

v1.12 及以上版本。

## 示例

  1. 获取本地 Oma 管理对象
         
         > var oma = new Oma()

  2. 获取指定机器的 Oma 管理对象
         
         > var oma = new Oma( "ubuntu-dev1", 11790 )
