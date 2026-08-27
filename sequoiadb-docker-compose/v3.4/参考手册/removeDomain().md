---
title: removeDomain()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1524019771-edition_id-304
---

## 名称

removeDomain - 移除集合空间的所属域

## 语法

**db.collectionspace.removeDomain()**

## 类别

SdbCS

## 描述

该函数用于移除集合空间的所属域。

## 参数

无

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.10 及以上版本

## 示例

创建一个集合空间并指定一个域，然后把该集合空间移除该域
    
    
    > db.createCS('sample', {Domain: 'domain'})
    > db.sample.removeDomain()
