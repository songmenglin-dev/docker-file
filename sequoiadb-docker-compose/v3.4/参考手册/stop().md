---
title: stop()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190876-edition_id-304
---

## 名称

stop - 停止当前复制组

## 语法

**rg.stop()**

## 类别

SdbReplicaGroup

## 描述

该函数用于停止当前复制组。

> **Note:**
> 
> 停止后将不能执行创建节点等相关操作，可以通过 [start()](/cn/sequoiadb-cat_id-1432190875-edition_id-304) 启动节点后操作。

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

停止复制组 group1
    
    
    > var rg = db.getRG("group1")
    > rg.stop()
