---
title: getSystem()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1608883259-edition_id-304
---

## 名称

getSystem - 新建一个远程 System 对象

## 语法

**remoteObj.getSystem()**

## 类别

Remote

## 描述

该函数用于新建一个远程 System 对象。

## 参数

无

## 返回值

函数执行成功时，将返回一个 System 对象。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

  * 新建一个远程连接对象。
        
        > var remoteObj = new Remote( "192.168.20.71", 11790 )

  * 新建一个远程 System 对象
        
        > var system = remoteObj.getSystem()
