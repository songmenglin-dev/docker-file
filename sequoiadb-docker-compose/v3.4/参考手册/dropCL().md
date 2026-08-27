---
title: dropCL()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190822-edition_id-304
---

## 名称

dropCL - 删除当前集合空间下指定的集合

## 语法

**db.collectionspace.dropCL( <name>)**

## 类别

SdbCS

## 描述

该函数用于删除当前集合空间下指定的集合。

## 参数

name ( _string，必填_ )

集合名

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`dropCL()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-23 | SDB_DMS_NOTEXIST | 集合不存在 | 检查集合是否存在  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v1.0 及以上版本

## 示例

删除集合空间 sample 下的集合 employee
    
    
    > db.sample.dropCL("employee")
