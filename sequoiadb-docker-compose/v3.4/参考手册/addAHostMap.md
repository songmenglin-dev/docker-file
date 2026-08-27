---
title: addAHostMap
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1560930214-edition_id-304
---

## 名称

addAHostMap - 往 host 文件添加一条主机名到 IP 地址的映射关系

## 语法

**System.addAHostMap( <hostname>, <ip>, [isReplace] )**

## 类别

System

## 描述

往 host 文件添加一条主机名到 IP 地址的映射关系

## 参数

参数名 | 参数类型 | 默认值 | 描述 | 是否必填  
---|---|---|---|---  
hostname | string | \--- | 主机名 | 是  
ip | string | \--- | IP 地址 | 是  
isReplace | boolean | true | 是否替换目标映射关系 | 否  
  
## 返回值

无返回值。

## 错误

如果出错则抛异常，并输出错误信息，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

往 host 文件添加一条主机名到 IP 地址的映射关系
    
    
    > System.addAHostMap( "hostname", "1.1.1.1" )
