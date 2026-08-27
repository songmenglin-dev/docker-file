---
title: removeCoordRG()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190804-edition_id-304
---

## 名称

removeCoordRG - 删除数据库中的协调复制组

## 语法

**db.removeCoordRG()**

## 类别

Sdb

## 描述

该函数用于删除数据库中的协调复制组。该操作原则上会把复制组的所有协调节点删除，但如果在删除节点过程中，先删除了 db 对象所连接的协调节点，则可能会遗留部分协调节点。此时，需要使用 [Oma.removeCoord()](/cn/sequoiadb-cat_id-1432190893-edition_id-304) 删除遗留的协调节点。

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

删除协调复制组
    
    
    > db.removeCoordRG()
