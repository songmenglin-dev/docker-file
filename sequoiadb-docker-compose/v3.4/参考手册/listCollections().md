---
title: listCollections()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190795-edition_id-304
---

## 名称

listCollections - 枚举集合信息

## 语法

**db.listCollections()**

## 类别

Sdb

## 描述

该函数用于枚举数据库中所有的集合信息。

## 参数

无

## 返回值

函数执行成功时，将返回游标对象。通过游标对象获取的结果字段说明可查看 [$LIST_CL](/cn/sequoiadb-cat_id-1559282953-edition_id-304)

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

  * 数据库中所有的集合信息
        
        > db.listCollections()
        {
            "Name": "sample.employee"
        }
