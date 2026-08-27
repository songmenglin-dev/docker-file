---
title: startRG()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190810-edition_id-304
---

## 名称

startRG - 启动复制组

## 语法

**db.startRG( <name1>, [name2], ...)**

## 类别

Sdb

## 描述

该函数用于启动指定的复制组，启动后才能执行集合的相关操作。该方法等价于[rg.start()](/cn/sequoiadb-cat_id-1432190875-edition_id-304)。

## 参数

参数名 | 类型 | 描述 | 是否必填  
---|---|---|---  
name1, name2... | string | 复制组的名称 | 是  
  
> **Note:**
> 
> 若指定的复制组不存在，将抛异常。

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

启动复制组的命令如下：
    
    
    > db.startRG("group1")
    > db.startRG("group2", "group3", "group4")
