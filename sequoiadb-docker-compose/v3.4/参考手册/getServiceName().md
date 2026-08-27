---
title: getServiceName()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190881-edition_id-304
---

## 名称

getServiceName - 获取节点的服务器名

## 语法

**node.getServiceName()**

## 类别

SdbNode

## 描述

该函数用于获取节点的服务器名。

## 参数

无

## 返回值

函数执行成功时，将返回一个 String 类型的对象。通过该对象获取节点的服务器名。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

获取 node 节点的服务器名
    
    
    > node.getServiceName()
    11800
