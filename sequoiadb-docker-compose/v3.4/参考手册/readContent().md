---
title: readContent()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1552035061-edition_id-304
---

## 名称

readContent - 读取二进制文件内容并存入 FileContent 对象

## 语法

**file.readContent([size])**

## 类别

File

## 描述

读取二进制文件内容并存入 FileContent 对象。

## 参数

参数名 | 参数类型 | 默认值 | 描述 | 是否必填  
---|---|---|---|---  
size | int | 默认读取当前文件游标之后的全部内容 | 请求读取的字节数 | 否  
  
## 返回值

返回读取的文件内容。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

  * 打开一个文件，获取文件描述符
        
        > var file = new File( "/opt/sequoiadb/file.dump" )

  * 读取二进制文件内容并存入 fileContent 对象中。
        
        > var content = file.readContent()
        > content instanceof FileContent   // 验证 content 是否为 FileContent 对象
        true
