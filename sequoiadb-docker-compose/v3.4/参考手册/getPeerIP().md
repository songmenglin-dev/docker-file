---
title: getPeerIP()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1561538069-edition_id-304
---

## 名称

getPeerIP - 获取远程主机的 IP 地址

## 语法

**getPeerIP()**

## 类别

Ssh

## 描述

获取远程主机的 IP 地址。

## 参数

无

## 返回值

返回远程主机的 IP 地址。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

  * 使用 SSH 方式连接主机，假设本地主机 IP 地址是“192.168.20.71”
        
        > var ssh = new Ssh( "192.168.20.72", "sdbadmin", "sdbadmin", 22 )

  * 获取远程主机 IP 地址。
        
        > ssh.getPeerIP()
        192.168.20.72
