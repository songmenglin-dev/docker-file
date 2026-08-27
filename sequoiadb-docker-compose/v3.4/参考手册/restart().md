---
title: restart()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1606120788-edition_id-304
---

## 名称

restart - 使序列从指定值开始重新计数

## 语法

**sequence.restart( <value>)**

## 类别

SdbSequence

## 描述

该函数可以使序列从指定值开始重新计数。指定的起始值可以是序列最小值至最大值范围内的任意值。

## 参数

value（ _number_ ， _必填_ ）

指定的起始值

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4.2 及以上版本

## 示例

使当前值为 10 的序列从 1 开始重新计数
    
    
    > sequence.getNextValue()
    10
    > sequence.restart( 1 )
    > sequence.getNextValue()
    1
