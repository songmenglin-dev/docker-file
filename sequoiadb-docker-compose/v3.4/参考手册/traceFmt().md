---
title: traceFmt()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190766-edition_id-304
---

## 名称

traceFmt - 解析 trace 日志

## 语法

**traceFmt( <formatType>, <input>, <output>)**

## 类别

Global

## 描述

该函数用于解析 trace 日志，并根据用户指定的格式化类型将结果输出至对应文件。

## 参数

  * formatType（ _number，必填_ ）

格式化类型，取值如下：

    * 0：输出 trace 日志的分析文件，包含线程的执行序列（flw 文件）、函数的执行时间分析（CSV 文件）、执行时间峰值（except 文件）和 trace 记录错误信息（error 文件）
    * 1：输出解析后的 trace 日志（fmt 文件）
  * input（ _string，必填_ ）

trace 日志所在路径

  * output（ _string，必填_ ） 

输出文件所在路径

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`traceFmt()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-3 | SDB_PERM | 权限错误 | 检查输入或输出文件的路径是否存在权限问题  
-4 | SDB_FNE | 文件不存在 | 检查输入文件是否存在  
-6 | SDB_INVALIDARG | 参数错误 | 检查输入的类型是否正确  
-189 | SDB_PD_TRACE_FILE_INVALID | 输入的文件不是 trace 日志 | 检查输入的文件是否为 [traceOff()](/cn/sequoiadb-cat_id-1432190811-edition_id-304) 导出的 trace 日志  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v1.0 及以上版本

## 示例

解析 trace 日志 `trace.dump`
    
    
    > traceFmt(0, "/opt/sequoiadb/trace.dump", "/opt/sequoiadb/trace_output")

> **Note:**
> 
> 如果需要查看当前程序的跟踪状态，可参考 [traceStatus()](/cn/sequoiadb-cat_id-1432190814-edition_id-304)。
