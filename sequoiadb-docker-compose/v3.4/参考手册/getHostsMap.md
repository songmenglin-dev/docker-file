---
title: getHostsMap
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1560931322-edition_id-304
---

## 名称

getHostsMap - 获取 host 文件的 IP 与主机名的映射关系

## 语法

**System.getHostsMap()**

## 类别

System

## 描述

获取 host 文件的 IP 与主机名的映射关系

## 参数

无

## 返回值

返回 host 文件的 IP 与主机名的映射关系

## 错误

如果出错则抛异常，并输出错误信息，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

获取 host 文件的 IP 与主机名的映射关系
    
    
    > System.getHostsMap()
    {
        "Hosts": [
          {
            "ip": "127.0.0.1",
            "hostname": "localhost"
          },
          ...
        ]
    }
