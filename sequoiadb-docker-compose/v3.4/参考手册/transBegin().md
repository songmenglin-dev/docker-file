---
title: transBegin()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190815-edition_id-304
---

## 名称

transBegin - 开启事务

## 语法

**db.transBegin()**

## 类别

Sdb

## 描述

该函数用于开启事务，SequoiaDB 数据库事务是指作为单个逻辑工作单元执行的一系列操作。事务处理可以确保除了非事务性单元内的所有操作都成功完成，否则不会永久更新面向数据的资源。

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

  * 开启事务
        
        > db.transBegin()

  * 插入记录
        
        > cl.insert({date: 99, id: 8, a: 0})

  * 回滚事务，插入的记录将被回滚，集合中无记录
        
        > db.transRollback()
        > cl.count()

  * 开启事务
        
        > db.transBegin()

  * 插入记录
        
        > cl.insert({date: 99, id: 8, a: 0})

  * 提交事务，插入的记录将被写入数据库
        
        > db.transCommit()
        > cl.count()
        1
