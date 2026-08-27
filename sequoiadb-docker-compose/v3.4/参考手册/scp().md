---
title: scp()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1552035084-edition_id-304
---

## 名称

scp - 远程拷贝文件

## 语法

**File.scp( <srcFile>,<dstFile>,[isreplace],[mode])**

## 类别

File

## 描述

远程拷贝文件。

## 参数

参数名 | 参数类型 | 默认值 | 描述 | 是否必填  
---|---|---|---|---  
srcFile | string | \--- | 源文件路径 | 是  
desFile | string | \--- | 目标文件路径 | 是  
isreplace | boolean | false | 是否替换目标文件 | 否  
mode | int | 0644 | 设置文件权限 | 否  
  
参数 srcFile 和 desFile 具体格式如下：
    
    
    ip:sdbcmPort@filepath
    hostname:sdbcmPort@filepath

> **Note :**
> 
> sdbcmport 是指 sdbcm 的端口号。如果参数 srcFile 和 desFile 中的 ip 或者 hostname 和 sdbcmPort 指的是客户端本地的 ip 或者 hostname 和 sdbcmport，则可以省略，直接填写 filepath 即可。

## 返回值

无返回值。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

从本地主机拷贝文件到远程主机上
    
    
    > File.scp( "/opt/sequoiadb/srcFile.txt", "192.168.20.71:11790@/opt/sequoiadb/desFile.txt" )
    Success to copy file from /opt/sequoiadb/srcFile.txt to 192.168.20.71:11790@/opt/sequoiadb/desFile.txt
