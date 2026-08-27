---
title: start()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190875-edition_id-304
---

## 名称

start - 启动当前复制组

## 语法

**rg.start()**

## 类别

SdbReplicaGroup

## 描述

该函数用于启动当前复制组。复制组启动之后才能创建节点及其他操作。也可以使用方法 [startRG()](/cn/sequoiadb-cat_id-1432190810-edition_id-304) 启动指定的节点。

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

启动复制组 group1 
    
    
    > var rg = db.getRG("group1")
    > rg.start()   //等价于 db.startRG("group")
