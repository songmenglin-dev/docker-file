---
title: forceStepUp()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190786-edition_id-304
---

## 名称

forceStepUp - 强制将备节点升级为主节点

## 语法

**db.forceStepUp([options])**

## 类别

Sdb

## 描述

该函数用于在一个不具备选举条件的复制组中，将备节点强制升级为主节点。升级前需确保目标节点 LSN 为组内最大值。如果将 LSN 较小的节点强制升主，将导致数据回滚。用户可通过[节点健康检测快照](/cn/sequoiadb-cat_id-1516786163-edition_id-304)获取节点 LSN 信息。

> **Note:**
> 
> 该函数仅支持在编目复制组中使用。

## 参数

options（ _object，选填_ ）

通过参数 options 可以指定主节点的持续时间：

  * Seconds（ _number_ ）：强制升级为主节点的持续时间，单位为秒，默认值为 120

当超过指定时间，复制组内将按选举规则重新选主。

格式：`Seconds: 300`

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4 及以上版本

## 示例

  1. 连接编目节点 11800
         
         > var cata = new Sdb("localhost", 11800)

> **Note:**
> 
> 如果无法连接编目节点，需要将节点参数 auth 配置为 false，配置方式可参考[参数配置](/cn/sequoiadb-cat_id-1632902617-edition_id-304)。

  2. 将编目节点 11800 强制升为主节点，并指定持续时间为 300 秒
         
         > cata.forceStepUp({Seconds: 300})
