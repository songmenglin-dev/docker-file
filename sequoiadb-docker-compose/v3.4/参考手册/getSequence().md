---
title: getSequence()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1606120776-edition_id-304
---

## 名称

getSequence - 获取指定的序列对象

## 语法

**db.getSequence( <name>)**

## 类别

Sdb

## 描述

该函数用于在当用户需要对指定序列进行操作时，可以使用该函数获取序列的对象。

## 参数

name（ _string_ ， _必填_ ）

序列名

## 返回值

函数执行成功时，将返回一个 SdbSequence 类型的对象。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`getSequence()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-324 | SDB_SEQUENCE_NOT_EXIST | 指定序列不存在 | 检查序列是否存在  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4.2 及以上版本

## 示例

获取指定名字的序列对象
    
    
    > var sequence = db.getSequence("IDSequence")

可以通过返回对象获取序列的下一个值
    
    
    > sequence.getNextValue()
    1
