---
title: truncateLob()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1510277748-edition_id-304
---

## 名称

truncateLob - 截断集合中的大对象

## 语法

**db.collectionspace.collection.truncateLob( <oid>, <length>)**

## 类别

SdbCollection

## 描述

该函数用于截断集合中的大对象。

## 参数

  * oid（ _string，必填_ ）

大对象的唯一标识 

  * length（ _number，必填_ ）

截断后大对象的长度

    * length 的取值小于 0 时，输出报错信息。
    * length 的取值大于大对象的长度时，不发生截断。

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.0 及以上版本

## 示例

指定 oid 为"5435e7b69487faa663000897"的大对象，将其长度截断为 0
    
    
    > db.sample.employee.truncateLob("5435e7b69487faa663000897", 0)
