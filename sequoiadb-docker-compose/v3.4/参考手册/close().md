---
title: close()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190770-edition_id-304
---

## 名称

close - 关闭数据库连接

## 语法

**db.close()**

## 类别

Sdb

## 描述

该函数用于关闭数据库连接。

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

关闭数据库连接
    
    
    > var db = new Sdb("localhost", 11810)
    > db.close()
