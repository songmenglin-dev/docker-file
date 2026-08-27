---
title: removeRG()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190806-edition_id-304
---

## 名称

removeRG - 删除复制组

## 语法

**db.removeRG( <name>)**

## 类别

Sdb

## 描述

该函数用于删除数据库中指定的复制组，该复制组必须存在。

## 参数

参数名 | 类型 | 描述 | 是否必填  
---|---|---|---  
name | string | 复制组名，同一个数据库对象中，复制组名唯一 | 是  
  
## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

删除名为“group”的复制组
    
    
    > db.removeRG("group")
