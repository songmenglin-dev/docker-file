---
title: traceOff()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190811-edition_id-304
---

## 名称

traceOff - 关闭数据库引擎跟踪功能

## 语法

**db.traceOff( <dumpFile>, [isDumpLocal] )**

## 类别

Sdb

## 描述

该函数用于关闭数据库引擎跟踪功能，并将跟踪情况以二进制文件的形式导出。

## 参数

参数名 | 参数类型 | 默认值 | 描述 | 是否必填  
---|---|---|---|---  
dumpFile | string | \--- | 二进制文件的文件名称 | 是  
isDumpLocal | bool | false | 是否把二进制文件保存到客户端本地 | 否  
  
> Note：
> 
>   1. 参数 dumpFile 可以填写为空字符串，表示关闭数据库引擎跟踪功能，但是不导出二进制文件。如果指定文件为相对路径则存放于相应节点的数据目录中的 `diagpath` 目录中；
> 
>   2. traceOff 生成的文件会默认保存在被监控节点所在的主机上。如果参数 isDumpLocal 设置为 true，文件会保存在客户端本地。
> 
> 

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

如果出错抛异常，并输出错误信息，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。 关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

  * 关闭数据库引擎跟踪 /opt/sequoiadb/trace.dump
        
        > db.traceOff("/opt/sequoiadb/trace.dump")

  * 解析二进制文件可参考 [traceFmt()](/cn/sequoiadb-cat_id-1432190766-edition_id-304)
        
        > traceFmt( 0, "/opt/sequoiadb/trace.dump", "/opt/sequoiadb/trace_output" )
