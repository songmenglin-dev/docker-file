---
title: toArray()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190863-edition_id-304
---

## 名称

toArray - 以数组的形式返回结果集

## 语法

**query.toArray()**

## 类别

SdbQuery

## 描述

以数组的形式返回结果集。

## 参数

无

## 返回值

返回数组形式的结果集。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。 关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v2.0 及以上版本。

## 示例

以数组的形式返回集合 employee 中 age 字段值大于5的记录（如使用 [$gt](/cn/sequoiadb-cat_id-1432190900-edition_id-304) 查询）。
    
    
    > var arr = db.sample.employee.find( { age: { $gt: 20 } }, { age: "", name: "" }).toArray()
    > arr[0]
    {
      "name": "John",
      "age": 25
    }
