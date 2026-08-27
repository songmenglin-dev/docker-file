---
title: createSpareRG()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432290820-edition_id-304
---

## 名称

createSpareRG - 创建热备组

## 语法

**db.createSpareRG()**

## 类别

Sdb

## 描述

该函数用于创建热备组，用户可以通过该组管理[热备节点](/cn/sequoiadb-cat_id-1610960736-edition_id-304)。

## 参数

无

## 返回值

函数执行成功时，将返回一个 SdbReplicaGroup 类型的对象。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.8 及以上版本

## 示例

创建一个热备组
    
    
    > db.createSpareRG()
