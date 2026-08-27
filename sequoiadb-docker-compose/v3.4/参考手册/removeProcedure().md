---
title: removeProcedure()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190805-edition_id-304
---

## 名称

removeProcedure - 删除指定的存储过程

## 语法

**db.removeProcedure( <function name>)**

## 类别

Sdb

## 描述

该函数用于删除指定的存储过程。该存储过程必须存在，否则出现异常信息。

## 参数

参数名 | 类型 | 描述 | 是否必填  
---|---|---|---  
function name | string | 存储过程名 | 是  
  
## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`removeProcedure()`函数常见异常如下

错误码 | 错误类型 | 可能发生的原因 | 解决方法  
---|---|---|---  
-233 | SDB_FMP_FUNC_NOT_EXIST | 存储过程不存在 | 使用命令 [listProcedures()](/cn/sequoiadb-cat_id-1432190798-edition_id-304) 确认指定存储过程是否存在  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

删除名为“sum”的存储过程
    
    
    > db.removeProcedure("sum")
