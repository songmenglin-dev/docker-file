---
title: forceSession()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190785-edition_id-304
---

## 名称

forceSession - 终止指定会话的当前操作

## 语法

**db.forceSession( <sessionID>, [options])**

## 类别

Sdb

## 描述

该函数用于终止指定会话的当前操作。如果不指定节点信息，默认为对自身的会话进行操作。

## 参数

参数名 | 类型 | 描述 | 是否必填  
---|---|---|---  
sessionID | number | 会话编号 | 是  
options | object | [命令位置参数](/cn/sequoiadb-cat_id-1482314609-edition_id-304) | 否  
  
> **Note:**
> 
>   * 只有用户会话可以被终止。
>   * 会话编号可以通过 [list()](/cn/sequoiadb-cat_id-1432190793-edition_id-304) 或 [snapshot()](/cn/sequoiadb-cat_id-1432190809-edition_id-304) 获取。
>   * options 参数只在协调节点生效。
>   * 如果终止的会话是当前会话，连接会被断开，不能再执行操作。
> 

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`forceSession()`函数常见异常如下：

错误码 | 错误类型 | 描述 | 解决方法  
---|---|---|---  
-62 | SDB_PMD_SESSION_NOT_EXIST | 指定会话不存在 | 检查指定会话是否存在  
-63 | SDB_PMD_FORCE_SYSTEM_EDU | 系统会话不能被终止 | -  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

  * 终止当前节点中，编号为 30 的会话
        
        // 连接节点
        > db = new Sdb("localhost", 11810)
        // 终止指定会话
        > db.forceSession(30)

  * 终止 NodeID 为 1000 的节点中，编号为 30 的会话
        
        // 连接节点
        > db = new Sdb("localhost", 11810)
        // 终止指定会话 
        > db.forceSession(30, {NodeID: 1000})
