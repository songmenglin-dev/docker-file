---
title: transCommit()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190816-edition_id-304
---

## 名称

transCommit - 事务提交

## 语法

**db.transCommit()**

## 类别

Sdb

## 描述

该函数用于事务提交。在开启事务之后，如果单个逻辑工作单元执行的操作无异常，执行事务提交命令，那么数据库的数据将被更新。

## 参数

无

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

执行事务提交命令
    
    
    > db.transCommit()
