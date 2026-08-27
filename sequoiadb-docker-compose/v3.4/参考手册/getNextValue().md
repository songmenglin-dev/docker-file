---
title: getNextValue()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1606119777-edition_id-304
---

## 名称

getNextValue - 获取序列的下一个值

## 语法

**sequence.getNextValue()**

## 类别

SdbSequence

## 描述

该函数用于是获取当前序列的下一个值。通常该值能保证唯一，可以用于做 ID 标识等用途。

## 参数

无

## 返回值

函数执行成功时，将以数值形式返回序列的下一个值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4.2 及以上版本

## 示例

获取当前序列的下一个值
    
    
    > var sequence = db.createSequence("IDSequence")
    > sequence.getNextValue()
    1
