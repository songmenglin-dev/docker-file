---
title: setLastError()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1529976617-edition_id-304
---

## 名称

setLastError - 设置前一次操作返回的错误码。

## 语法

**setLastError( <error code>)**

## 类别

Global

## 描述

设置前一次操作返回的错误码。

## 参数

  * `error code` ( _Int32_ ， _必填_ )

[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 返回值

无。

## 版本

v2.6及以上版本。

## 示例

  1. 设置前一次操作返回的错误码。
         
         > db = new Sdb()
         (nofile):0 uncaught exception: -15
         > getLastError()
         -15
         > getLastError()
         -15
         > setLastError(0)
         > getLastError()
         0
