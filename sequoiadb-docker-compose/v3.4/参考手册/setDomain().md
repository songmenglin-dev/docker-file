---
title: setDomain()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1524019773-edition_id-304
---

## 名称

setDomain - 修改集合空间的所属域

## 语法

**db.collectionspace.setDomain( <options>)**

## 类别

SdbCS

## 描述

该函数用于修改集合空间的所属域。

## 参数

options ( _object，必填_ )

通过 options 参数可以修改集合空间属性：

  * Domain ( _string_ )：所属域

集合空间的数据必须分布在新指定域的组上

格式：`Domain: <domain>`

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.10 及以上版本

## 示例

创建一个集合空间，然后为该集合空间指定一个域
    
    
    > db.createCS('sample')
    > db.sample.setDomain({Domain: 'domain'})
