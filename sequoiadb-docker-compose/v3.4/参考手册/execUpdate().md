---
title: execUpdate()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190783-edition_id-304
---

## 名称

execUpdate - 执行除 select 以外的 SQL 语句

## 语法

**db.execUpdate( <other sql>)**

## 类别

Sdb

## 描述

该函数用于执行 SQL 除 select 以外的其它语句。

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

向集合 sample.employee 中插入新的记录
    
    
    > db.execUpdate("insert into sample.employee(name,age) values('zhangshang', 30)")
