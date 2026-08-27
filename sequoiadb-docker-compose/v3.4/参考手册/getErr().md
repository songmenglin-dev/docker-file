---
title: getErr()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1529976605-edition_id-304
---

## 名称

getErr - 获取错误码的描述信息。

## 语法

**getErr( <error code>)**

## 类别

Global

## 描述

获取前一次操作返回的错误码。

## 参数

  * `error code` ( _Int32_ ， _Required_ )

[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304).

## 返回值

[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)的描述信息。

## 版本

v1.0及以上版本。

## 示例

  1. 获取前一次操作返回的错误码。
         
         > getErr(-15)
         Network error
