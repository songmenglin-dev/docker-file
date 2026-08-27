---
title: clear()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1552035555-edition_id-304
---

## 名称

clear - 清除缓冲区内容

## 语法

**content.clear()**

## 类别

FileContent

## 描述

清除缓冲区内容

## 参数

无

## 返回值

无

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

  * 打开一个二进制文件，获取文件描述符
        
        > var file = new File( "/opt/sequoiadb/file.dump" )

  * 读取文件内容到 fileContent 对象中（详细可参考命令[File::readContent](/cn/sequoiadb-cat_id-1552035061-edition_id-304)）
        
        > var content = file.readContent( 10000 )

  * 清除缓冲区内容
        
        > content.clear()
