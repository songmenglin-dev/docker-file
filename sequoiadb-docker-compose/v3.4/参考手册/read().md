---
title: read()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1552035053-edition_id-304
---

## 名称

read - 读取文本文件

## 语法

**file.read([size])**

## 类别

File

## 描述

该函数用于读取指定的文本文件。

## 参数

size（ _number，选填_ ）

从当前的文件游标位置开始，需要读取的字节数，默认值为 1024

## 返回值

函数执行成功时，将返回读取的文件内容。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

  * 从文件 `file` 的游标位置开始，读取 1024 字节的内容
        
        > var file = new File("/opt/sequoiadb/file")
        > file.read()

  * 与 [getSize](/cn/sequoiadb-cat_id-1552714654-edition_id-304) 搭配使用，可读取文件 `file` 游标位置之后的全部内容
        
        > var file = new File("/opt/sequoiadb/file")
        > file.read(file.getSize("/opt/sequoiadb/file"))
