---
title: reloadConf()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1483064748-edition_id-304
---

## 名称

reloadConf - 重新加载配置文件

## 语法

**db.reloadConf([options])**

## 类别

Sdb

## 描述

该函数用于重新加载配置文件，使配置动态生效。如果配置项不允许动态生效会被忽略。

## 参数

参数名 | 类型 | 描述 | 是否必填  
---|---|---|---  
options | object | [命令位置参数](/cn/sequoiadb-cat_id-1482314609-edition_id-304) | 否  
  
> **Note:**
> 
> 用户不指定命令位置参数时，默认对所有节点生效。

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.8 及以上版本

## 示例

  * 对所有节点进行配置重新加载
        
        // 连接协调节点
        > db = new Sdb("localhost", 11810)
        > db.reloadConf()

  * 对指定节点 1000 进行配置重加载
        
        // 连接协调节点
        > db = new Sdb("localhost", 11810)
        > db.reloadConf({NodeID: 1000})
